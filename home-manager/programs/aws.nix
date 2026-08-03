{ config, pkgs, lib, ... }:

{
  # AWS CLI v2
  home.packages = with pkgs; [
    awscli2

    # Optional: Additional AWS tools
    aws-vault      # Secure credential storage
    aws-sso-cli    # Better SSO experience
    ssm-session-manager-plugin  # For SSM sessions
  ];
  
  # ~/.aws/config is intentionally NOT managed by Home Manager.
  # The AWS CLI mutates it directly (SSO sessions, cli_history, `aws configure`),
  # which fails against a read-only Nix store symlink. Manage it manually.

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
