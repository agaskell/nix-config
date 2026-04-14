{ config, pkgs, lib, ... }:

{
  programs.kitty = {
    enable = true;
    package = pkgs.kitty;
    
    # Font configuration
    font = {
      name = "FiraCode Nerd Font";
      size = 16;
    };
    
    # Settings
    settings = {
      # Window settings
      window_padding_width = 10;
      
      # Shell configuration - use fish
      shell = "${pkgs.fish}/bin/fish";
      
      # Shell integration
      shell_integration = "enabled";
      
      # macOS specific settings
      macos_option_as_alt = "yes";
      macos_quit_when_last_window_closed = "no";
      macos_window_resizable = "yes";
      macos_thicken_font = 0;
      
      # Remove window decorations (title bar)
      hide_window_decorations = "titlebar-only";
      # Options: "no" (default), "yes" (remove all), "titlebar-only" (remove title bar but keep traffic lights)
      
      # Window layout
      remember_window_size = "yes";
      initial_window_width = 1200;
      initial_window_height = 800;
      
      # Tab bar
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      
      # Other settings
      enable_audio_bell = false;
      window_alert_on_bell = false;
      scrollback_lines = 50000;
      
      # Copy to clipboard on select
      copy_on_select = "yes";
      
      # URL detection (use defaults)
      detect_urls = "yes";
      
      # Performance
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = "yes";

      # Theme colors
      background = "#1e1c44";
      foreground = "#f8dbc0";
      selection_background = "#6f6a4e";
      selection_foreground = "#1e1c44";

      # Cursor
      cursor = "#eebf37";

      # Normal colors
      color0 = "#050404";
      color1 = "#bc0013";
      color2 = "#49b117";
      color3 = "#e6741d";
      color4 = "#0f49c6";
      color5 = "#665992";
      color6 = "#6fa497";
      color7 = "#f8dbc0";

      # Bright colors
      color8 = "#4e7bbf";
      color9 = "#fc5e59";
      color10 = "#9dff6e";
      color11 = "#efc11a";
      color12 = "#1896c6";
      color13 = "#9a5952";
      color14 = "#c8f9f3";
      color15 = "#f5f4fb";
    };
    
    # Key bindings
    keybindings = {
      # macOS standard shortcuts
      "cmd+c" = "copy_to_clipboard";
      "cmd+v" = "paste_from_clipboard";
      "cmd+n" = "new_os_window";
      "cmd+t" = "new_tab";
      "cmd+w" = "close_tab";
      "cmd+shift+w" = "close_os_window";
      "cmd+q" = "quit";
      
      # Tab navigation
      "cmd+1" = "goto_tab 1";
      "cmd+2" = "goto_tab 2";
      "cmd+3" = "goto_tab 3";
      "cmd+4" = "goto_tab 4";
      "cmd+5" = "goto_tab 5";
      "cmd+6" = "goto_tab 6";
      "cmd+7" = "goto_tab 7";
      "cmd+8" = "goto_tab 8";
      "cmd+9" = "goto_tab 9";
      
      # Font size
      "cmd+plus" = "change_font_size all +2.0";
      "cmd+minus" = "change_font_size all -2.0";
      "cmd+0" = "change_font_size all 0";
    };
  };
}
