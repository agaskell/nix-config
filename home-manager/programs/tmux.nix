{ config, pkgs, lib, username, ... }:

{
  programs.tmux = {
    enable = true;

    # Start windows and panes at 1, not 0
    baseIndex = 1;
    
    # Enable mouse support
    mouse = true;
    
    # Use 256 color terminal
    terminal = "screen-256color";
    
    # Set prefix to Ctrl-a (like screen) instead of Ctrl-b
    prefix = "C-a";
    
    # Increase scrollback buffer size
    historyLimit = 10000;
    
    # Enable vi mode
    keyMode = "vi";
    
    # Faster command sequences
    escapeTime = 0;
    
    # Additional settings
    extraConfig = ''
      # Use fish from PATH dynamically (supports dev flakes)
      set-option -g default-command "fish"

      # Ensure PATH is properly updated in new windows (supports dev flakes)
      # Note: This inherits PATH from client, which can be corrupted by JAMF/CrowdStrike
      set-option -g update-environment "PATH"

      # Preserve base Nix profile paths even if client PATH is corrupted
      set-environment -g BASE_NIX_PATH "/etc/profiles/per-user/${username}/bin:/run/current-system/sw/bin"

      # Enable true colors
      set-option -ga terminal-overrides ",xterm-256color:Tc"
      set-option -ga terminal-overrides ",kitty:Tc"
      
      # Pane navigation with vim-like keys
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      
      # Resize panes with vim-like keys
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5
      
      # Split panes using | and -
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %
      
      # Reload config with r
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded!"
      
      # Quick pane cycling
      unbind ^A
      bind ^A select-pane -t :.+
      
      # Status bar customization
      set -g status-style 'bg=#1e1e2e fg=#cdd6f4'
      set -g status-left '#[fg=#89b4fa,bold] #S '
      set -g status-right '#[fg=#f38ba8] %H:%M #[fg=#a6e3a1] %d-%b-%y '
      set -g status-left-length 30
      
      # Active/inactive pane borders
      set -g pane-border-style 'fg=#45475a'
      set -g pane-active-border-style 'fg=#89b4fa'
      
      # Message styling
      set -g message-style 'fg=#cdd6f4 bg=#1e1e2e bold'
      
      # Copy mode vi bindings
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      bind-key -T copy-mode-vi r send-keys -X rectangle-toggle
      
      # macOS clipboard integration
      if-shell "uname | grep -q Darwin" {
        bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
        bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"
      }
    '';
    
    # Plugins
    plugins = with pkgs.tmuxPlugins; [
      sensible           # Sensible defaults
      yank              # Copy to system clipboard
      pain-control      # Better pane control
      {
        plugin = resurrect;  # Save/restore sessions
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-strategy-vim 'session'
          set -g @resurrect-strategy-nvim 'session'
        '';
      }
      {
        plugin = continuum;  # Automatic save/restore
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '15'
        '';
      }
    ];
  };
  
  # Also install useful tmux-related tools
  home.packages = with pkgs; [
    tmuxp  # tmux session manager
  ];
}