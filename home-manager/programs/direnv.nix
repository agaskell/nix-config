{ config, pkgs, lib, ... }:

{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;

    # Silent mode - don't show "direnv: loading" messages
    config = {
      global.hide_env_diff = true;
    };
  };
}
