{ config, pkgs, lib, ... }:

{
  # Install ghostty from nixpkgs (binary version for macOS)
  home.packages = [
    pkgs.ghostty-bin
  ];
  
  # Ghostty configuration
  xdg.configFile."ghostty/config".text = ''
    # Font settings
    font-family = FiraCode Nerd Font
    font-size = 18

    # Theme
    theme = Shades Of Purple
    
    # Window settings
    window-padding-x = 10
    window-padding-y = 10
    
    # Copy on select
    copy-on-select = clipboard
    
    # Shell integration
    shell-integration = detect
    shell-integration-features = cursor,sudo,title
  '';
}