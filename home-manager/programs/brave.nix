{ config, pkgs, lib, ... }:

{
  # Brave browser. Installed for everyone (not gated behind `personal`).
  home.packages = with pkgs; [
    brave

    # Helper to register Brave as the macOS default browser.
    # Run `set-brave-default` after first build (and after macOS prompts
    # asking to confirm the change). `duti` is provided by
    # set-default-terminal.nix.
    #
    # Alternative: add a home.activation step to run this automatically
    # on every rebuild. Not done here because activation would re-clobber
    # the user's manual choice every switch.
    (writeScriptBin "set-brave-default" ''
      #!${stdenv.shell}

      if ! command -v duti &> /dev/null; then
        echo "duti not found. Make sure set-default-terminal.nix is imported."
        exit 1
      fi

      duti -s com.brave.Browser http
      duti -s com.brave.Browser https
      duti -s com.brave.Browser .html all
      duti -s com.brave.Browser .htm  all
      echo "Brave set as default browser (http/https/.html/.htm)"
    '')
  ];
}
