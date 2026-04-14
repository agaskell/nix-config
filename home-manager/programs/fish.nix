{ config, pkgs, username, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting

      # Ensure base Nix paths are always present (defense against JAMF/CrowdStrike PATH corruption)
      if not contains /etc/profiles/per-user/${username}/bin $PATH
        set -gx PATH /etc/profiles/per-user/${username}/bin $PATH
      end
      if not contains /run/current-system/sw/bin $PATH
        set -gx PATH /run/current-system/sw/bin $PATH
      end

      # Add npm global packages to PATH (only if not already present)
      if not contains ~/.npm-global/bin $PATH
        set -gx PATH ~/.npm-global/bin $PATH
      end

      # Add ~/.local/bin to PATH (only if not already present)
      if not contains ~/.local/bin $PATH
        set -gx PATH ~/.local/bin $PATH
      end
    '';
    
    shellAliases = {
      # Darwin rebuild shortcut. --impure is required because config.nix is
      # gitignored (per-machine settings); pure flake eval only sees tracked
      # files.
      dr = "sudo darwin-rebuild switch --flake ~/nix-config --impure";

      # Container/Docker aliases
      docker = "podman";
      docker-compose = "podman-compose";

      # Other common aliases
      ll = "ls -la";
      la = "ls -a";
      l = "ls -l";

      # Git shortcuts (in addition to git.nix aliases)
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";

      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
    };
  };

  home.sessionVariables = {
    SHELL = "${pkgs.fish}/bin/fish";
    # CLAUDE_CODE_USE_BEDROCK = "1";  # Uncomment if using AWS Bedrock for Claude
    # AWS_PROFILE = "default";  # Set your default AWS profile
    # Disable GSS encryption mode to fix macOS Kerberos issues with PostgreSQL
    PGGSSENCMODE = "disable";
  };

  # Podman Docker compatibility - set DOCKER_HOST dynamically
  programs.fish.loginShellInit = ''
    # Set DOCKER_HOST for Podman if machine is running
    if test -S $TMPDIR/podman/podman-machine-default-api.sock
      set -gx DOCKER_HOST "unix://$TMPDIR/podman/podman-machine-default-api.sock"
    end
  '';
}
