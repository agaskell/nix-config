{ config, pkgs, lib, ... }:

{
  # Jira CLI - Interactive command-line tool for Atlassian Jira
  home.packages = with pkgs; [
    jira-cli-go
  ];

  # Shell aliases for common Jira operations
  programs.fish.shellAbbrs = {
    # Issue management
    jil = "jira issue list";
    jiv = "jira issue view";
    jic = "jira issue create --no-input";
    jie = "jira issue edit";

    # Quick actions
    jia = "jira issue assign";
    jim = "jira issue move";

    # Sprint management
    jsl = "jira sprint list";
    jsa = "jira sprint add";
  };

  # Environment variables for Jira CLI
  home.sessionVariables = {
    # Optional: Set default config file location
    # JIRA_CONFIG_FILE = "$HOME/.config/jira/config.yml";

    # Set your Jira API token here or use environment variable
    # JIRA_API_TOKEN = "your-api-token-here";
    JIRA_AUTH_TYPE = "bearer";
  };

  # Ensure Jira config directory exists
  home.activation.ensureJiraDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -d "$HOME/.config/.jira" ]; then
      mkdir -p "$HOME/.config/.jira"
      chmod 700 "$HOME/.config/.jira"
    fi
  '';

  # Manage Jira CLI configuration file
  # Update with your Jira server details
  home.file.".config/.jira/.config.yml".text = ''
    auth_type: bearer
    board:
        id: 1
        name: 'My Board'
        type: kanban
    installation: Local
    login: your-username
    project:
        key: PROJ
        type: ""
    server: https://your-jira-instance.atlassian.net
    timezone: America/New_York
  '';

  # Note: Configuration is managed declaratively by Nix
  # The .config.yml file above contains the basic configuration.
  # Additional fields (like custom field mappings) are automatically
  # populated by jira-cli on first run via the /rest/api/2/field endpoint.
  #
  # To update the default project or board:
  #   1. Update the home.file.".config/.jira/.config.yml".text above
  #   2. Run: home-manager switch
  #
  # For non-interactive/headless usage:
  #   - Use --no-input flag to skip prompts
  #   - Use --plain, --raw, or --csv for machine-readable output
  #
  # Example commands:
  #   jira issue create -s"Bug title" -yHigh -lbug --no-input
  #   jira issue list --plain
  #   jira issue view PROJ-123 --raw | jq '.fields.status.name'
}
