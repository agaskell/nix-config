{ config, pkgs, lib, ... }:

{
  # Script to configure macOS hotkeys
  home.packages = with pkgs; [
    (writeScriptBin "configure-hotkeys" ''
      #!${stdenv.shell}
      
      echo "Configuring macOS hotkeys..."
      
      # Disable Spotlight search hotkey (Cmd+Space)
      echo "Disabling Spotlight Cmd+Space hotkey..."
      defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "<dict><key>enabled</key><false/></dict>"
      
      # Disable Spotlight window hotkey (Option+Cmd+Space) 
      echo "Disabling Spotlight Option+Cmd+Space hotkey..."
      defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 65 "<dict><key>enabled</key><false/></dict>"
      
      # Apply changes
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
      
      echo ""
      echo "✓ Spotlight hotkeys disabled"
      echo ""
      echo "Now set Raycast to use Cmd+Space:"
      echo "1. Open Raycast (currently Option+Space)"
      echo "2. Press Cmd+, for preferences"
      echo "3. In General tab, click 'Raycast Hotkey'"
      echo "4. Press Cmd+Space"
      echo ""
      echo "You may need to log out and back in for all changes to take effect."
    '')
  ];
  
  # Activation script to remind user about hotkey configuration
  home.activation.raycastHotkeyReminder = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if ! grep -q "raycast-hotkey-configured" ~/.config/nix-configured-flags 2>/dev/null; then
      echo ""
      echo "=== Raycast Hotkey Configuration ==="
      echo "To use Cmd+Space for Raycast:"
      echo "1. Run: configure-hotkeys"
      echo "2. Open Raycast and set hotkey to Cmd+Space"
      echo ""
      echo "To skip this reminder, run:"
      echo "mkdir -p ~/.config/nix-configured-flags"
      echo "touch ~/.config/nix-configured-flags/raycast-hotkey-configured"
      echo "===================================="
    fi
  '';
}