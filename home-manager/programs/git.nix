{ config, pkgs, userConfig, ... }:

{
  programs.git = {
    enable = true;

    # Ignore global files
    ignores = [
      # macOS
      ".DS_Store"
      "._*"
      ".Spotlight-V100"
      ".Trashes"

      # Editors
      "*.swp"
      "*.swo"
      "*~"
      ".idea/"
      ".vscode/"
      "*.sublime-*"

      # Languages
      "__pycache__/"
      "*.pyc"
      "node_modules/"
      "*.log"

      # Nix
      "result"
      "result-*"

      # Secrets (be careful!)
      ".env"
      ".env.local"
      "*.pem"
      "*.key"
    ];

    # Git Large File Storage (optional)
    lfs = {
      enable = false;  # Set to true if you use Git LFS
    };

    # Signing commits (optional)
    signing = {
      key = null;  # TODO: Set to your GPG key ID if you sign commits
      signByDefault = false;  # Set to true to sign all commits
    };

    # All configuration now goes in settings (renamed from extraConfig)
    settings = {
      # User information from config.nix
      user = {
        name = userConfig.git.name;
        email = userConfig.git.email;
      };

      # Aliases (renamed from aliases)
      alias = {
        # Status and info
        st = "status -sb";
        s = "status -sb";

        # Logging
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        ll = "log --pretty=format:'%C(yellow)%h%Cred%d %Creset%s%Cblue [%cn]' --decorate --numstat";
        last = "log -1 HEAD --stat";

        # Branching
        co = "checkout";
        br = "branch";
        bra = "branch -a";

        # Committing
        c = "commit";
        cm = "commit -m";
        ca = "commit --amend";
        can = "commit --amend --no-edit";

        # Diffing
        d = "diff";
        dc = "diff --cached";
        ds = "diff --stat";

        # Staging
        a = "add";
        aa = "add --all";
        ap = "add --patch";

        # Undoing
        unstage = "reset HEAD --";
        undo = "reset --soft HEAD~1";

        # Stashing
        sl = "stash list";
        sp = "stash pop";
        ss = "stash save";

        # Remote operations
        f = "fetch";
        pl = "pull";
        ps = "push";
        psu = "push -u origin HEAD";  # Push and set upstream

        # Cleaning
        clean-branches = "!git branch --merged | grep -v '\\*\\|main\\|master\\|develop' | xargs -n 1 git branch -d";

        # Finding
        find = "!git log --pretty=\"format:%Cgreen%H %Cblue%s\" --name-status --grep";

        # Worktree
        wt = "worktree";
        wta = "worktree add";
        wtl = "worktree list";
        wtr = "worktree remove";
      };

      init.defaultBranch = "main";

      core = {
        editor = "nvim";
        autocrlf = "input";
        whitespace = "trailing-space,space-before-tab";
      };

      pull = {
        rebase = false;  # Use merge when pulling
        ff = "only";    # Fast-forward only
      };

      push = {
        default = "current";  # Push the current branch to a branch of the same name
        autoSetupRemote = true;  # Automatically set up remote tracking
      };

      merge = {
        conflictstyle = "diff3";  # Show common ancestor in merge conflicts
        tool = "vimdiff";  # TODO: Change to your preferred merge tool
      };

      diff = {
        colorMoved = "default";  # Highlight moved lines in diffs
        algorithm = "patience";  # Better diff algorithm
      };

      rebase = {
        autoStash = true;  # Automatically stash/unstash when rebasing
        autoSquash = true;  # Automatically squash fixup! commits
      };

      rerere = {
        enabled = true;  # Remember how conflicts were resolved
      };

      # Better log output
      format = {
        pretty = "format:%C(yellow)%h %C(blue)%ad %C(reset)%s%C(red)%d %C(green)%an %C(reset)";
      };

      # URL shorthands
      url = {
        "git@github.com:" = {
          insteadOf = "gh:";
        };
        "git@gitlab.com:" = {
          insteadOf = "gl:";
        };
      };
    };
  };

  # Delta - Better diff viewer (moved to separate program)
  programs.delta = {
    enable = true;
    enableGitIntegration = true;  # Explicitly enable Git integration
    options = {
      navigate = true;
      light = false;  # Set to true for light terminal backgrounds
      side-by-side = true;
      line-numbers = true;
    };
  };
  
  # Additional git-related packages
  home.packages = with pkgs; [
    git-lfs        # Large file storage
    tig            # Text-mode interface for git
    lazygit        # Terminal UI for git
    gh             # GitHub CLI
    glab           # GitLab CLI
    git-absorb     # Automatically absorb staged changes into your current branch
  ];
}
