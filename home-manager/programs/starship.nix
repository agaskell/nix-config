{ config, pkgs, lib, ... }:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    
    settings = {
      command_timeout = 1000;

      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_status"
        "$c"
        "$elixir"
        "$elm"
        "$golang"
        "$haskell"
        "$java"
        "$julia"
        "$nodejs"
        "$nim"
        "$rust"
        "$scala"
        "$python"
        "$nix_shell"
        "$docker_context"
        "$memory_usage"
        "$aws"
        "$gcloud"
        "$env_var"
        "$cmd_duration"
        "$line_break"
        "$jobs"
        "$battery"
        "$time"
        "$status"
        "$shell"
        "$character"
      ];
      
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        format = "[$path]($style)[$read_only]($read_only_style) ";
      };
      
      git_branch = {
        format = "[$symbol$branch]($style) ";
        symbol = " ";
      };
      
      git_status = {
        format = "([\\[$all_status$ahead_behind\\]]($style) )";
      };
      
      python = {
        format = "via [🐍 $version( \\($virtualenv\\))]($style) ";
        detect_extensions = ["py"];
        detect_files = [".python-version" "Pipfile" "pyproject.toml" "requirements.txt" "setup.py" "tox.ini"];
      };
      
      nix_shell = {
        format = "via [❄️ $name]($style) ";
        symbol = "❄️ ";
      };
      
      aws = {
        format = "on [$symbol($profile )(\\($region\\) )]($style)";
        symbol = "☁️ ";
      };
      
      cmd_duration = {
        min_time = 3000;
        format = "took [$duration]($style) ";
      };
      
      time = {
        disabled = false;
        format = "at [$time]($style) ";
        time_format = "%R"; # Hour:Minute Format
      };
    };
  };
}