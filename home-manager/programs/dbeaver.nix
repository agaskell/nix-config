{ config, pkgs, ... }:

{
  # DBeaver - Universal Database Tool (Community Edition)
  home.packages = with pkgs; [
    dbeaver-bin  # Community edition - free version
  ];
  
  # Optional: Create a desktop entry for better integration
  home.file.".local/share/applications/dbeaver.desktop" = {
    text = ''
      [Desktop Entry]
      Version=1.0
      Type=Application
      Name=DBeaver Community
      Comment=Universal Database Tool
      Icon=dbeaver
      Exec=${pkgs.dbeaver-bin}/bin/dbeaver
      Categories=Development;Database;
      Terminal=false
      StartupNotify=true
    '';
  };
  
  # Optional: Add DBeaver workspace to AeroSpace
  # You can switch to it with Alt+D (already configured for "Documentation" but can repurpose)
  home.sessionVariables = {
    # Set default workspace for DBeaver if needed
    # DBEAVER_WORKSPACE = "$HOME/.dbeaver-workspace";
  };
  
  # Fish shell abbreviation for quick launch
  programs.fish.shellAbbrs = {
    db = "dbeaver";
  };
}