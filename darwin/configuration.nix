{ config, pkgs, lib, username, userConfig, ... }:

{
  # Basic system configuration
  system.stateVersion = 5; # nix-darwin version compatibility
  system.primaryUser = username; # Required for homebrew and other user-specific features

  nix.settings = {
    download-buffer-size = 524288000;
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "${username}" ];
  };

  # Home Manager configuration
  home-manager.backupFileExtension = "backup";

  # Create the user account
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
    shell = pkgs.fish;
    uid = userConfig.uid or 501;  # per-machine; set in config.nix (`id -u`)
  };

  # System packages available to all users
  environment.systemPackages = with pkgs; [
    # Shellz
    fish
    zsh

    # Essential tools
    curl
    git
    wget

    # Utilities
    bottom
    btop
    gotop
    htop

    # Development tools
    gcc
    gnumake
    neovim

    # Container tools
    podman  # Daemonless container runtime (Docker-compatible, better process management)
    podman-compose  # docker-compose alternative for Podman

    # Database clients
    postgresql_16.out  # PostgreSQL client tools only (psql, pg_dump, etc.)

    # Media tools
    ffmpeg

    # PAM modules
    pam-reattach  # Touch ID support in tmux
  ];

  environment.shells = [ pkgs.fish ];

  programs.fish = {
    enable = true;

    # Install fish-foreign-env plugin at system level for nix-darwin compatibility
    # This provides the 'fenv' command needed by /etc/fish/nixos-env-preinit.fish
    useBabelfish = true;
  };

  programs.zsh.enable = true;
  
  # Ensure fish is properly set as the default shell
  # postActivation is one of the fixed script names nix-darwin actually runs;
  # custom names under system.activationScripts type-check but are never
  # executed. Use -create (unconditional, unlike -change) and the stable
  # /run/current-system path so the login shell survives garbage collection.
  system.activationScripts.postActivation.text = ''
    echo "Configuring shell for ${username}..."
    dscl . -create /Users/${username} UserShell /run/current-system/sw/bin/fish
  '';

  # Keyboard settings
  system.keyboard = {
    enableKeyMapping = true;
    # Remap Caps Lock to Escape (great for vim users!)
    remapCapsLockToControl = true;
  };

  # Fonts (you can add more fonts here)
  fonts.packages = with pkgs; [
    # Nerd Fonts for terminal/coding
    nerd-fonts._0xproto
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.droid-sans-mono

    inter
    source-code-pro
  ];

  # Security settings & PAM configuration
  # Enable pam-reattach for Touch ID in tmux
  environment.etc."pam.d/sudo_local".text = ''
    # sudo_local: local config file which survives system update and is included for sudo
    # pam_reattach: Reattach to user's GUI session for Touch ID in tmux
    auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so
    auth       sufficient     pam_tid.so
  '';

  # Allow unfree packages (needed for some software)
  nixpkgs.config.allowUnfree = true;

  # Make user-installed apps (Ghostty, etc.) available on PATH
  environment.systemPath = [ "/etc/profiles/per-user/${username}/bin" ];
  
  # System applications - these get symlinked to /Applications/Nix Apps
  system.build.applications = pkgs.buildEnv {
    name = "system-applications";
    paths = config.environment.systemPackages;
    pathsToLink = [ "/Applications" ];
  };
}
