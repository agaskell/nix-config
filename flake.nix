{
  description = "Nix-based macOS configuration";

  inputs = {
    # Main nixpkgs repository
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # For macOS system management
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # For user environment management
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # ghostty.url = "github:ghostty-org/ghostty";  # Not available on Darwin yet
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager }:
  let
    # Load user configuration from config.nix
    # Copy config.nix.example to config.nix and customize
    userConfig = import ./config.nix;

    system = "aarch64-darwin";
    inherit (userConfig) hostname username;
  in
  {
    # macOS configuration
    darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
      inherit system;

      specialArgs = {
        inherit username userConfig;
        # inherit ghostty;  # Not available on Darwin yet
      };
      
      modules = [
        # System-level configuration
        ./darwin/configuration.nix
        
        # Integrate home-manager
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${username} = ./home-manager/home.nix;
            
            # Pass extra arguments to home-manager
            extraSpecialArgs = {
              inherit username userConfig;
              # inherit ghostty;  # Not available on Darwin yet
            };
          };
        }
      ];
    };

    # For convenience, provide a formatter
    formatter.${system} = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
  };
}
