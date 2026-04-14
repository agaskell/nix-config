# Nix Configuration - Quick Reference for Claude

This document provides essential context about this Nix-based macOS system configuration.

## System Overview

- **OS**: macOS (Darwin) on Apple Silicon (aarch64-darwin)
- **Nix Setup**: Flake-based configuration with Home Manager
- **Default Shell**: Fish (set via chsh, not just Nix)
- **Window Manager**: AeroSpace (i3-like tiling WM)
- **Terminal**: Kitty
- **Editor**: Neovim, Vim

## Directory Structure

```
~/nix-config/
├── flake.nix                    # Main flake configuration
├── flake.lock                   # Locked dependencies
├── darwin/
│   └── configuration.nix        # System-wide Darwin configuration
└── home-manager/
    ├── home.nix                 # Main Home Manager config
    └── programs/                # Individual program configurations
        ├── aerospace.nix        # Tiling window manager
        ├── fish.nix            # Fish shell config
        ├── ghostty.nix         # Ghostty terminal emulator
        ├── kitty.nix           # Terminal emulator
        ├── macos-hotkeys.nix   # System hotkey management
        ├── neovim.nix          # Neovim config
        ├── raycast.nix         # Spotlight replacement
        ├── set-default-terminal.nix
        ├── tmux.nix            # Terminal multiplexer config
        └── zsh.nix            # Zsh config (still available)
```

## Key Commands

### System Management
- **Rebuild system**: `sudo darwin-rebuild switch --flake .` (run from `~/nix-config`)
- **Update flake inputs**: `nix flake update`
- **Search packages**: `nix search nixpkgs <package>`

### Installed Tools
- **Terminal**: `kitty` (configured to use Fish shell)
- **Window Management**: AeroSpace is running (Alt+[A-Z] for workspaces)
- **App Launcher**: Raycast (Cmd+Space after configuration)
- **Code Editor**: `nvim`

## Important Configuration Details

### AeroSpace (Window Manager)
- **Config**: `~/.config/aerospace/aerospace.toml`
- **Key binding style**: i3-like with letter-based workspaces
- **Main modifier**: Alt (Option)
- **Help command**: `aerospace-help`

### Kitty Terminal
- **Font**: FiraCode Nerd Font
- **Shell**: Fish (configured in kitty.nix)
- **Window chrome**: Title bar removed (traffic lights remain)

### Fish Shell
- **Config managed by**: Home Manager
- **Set as default shell**: Yes (via chsh)
- **Path**: `/run/current-system/sw/bin/fish`

### Fonts
Installed via Nix in darwin/configuration.nix:
- Nerd Fonts: JetBrainsMono, FiraCode, Hack, DroidSansMono, 0xProto
- Standard fonts: Inter, Source Code Pro

## Known Issues & Workarounds

1. **awscli2 PINNED**: Currently pinned to version 2.28.1 in `home-manager/programs/aws.nix` due to build failures in 2.30.6. Check if nixpkgs has been updated to 2.31.11+ (which fixes the issue per https://github.com/NixOS/nixpkgs/pull/450333). If so, remove the pin and use `pkgs.awscli2` directly. Test with `nix eval nixpkgs#awscli2.version`.
2. **AeroSpace Accessibility**: The app is at `~/.local/share/applications/AeroSpace.app` (symlinked for updates)
3. **Spotlight conflicts**: Run `configure-hotkeys` to disable Spotlight's Cmd+Space
4. **Tmux + Dev Flakes**: If tmux hardcodes Nix store paths for shells, new windows/panes will fail after environment changes (dev flakes, rebuilds). Solution: Use dynamic PATH updates instead of hardcoded `default-shell` settings. See `home-manager/programs/tmux.nix:31` for the fix.

## Development Environments

This system supports Nix development flakes. See `DEV_FLAKE.md` for examples of creating reproducible development environments.

## Making Changes

1. All configuration changes should be made in the `.nix` files
2. After changes, run `sudo darwin-rebuild switch --flake .`
3. Some changes (like shell) may require logging out/in
4. For new programs, create a new file in `home-manager/programs/` and import it in `home.nix`

## Helper Scripts Available

- `aerospace-help` - Show AeroSpace keybindings
- `configure-hotkeys` - Disable Spotlight hotkeys
- `set-kitty-default` - Set Kitty as default terminal handler
- `raycast-setup` - Raycast configuration guide

## Philosophy

This configuration follows these principles:
- **Declarative**: Everything is defined in Nix files
- **Reproducible**: Can rebuild the exact same environment
- **Modular**: Each program has its own configuration file
- **User-specific**: Uses Home Manager for user configurations (not forcing system-wide)