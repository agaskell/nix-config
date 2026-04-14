# Nix Configuration for macOS

This is a complete Nix-based system configuration for macOS using Nix Darwin and Home Manager. It provides a declarative setup for development tools, window management, terminal configuration, and more.

## 🔧 Before You Start - Required Customizations

Before using this configuration, you **must** update the following personal information:

### 1. Per-Machine Configuration (`config.nix`)

`config.nix` holds per-machine settings (username, hostname, git identity,
the `personal` flag). It is **committed to the repo** with the canonical
owner's values, but each machine overrides it locally without committing —
see workflow below.

```nix
# config.nix (this file is committed)
{
  username = "andy";                   # whoami
  hostname = "Andys-MacBook-Pro";      # scutil --get LocalHostName
  git = {
    name  = "Andy Gaskell";
    email = "andy@zubago.com";
  };
  personal = true;                     # installs Signal/Discord/etc.
}
```

#### Per-machine workflow (`skip-worktree`)

Because `config.nix` is tracked, pure flake evaluation can see it (no
`--impure` needed). To keep local edits out of commits, use git's
`skip-worktree` bit:

```bash
# 1. After cloning on a new machine, edit config.nix with local values
#    (hostname, username, personal flag, etc.).
$EDITOR config.nix

# 2. Tell git to ignore future edits to this file on this machine.
git update-index --skip-worktree config.nix

# 3. Verify — git status should not list config.nix as modified.
git status
```

`skip-worktree` is a per-clone, per-file flag. It survives commits,
rebases, and pulls. `git commit -a` will not pick up the local edits.

##### Pulling upstream changes to config.nix

If the committed `config.nix` is ever updated (e.g., a new field is added),
your skip-worktree'd copy will conflict on pull. To resolve:

```bash
# Temporarily un-skip, pull, resolve, re-skip.
git update-index --no-skip-worktree config.nix
git stash                              # save local values
git pull
git stash pop                          # reapply local values (may conflict)
# ...resolve any conflicts...
git update-index --skip-worktree config.nix
```

##### Listing / undoing skip-worktree

```bash
git ls-files -v | grep '^S'            # list skip-worktree'd files
git update-index --no-skip-worktree config.nix   # undo
```

### 2. Update AWS Configuration (Optional)

**File: `home-manager/programs/aws.nix`**
- Update AWS account IDs, SSO URLs, and profile names to match your organization
- If you don't use AWS, you can remove this import from `home-manager/home.nix`

### 3. Claude Code (Not Managed by Nix)

Claude Code is intentionally **not** installed via Nix because it ships frequent
updates and the official installer manages its own auto-update flow. Install it
separately per the [Claude Code docs](https://docs.claude.com/en/docs/claude-code/setup);
the binary lands in `~/.local/bin/claude`, which is on PATH via `~/.zshrc`.

## 🚀 Installation Instructions

### Prerequisites
- macOS (Apple Silicon recommended)
- Nix package manager installed with flakes enabled
- Admin privileges for system-level changes

### Step 1: Clone and Customize
```bash
# Clone this repository
git clone <this-repo-url> ~/nix-config
cd ~/nix-config

# Make your customizations (see section above)
# Edit flake.nix, git.nix, aws.nix, etc.
```

### Step 2: Initial System Build
```bash
sudo darwin-rebuild switch --flake .
```

For the very first build (before `darwin-rebuild` is on your PATH):

```bash
sudo -H nix --extra-experimental-features 'nix-command flakes' \
  run github:LnL7/nix-darwin -- switch --flake .#<hostname>
```

If sudo complains that the repo isn't owned by current user (libgit2
error), also run once:

```bash
sudo git config --global --add safe.directory "$(pwd)"
```

### Step 3: Set Fish as Default Shell
The configuration will attempt to set Fish automatically, but you may need to do this manually:
```bash
# Add Fish to allowed shells
echo /run/current-system/sw/bin/fish | sudo tee -a /etc/shells

# Set as your default shell
chsh -s /run/current-system/sw/bin/fish
```

### Step 4: Configure AeroSpace Window Manager
```bash
# The AeroSpace app will be at:
open ~/.local/share/applications/AeroSpace.app

# Grant accessibility permissions when prompted
# System Settings → Privacy & Security → Accessibility → Add AeroSpace
```

