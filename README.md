# Nix Configuration for macOS

This is a complete Nix-based system configuration for macOS using Nix Darwin and Home Manager. It provides a declarative setup for development tools, window management, terminal configuration, and more.

## 🔧 Before You Start - Required Customizations

Before using this configuration, you **must** update the following personal information:

### 1. Create Your Configuration File

Copy the example config and customize it:
```bash
cp config.nix.example config.nix
```

Then edit `config.nix` with your personal settings:
```nix
{
  username = "johndoe";           # Run: whoami
  hostname = "johns-macbook";     # Run: scutil --get ComputerName

  git = {
    name = "John Doe";
    email = "john@example.com";
  };
}
```

This single file contains all your personal configuration. It's gitignored so your settings stay private.

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
# Build and switch to the new configuration
sudo darwin-rebuild switch --flake .
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
This repo is designed to be cloned onto both personal and client/work machines. The
gitignored `config.nix` carries per-machine settings, including a `personal` boolean:

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