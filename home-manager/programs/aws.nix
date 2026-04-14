{ config, pkgs, lib, ... }:

let
  # Pin awscli2 to version 2.28.1 (last working version before 2.30.6)
  nixpkgs-awscli-pin = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/de74240d03acfd332c99dce42fc93239dcaa9cdf.tar.gz";
    sha256 = "1m1r2r8048wfp27jzwsjry4m062vmwj353qha5r4vwv43dng72k6";
  }) { system = pkgs.stdenv.hostPlatform.system; };
in
{
  # AWS CLI v2
  home.packages = with pkgs; [
    nixpkgs-awscli-pin.awscli2
    
    # Optional: Additional AWS tools
    aws-vault      # Secure credential storage
    aws-sso-cli    # Better SSO experience
    ssm-session-manager-plugin  # For SSM sessions
  ];
  
  # Basic AWS configuration (non-sensitive)
  # This creates ~/.aws/config with safe defaults
  # Update with your own AWS SSO configuration
  home.file.".aws/config".text = ''
    [default]
    cli_history = enabled
    cli_pager =
    output = json
    region = us-east-1

    # Example SSO configuration - update with your organization's details
    # [sso-session my-sso]
    # sso_start_url = https://your-org.awsapps.com/start
    # sso_region = us-east-1
    # sso_registration_scopes = sso:account:access

    # Example profile using SSO
    # [profile dev]
    # sso_session = my-sso
    # sso_account_id = 123456789012
    # sso_role_name = DeveloperAccess
    # region = us-east-1
    # output = json

    # Example profile using SSO for production (read-only)
    # [profile prod-readonly]
    # sso_session = my-sso
    # sso_account_id = 987654321098
    # sso_role_name = ReadOnlyAccess
    # region = us-east-1
    # output = json
  '';
  
  # AWS CLI aliases (optional)
  programs.fish.shellAbbrs = {
    # Common AWS commands
    awsl = "aws sso login";
    awsw = "aws sts get-caller-identity";  # Who am I?
    
    # S3 shortcuts
    s3ls = "aws s3 ls";
    s3cp = "aws s3 cp";
    s3sync = "aws s3 sync";
    
    # EC2 shortcuts
    ec2ls = "aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,State.Name,Tags[?Key==`Name`].Value|[0]]' --output table";
    
    # CloudFormation
    cfn-stacks = "aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE UPDATE_COMPLETE --query 'StackSummaries[*].[StackName,StackStatus,LastUpdatedTime]' --output table";
  };
  
  # Environment variables for AWS
  home.sessionVariables = {
    # Disable AWS CLI pager for scripts
    AWS_PAGER = "";
    
    # Optional: Set default profile
    # AWS_PROFILE = "work";
  };
  
  # Ensure the AWS directory exists with correct permissions
  home.activation.ensureAwsDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Create directory if it doesn't exist
    if [ ! -d "$HOME/.aws" ]; then
      mkdir -p "$HOME/.aws"
      chmod 700 "$HOME/.aws"
    fi
    
    # Note: We don't try to chmod existing files as they might be protected
    # The home.file declaration above will handle the config file creation
  '';
}
