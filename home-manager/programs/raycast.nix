{ config, pkgs, lib, ... }:

{
  # Install Raycast and setup script
  home.packages = with pkgs; [ 
    raycast
    
    (writeScriptBin "raycast-setup" ''
      #!${stdenv.shell}
      
      echo "Setting up Raycast..."
      
      # Check if Raycast is running
      if pgrep -x "Raycast" > /dev/null; then
        echo "Raycast is already running"
      else
        echo "Starting Raycast..."
        open -a Raycast
      fi
      
      # Disable Spotlight hotkey
      echo ""
      echo "Disabling Spotlight hotkey (Cmd+Space)..."
      # This disables the Spotlight menu keyboard shortcut
      /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:64:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist 2>/dev/null || echo "Note: You may need to disable Spotlight hotkey manually in System Preferences"
      
      # Note: Raycast hotkey must be set within Raycast preferences
      echo ""
      echo "IMPORTANT: To set Raycast to Cmd+Space:"
      echo "1. Open Raycast Preferences (Cmd+,)"
      echo "2. Go to General tab"
      echo "3. Click on 'Raycast Hotkey'"
      echo "4. Press Cmd+Space"
      echo ""
      echo "To disable Spotlight hotkey manually:"
      echo "System Settings → Keyboard → Keyboard Shortcuts → Spotlight"
      echo "→ Uncheck 'Show Spotlight search'"
      
      echo ""
      echo "Raycast Setup Guide:"
      echo "==================="
      echo ""
      echo "1. First Launch:"
      echo "   - Grant accessibility permissions when prompted"
      echo "   - Sign in with your Raycast account (optional, for sync)"
      echo ""
      echo "2. Hotkey Configuration:"
      echo "   - Default hotkey is Cmd+Space (replaces Spotlight)"
      echo "   - To change: Raycast Preferences → General → Raycast Hotkey"
      echo ""
      echo "3. Essential Commands to Try:"
      echo "   - Calculator: Just type math expressions (e.g., '2+2')"
      echo "   - App Launcher: Type app names to launch them"
      echo "   - File Search: Type 'f' then filename"
      echo "   - Clipboard History: Cmd+Shift+V"
      echo "   - Window Management: Type 'window' for options"
      echo "   - System Commands: Type 'system' for sleep, restart, etc."
      echo ""
      echo "4. Useful Extensions:"
      echo "   - Browse and install from: Cmd+Space → 'Store'"
      echo "   - Recommended: GitHub, Linear, Notion, Spotify"
      echo ""
      echo "5. Tips:"
      echo "   - Use Tab to autocomplete"
      echo "   - Cmd+K to see all actions for selected item"
      echo "   - Cmd+Enter to open in background"
      echo "   - Create custom hotkeys for frequent actions"
      echo ""
      echo "To disable Spotlight and use only Raycast:"
      echo "  System Preferences → Keyboard → Shortcuts → Spotlight"
      echo "  → Uncheck 'Show Spotlight search'"
    '')
  ];
}