### Step 5: Configure Hotkeys (Optional)
```bash
# Disable Spotlight to use Cmd+Space for Raycast
configure-hotkeys

# Then set up Raycast:
# 1. Open Raycast
# 2. Raycast Settings → General → Raycast Hotkey
# 3. Set to Cmd+Space
```

## 🛠 What's Included

### Development Tools
- **Neovim** - Modern Vim with plugins
- **Git** - With useful aliases and delta diff viewer
- **Docker** - via Colima (lightweight Docker alternative)
- **AWS CLI** - v2 with SSO configuration

### Terminal & Shell
- **Ghostty** - GPU-accelerated terminal
- **Brave** - Default web browser (run `set-brave-default` after first build)
- **Fish** - User-friendly shell with abbreviations
- **Tmux** - Terminal multiplexer
- **Starship** - Cross-shell prompt

### System Tools
- **AeroSpace** - i3-like tiling window manager
- **Raycast** - Spotlight replacement
- **Rectangle** - Window management
- Various CLI utilities: `ripgrep`, `bat`, `eza`, `htop`, etc.

### Fonts
- Nerd Fonts (JetBrains Mono, FiraCode, Hack, etc.)
- Inter, Source Code Pro

## 📝 Daily Usage

### System Management
```bash
# Update and rebuild system
cd ~/nix-config
nix flake update                    # Update dependencies
sudo darwin-rebuild switch --flake .  # Apply changes

# Search for packages
nix search nixpkgs <package-name>
```

### AeroSpace Window Manager
- **Alt + [A-Z]** - Switch to workspace (letter-based)
- **Alt + Shift + [A-Z]** - Move window to workspace
- **Alt + H/J/K/L** - Navigate between windows
- **Alt + Shift + H/J/K/L** - Move windows
- **Alt + F** - Toggle fullscreen
- **Alt + R** - Enter resize mode

Run `aerospace-help` for complete keybindings.

### Fish Shell Abbreviations
The configuration includes many useful abbreviations:
```fish
# Git shortcuts
g -> git
gs -> git status
gl -> git log --oneline
gp -> git push

# AWS shortcuts (if configured)
awsl -> aws sso login
s3ls -> aws s3 ls

# System shortcuts
ll -> eza -la
top -> btop
```

## 🔧 Customization

### Adding New Programs
1. Create a new file in `home-manager/programs/` (e.g., `myprogram.nix`)
2. Add the import to `home-manager/home.nix`
3. Rebuild: `sudo darwin-rebuild switch --flake .`

### Modifying Existing Configs
All program configurations are in separate files under `home-manager/programs/`. Edit the relevant file and rebuild.

### Adding Packages
Add packages to either:
- `darwin/configuration.nix` - System-wide packages
- `home-manager/home.nix` - User packages
- `home-manager/programs/personal-apps.nix` - Personal-only apps (Signal, Discord, etc.) gated behind `personal = true;` in `config.nix`

### Personal vs Client Machines
This repo is designed to be cloned onto both personal and client/work
machines. `config.nix` carries per-machine settings, including a `personal`
boolean. See the "Per-Machine Configuration" section above for the
`skip-worktree` workflow that keeps local edits out of commits.

- `personal = true;` — installs everything in `home-manager/programs/personal-apps.nix`
- `personal = false;` (or omitted) — skips that module entirely

Add anything you wouldn't want on a client machine to `personal-apps.nix`.

## 🐛 Troubleshooting

### Build Fails
```bash
# Check for syntax errors
nix flake check

# Build without switching
sudo darwin-rebuild build --flake .
```

### Fish Shell Issues
```bash
# Manually set fish shell
sudo chsh -s /run/current-system/sw/bin/fish $USER

# Or check current shell
echo $SHELL
```

### AeroSpace Not Working
- Ensure accessibility permissions are granted
- Check if the app is running: `ps aux | grep -i aerospace`
- Restart: `killall AeroSpace && open ~/.local/share/applications/AeroSpace.app`

### Permission Issues
```bash
# Fix common permission issues
sudo chown -R $(whoami) ~/nix-config
chmod 755 ~/nix-config
```

## 📚 Further Reading

- [Nix Darwin Documentation](https://github.com/LnL7/nix-darwin)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [AeroSpace Documentation](https://nikitabobko.github.io/AeroSpace/)

## 🤝 Contributing

Feel free to suggest improvements or report issues. This configuration is designed to be a starting point that you can customize for your needs.