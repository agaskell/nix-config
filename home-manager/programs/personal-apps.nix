{ pkgs, ... }:

{
  # Personal-machine-only apps. Imported from home.nix only when
  # `userConfig.personal` is true in config.nix. Add to this list as needed.
  home.packages = with pkgs; [
    discord
  ];
}
