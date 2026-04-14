{ config, pkgs, lib, ... }:

{
  # Helper to register Ghostty as the default handler for terminal-related
  # URL schemes on macOS. Run `set-ghostty-default` after first build.
  home.packages = with pkgs; [
    duti  # Tool for setting default applications on macOS

    (writeScriptBin "set-ghostty-default" ''
      #!${stdenv.shell}

      if command -v duti &> /dev/null; then
        duti -s com.mitchellh.ghostty ssh
        duti -s com.mitchellh.ghostty telnet
        duti -s com.mitchellh.ghostty x-man-page
        echo "Ghostty set as default terminal handler"
      else
        echo "duti not found. Make sure this module is imported."
        exit 1
      fi
    '')
  ];
}
