{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    
    # oh-my-zsh configuration
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
        "macos"
        "z"            # Jump around directories
        "colored-man-pages"
        "command-not-found"
      ];
    };
    
    # Shell aliases (you can customize these)
    shellAliases = {
      # Nix/Darwin specific
      dr = "sudo darwin-rebuild switch --flake ~/nix-config";
      
      # Git shortcuts
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline";
    };
    
    # Additional zsh options
    initContent = ''
      # Add npm global packages to PATH
      export PATH="$HOME/.npm-global/bin:$PATH"

      # Add ~/.local/bin to PATH
      export PATH="$HOME/.local/bin:$PATH"

      # Claude Code Bedrock configuration (uncomment if using)
      # export CLAUDE_CODE_USE_BEDROCK=1
      # export AWS_PROFILE=default

      # Disable GSS encryption mode to fix macOS Kerberos issues with PostgreSQL
      export PGGSSENCMODE=disable

      # Custom prompt modifications (if you want)
      # setopt auto_cd              # cd by typing directory name if it's not a command
      setopt correct_all          # autocorrect commands
      setopt share_history        # share history between sessions
      setopt hist_ignore_all_dups # remove older duplicate entries from history
      setopt hist_reduce_blanks   # remove superfluous blanks from history items
      setopt inc_append_history   # save history entries as soon as they are entered

      # Better completion
      autoload -U compinit && compinit
    '';
  };
}
