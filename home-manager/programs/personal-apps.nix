{ config, pkgs, lib, ... }:

{
  # Personal-machine-only apps. Imported from home.nix only when
  # `userConfig.personal` is true in config.nix. Add to this list as needed.
  home.packages = with pkgs; [
    discord
    # obsidian  # removed 2026-08: nixpkgs 1.13.4 darwin build is broken (DMG
    #           # layout changed; sourceRoot mismatch). Re-add once fixed upstream.
  ];

  # Discord's built-in updater writes to its .app bundle, which fails in
  # the read-only Nix store and blocks launch. Discord reads a
  # SKIP_HOST_UPDATE boolean from ~/Library/Application Support/discord/
  # settings.json; setting it true makes Discord skip the host-update
  # check entirely. Merge (rather than clobber) so Discord's own UI
  # preferences stored in the same file survive rebuilds.
  home.activation.discordDisableUpdates = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    settings="$HOME/Library/Application Support/discord/settings.json"
    mkdir -p "$(dirname "$settings")"
    patch='{SKIP_HOST_UPDATE: true, SKIP_MODULE_UPDATE: true}'
    if [ -f "$settings" ]; then
      tmp="$(mktemp)"
      ${pkgs.jq}/bin/jq ". + $patch" "$settings" > "$tmp" && mv "$tmp" "$settings"
    else
      echo "{\"SKIP_HOST_UPDATE\": true, \"SKIP_MODULE_UPDATE\": true}" > "$settings"
    fi
  '';
}
