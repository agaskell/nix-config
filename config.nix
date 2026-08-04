# Per-machine configuration.
#
# This file IS committed to the repo — pure flake evaluation requires it to
# be tracked. On a new machine, edit these values and run:
#
#     git update-index --skip-worktree config.nix
#
# to keep local edits out of commits. See README.md "Per-Machine
# Configuration" for the full workflow.
{
  # macOS username (whoami)
  username = "andy";

  # Hostname used as the darwinConfigurations attribute name.
  # Using LocalHostName (`scutil --get LocalHostName`) rather than
  # ComputerName because the latter contains a curly apostrophe that
  # Nix can't use as an attribute key.
  hostname = "Andys-MacBook-Pro";

  # Git identity (consumed by home-manager/programs/git.nix)
  git = {
    name = "Andy Gaskell";
    email = "andy@zubago.com";
  };

  # Personal-only apps (Signal, Discord, etc.).
  personal = true;

  # UID of the macOS user account (`id -u`). Per-machine: macOS assigns
  # 501 to the first account created, 502 to the second, and so on.
  # Optional — defaults to 501 if omitted. Home Manager activation aborts
  # if this doesn't match the real UID.
  uid = 501;
}
