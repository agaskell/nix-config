{ config, pkgs, lib, ... }:

{
  # Install Aerospace - i3-like tiling window manager for macOS
  home.packages = with pkgs; [ 
    aerospace
    
    # Helper script for aerospace commands
    (writeScriptBin "aerospace-help" ''
      #!${stdenv.shell}
      echo "Aerospace Keybindings (i3-style):"
      echo "================================="
      echo ""
      echo "Window Focus:"
      echo "  Alt+h/j/k/l     - Focus left/down/up/right"
      echo ""
      echo "Window Movement:"
      echo "  Alt+Shift+h/j/k/l - Move window left/down/up/right"
      echo ""
      echo "Workspaces:"
      echo "  Alt+[A-Z]       - Switch to letter workspace (F=Firefox, T=Terminal, etc)"
      echo "  Alt+[4-9]       - Switch to number workspace (1-3 reserved for layouts)"
      echo "  Alt+Shift+[A-Z] - Move window to letter workspace"
      echo "  Alt+Shift+[1-9] - Move window to number workspace"
      echo ""
      echo "Layout:"
      echo "  Alt+Shift+Return - Fullscreen"
      echo "  Alt+1           - Tiling layout (default)"
      echo "  Alt+2           - Stacking-like layout"
      echo "  Alt+3           - Tabbed-like layout"
      echo "  Alt+Shift+Space - Toggle floating"
      echo ""
      echo "Container Management:"
      echo "  Alt+\\           - Join with window below (vertical)"
      echo "  Alt+-           - Join with window to the right (horizontal)"
      echo ""
      echo "Other:"
      echo "  Cmd+Return      - Launch terminal (ghostty)"
      echo "  Alt+Enter       - Launch terminal (ghostty) (alternate)"
      echo "  Alt+Shift+Semicolon - Enter resize mode"
      echo "  Alt+Ctrl+Shift+R - Reload config"
      echo "  Cmd+Q           - Close window (macOS default)"
      echo ""
      echo "Resize Mode:"
      echo "  h/j/k/l         - Resize by 50px"
      echo "  Shift+h/j/k/l   - Resize by 100px"
      echo "  Escape/Enter    - Exit resize mode"
    '')
  ];
  
  # Aerospace configuration
  home.file.".config/aerospace/aerospace.toml" = {
    text = ''
      # Aerospace configuration - i3-like tiling window manager for macOS
      # Documentation: https://github.com/nikitabobko/AeroSpace/blob/main/docs/config.md
      
      # Start Aerospace at login
      start-at-login = true
      
      # Default layout settings
      default-root-container-layout = 'tiles'
      default-root-container-orientation = 'auto'
      
      # Mouse follows focus
      on-focused-monitor-changed = ['move-mouse monitor-lazy-center']
      
      # Enable normalizations (required for modern Aerospace)
      enable-normalization-flatten-containers = true
      enable-normalization-opposite-orientation-for-nested-containers = true
      
      # Gaps configuration
      [gaps]
      inner.horizontal = 5
      inner.vertical = 5
      outer.left = 5
      outer.bottom = 5
      outer.top = 5
      outer.right = 5
      
      # Keybindings (i3-style with macOS modifier keys)
      # Using alt (option) as the main modifier like i3 uses Super/Alt
      [mode.main.binding]
      
      # Focus windows
      alt-h = 'focus left'
      alt-j = 'focus down'
      alt-k = 'focus up'
      alt-l = 'focus right'
      
      # Move windows
      alt-shift-h = 'move left'
      alt-shift-j = 'move down'
      alt-shift-k = 'move up'
      alt-shift-l = 'move right'
      
      # Join with direction (replaces split in modern Aerospace)
      alt-minus = 'join-with right'  # Horizontal join (was alt-b)
      alt-backslash = 'join-with down'  # Vertical join (was alt-v)
      
      # Fullscreen
      alt-shift-enter = 'fullscreen'
      
      # Container layouts (using number keys to avoid conflicts)
      alt-1 = 'layout tiles'        # Tiling (default)
      alt-2 = 'layout v_accordion'  # Stacking-like
      alt-3 = 'layout h_accordion'  # Tabbed-like
      
      # Floating
      alt-shift-space = 'layout floating tiling'  # Toggle floating
      
      # Workspace switching - Letters (h,j,k,l reserved for navigation)
      alt-a = 'workspace A'  # General workspace
      alt-b = 'workspace B'  # Browser (secondary)
      alt-c = 'workspace C'  # Code
      alt-d = 'workspace D'  # Documentation
      alt-e = 'workspace E'  # Email/Communication
      alt-f = 'workspace F'  # Firefox
      alt-g = 'workspace G'  # General
      # alt-h reserved for focus left
      alt-i = 'workspace I'  # IDE/Development
      # alt-j reserved for focus down
      # alt-k reserved for focus up
      # alt-l reserved for focus right
      alt-m = 'workspace M'  # Music/Media
      alt-n = 'workspace N'  # Notes
      alt-o = 'workspace O'  # Other
      alt-p = 'workspace P'  # Preview/PDF
      alt-q = 'workspace Q'  # Quick workspace
      alt-r = 'workspace R'  # Reference/Research
      alt-s = 'workspace S'  # Slack/Social
      alt-t = 'workspace T'  # Terminal (ghostty)
      alt-u = 'workspace U'  # Utilities
      alt-v = 'workspace V'  # Vim/Editor
      alt-w = 'workspace W'  # Web/Browser
      alt-x = 'workspace X'  # Extra
      alt-y = 'workspace Y'  # Youtube/Video
      alt-z = 'workspace Z'  # Zoom/Meetings
      
      # H,J,K,L workspaces - removed to avoid conflicts with navigation
      
      # Number workspaces (4-9 to avoid conflict with layouts)
      alt-4 = 'workspace 4'
      alt-5 = 'workspace 5'
      alt-6 = 'workspace 6'
      alt-7 = 'workspace 7'
      alt-8 = 'workspace 8'
      alt-9 = 'workspace 9'
      
      # Move window to workspace - Letters (h,j,k,l reserved for window movement)
      alt-shift-a = 'move-node-to-workspace A'
      alt-shift-b = 'move-node-to-workspace B'
      alt-shift-c = 'move-node-to-workspace C'
      alt-shift-d = 'move-node-to-workspace D'
      alt-shift-e = 'move-node-to-workspace E'
      alt-shift-f = 'move-node-to-workspace F'
      alt-shift-g = 'move-node-to-workspace G'
      # alt-shift-h reserved for move left
      alt-shift-i = 'move-node-to-workspace I'
      # alt-shift-j reserved for move down
      # alt-shift-k reserved for move up
      # alt-shift-l reserved for move right
      alt-shift-m = 'move-node-to-workspace M'
      alt-shift-n = 'move-node-to-workspace N'
      alt-shift-o = 'move-node-to-workspace O'
      alt-shift-p = 'move-node-to-workspace P'
      alt-shift-q = 'move-node-to-workspace Q'
      alt-shift-r = 'move-node-to-workspace R'
      alt-shift-s = 'move-node-to-workspace S'
      alt-shift-t = 'move-node-to-workspace T'
      alt-shift-u = 'move-node-to-workspace U'
      alt-shift-v = 'move-node-to-workspace V'
      alt-shift-w = 'move-node-to-workspace W'
      alt-shift-x = 'move-node-to-workspace X'
      alt-shift-y = 'move-node-to-workspace Y'
      alt-shift-z = 'move-node-to-workspace Z'
      
      # Move window to H,J,K,L workspaces - removed (now using alt-ctrl-[hjkl])
      
      # Move window to workspace - Numbers
      alt-shift-4 = 'move-node-to-workspace 4'
      alt-shift-5 = 'move-node-to-workspace 5'
      alt-shift-6 = 'move-node-to-workspace 6'
      alt-shift-7 = 'move-node-to-workspace 7'
      alt-shift-8 = 'move-node-to-workspace 8'
      alt-shift-9 = 'move-node-to-workspace 9'
      
      # Resize mode
      alt-shift-semicolon = 'mode resize'
      
      # Restart Aerospace
      alt-ctrl-shift-r = 'reload-config'
      
      # Terminal launch
      cmd-enter = 'exec-and-forget ${pkgs.ghostty-bin}/Applications/Ghostty.app/Contents/MacOS/ghostty'
      alt-enter = 'exec-and-forget ${pkgs.ghostty-bin}/Applications/Ghostty.app/Contents/MacOS/ghostty'  # Alternative binding
      
      # Resize mode keybindings
      [mode.resize.binding]
      h = 'resize width -50'
      j = 'resize height +50'
      k = 'resize height -50'
      l = 'resize width +50'
      
      # Larger resize steps
      shift-h = 'resize width -100'
      shift-j = 'resize height +100'
      shift-k = 'resize height -100'
      shift-l = 'resize width +100'
      
      # Exit resize mode
      esc = 'mode main'
      enter = 'mode main'
      
      # Workspace to monitor assignment (optional - customize as needed)
      # [workspace-to-monitor-force-assignment]
      # F = 'main'     # Firefox on main monitor
      # T = 'main'     # Terminal on main monitor
      # C = 'main'     # Code on main monitor
      # S = 'secondary' # Slack on secondary monitor if available
      
      # Window rules (like i3 for_window)
      [[on-window-detected]]
      if.app-id = 'com.apple.finder'
      run = 'layout floating'
      
      [[on-window-detected]]
      if.app-id = 'com.apple.systempreferences'
      run = 'layout floating'
      
      [[on-window-detected]]
      if.app-id = 'com.apple.Preview'
      run = 'layout floating'
    '';
  };
}