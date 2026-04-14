{ config, pkgs, ... }:

{
  programs.vim = {
    enable = true;

    # Only use settings that are actually supported
    settings = {
      expandtab = true;
      tabstop = 4;
      shiftwidth = 4;
      number = true;
      ignorecase = true;
      smartcase = true;
    };

    # Put everything else in extraConfig
    extraConfig = ''
      " Tab/indentation settings
      set softtabstop=4
      set autoindent
      set smartindent

      " Visual settings
      set relativenumber
      set cursorline
      set nowrap

      " Search settings
      set hlsearch
      set incsearch

      " Enable syntax highlighting
      syntax on

      " Better colors for dark terminal
      set background=dark

      " Show matching brackets
      set showmatch

      " Better backspace behavior
      set backspace=indent,eol,start

      " Show command in status line
      set showcmd

      " Enable mouse support
      set mouse=a

      " Don't create backup files
      set nobackup
      set noswapfile

      " Better split behavior
      set splitbelow
      set splitright
    '';
  };
}
