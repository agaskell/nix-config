{ config, pkgs, lib, ... }:

{
  # Create a script to set kitty as the default terminal and install duti
  home.packages = with pkgs; [
    duti  # Tool for setting default applications on macOS
    
    (writeScriptBin "set-kitty-default" ''
      #!${stdenv.shell}
      
      # Set kitty as the default terminal using duti
      # First, check if duti is available
      if command -v duti &> /dev/null; then
        # Set kitty as default for various URL schemes
        duti -s net.kovidgoyal.kitty ssh
        duti -s net.kovidgoyal.kitty telnet
        duti -s net.kovidgoyal.kitty x-man-page
        echo "Kitty set as default terminal handler"
      else
        echo "duti not found. Install it with: nix-env -iA nixpkgs.duti"
      fi
      
      # Also create an alias for opening new terminal windows
      echo "You can now use 'kitty' command to open a new terminal"
    '')
  ];
  
  # Create launch agent to ensure kitty can be launched
  launchd.agents.kitty-launcher = {
    enable = false;  # Disabled by default, can be enabled if needed
    config = {
      ProgramArguments = [ "${pkgs.kitty}/bin/kitty" ];
      RunAtLoad = false;
      KeepAlive = false;
    };
  };
}