{
  programs.neovim = {
    defaultEditor = true;
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraConfig = ''
      " Sets tabs to spaces
      set expandtab
      set shiftwidth=2
      set tabstop=2
      set softtabstop=2

      " Other settings
      set number
      set relativenumber
      set clipboard=unnamedplus
    '';
  };
}
