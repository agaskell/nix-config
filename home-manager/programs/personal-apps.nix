{ config, pkgs, lib, ... }:

{
  # Personal-machine-only apps. Imported from home.nix only when
  # `userConfig.personal` is true in config.nix. Add to this list as needed.
  home.packages = with pkgs; [
    # discord  # removed 2026-09: the nixpkgs darwin build adds modules inside
    #          # the signed bundle (Gatekeeper: "damaged"), and re-signing it
    #          # loses Discord's identity so macOS blocks its data folder.
    #          # Install the official app from discord.com instead; it
    #          # updates itself.
    # obsidian  # removed 2026-08: nixpkgs 1.13.4 darwin build is broken (DMG
    #           # layout changed; sourceRoot mismatch). Re-add once fixed upstream.
  ];
}
