{ config, pkgs, lib, username, userConfig, ... }:

{
  # Home Manager version compatibility
  home.stateVersion = "25.05";

  # Basic user info
  home.username = username;
  home.homeDirectory = "/Users/${username}";

  imports = [
    ./programs/aerospace.nix
    ./programs/aws.nix
    ./programs/brave.nix
    ./programs/dbeaver.nix
    ./programs/direnv.nix
    ./programs/fish.nix
    ./programs/ghostty.nix
    ./programs/git.nix
    ./programs/jira-cli.nix
    ./programs/macos-hotkeys.nix
    ./programs/neovim.nix
    ./programs/raycast.nix
    ./programs/set-default-terminal.nix
    ./programs/starship.nix
    ./programs/tmux.nix
    ./programs/vim.nix
    ./programs/zsh.nix
  ] ++ lib.optional (userConfig.personal or false) ./programs/personal-apps.nix;

  # Minimal packages
  home.packages = with pkgs; [
    bat
    bottom
    btop
    curl
    delta
    eza
    jq
    # ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
    htop
    just
    nixpkgs-fmt
    nodejs_24  # Current LTS - needed for npm installs
    rectangle
    ripgrep
    terraform
    tflint
    tree
    zoxide
  ];

  # Enable home-manager to manage itself
  programs.home-manager.enable = true;
}
