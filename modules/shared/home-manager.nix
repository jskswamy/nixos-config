{ config, pkgs, lib, ... }:

let
  name = "Krishnaswamy Subramanian";
  user = "subramk";
  email = "jskswamy@gmail.com";
in
{
  # Shared shell configuration
  zsh = {
    enable = true;
    autocd = false;
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./config;
        file = "p10k.zsh";
      }
    ];

    initContent = lib.mkBefore ''
      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi

      # Define variables for directories
      export PATH=$HOME/.pnpm-packages/bin:$HOME/.pnpm-packages:$PATH
      export PATH=$HOME/.npm-packages/bin:$HOME/bin:$PATH
      export PATH=$HOME/.local/share/bin:$PATH

      # Remove history data we don't want to see
      export HISTIGNORE="pwd:ls:cd"

      # Vim is my editor
      export ALTERNATE_EDITOR=""
      export EDITOR="vim"
      export VISUAL="vim"

      # nix shortcuts
      shell() {
          nix-shell '<nixpkgs>' -A "$1"
      }

      # Use difftastic, syntax-aware diffing
      alias diff=difft

      # Always color ls and group directories
      alias ls='ls --color=auto'
    '';
  };

  # Add fish configuration
  fish = {
    enable = true;
    shellAliases = {
      diff = "difft";
      ls = "eza --icons=always";
      cat = "bat";
      weather = "curl \"wttr.in/chennai\"";
      ips = "ifconfig | rg \"inet \" | rg -v 127.0.0.1 | cut -d\\  -f2 | sort";
      picocom = "ls -l /dev | rg --regexp 'tty.\\w*UART' | awk '{print \"/dev/\"$9}'";
      vim = "nvim";
      vi = "nvim";
      glow = "glow -p -w (tput cols)";
      cdr = "cd (git rev-parse --show-toplevel)";
      chrome = "/Applications/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome";
    };
    interactiveShellInit = ''
      # Locale and general environment
      set -gx LC_CTYPE en_US.UTF-8
      set -gx LANG en_US.UTF-8
      set -gx LC_ALL en_US.UTF-8

      # Tooling environment
      set -gx GOPATH "$HOME/go"
      set -gx FZF_TMUX 1
      set -gx FZF_TMUX_HEIGHT 80
      set -gx FZF_ALT_C_COMMAND "fd -t d . $HOME"
      set -l find_source_code_command "fd . $HOME/source/ --exclude vendor --exclude node_modules"
      set -gx FZF_CTRL_T_COMMAND $find_source_code_command
      set -gx FZF_CTRL_T_OPTS "--preview 'bat --color always {} 2>/dev/null or cat -n {} || eza --color always -l --git --git-ignore {} 2>/dev/null || tree -C {} 2>/dev/null | head -200' --select-1 --exit-0"
      set -gx FZF_CTRL_R_OPTS "--sort --exact --preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
      set -gx NIX_IGNORE_SYMLINK_STORE 1
      set -gx SHELL fish
      set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
      set -gx ZELLIJ_AUTO_ATTACH true
      set -gx ZELLIJ_AUTO_EXIT true
      set -gx DOCKER_HOST unix:///Users/${user}/.colima/default/docker.sock
      set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
      set -gx GNUPGHOME "$HOME/.gnupg"
      set -gx BAT_THEME "Solarized (light)"
      set -gx GOPRIVATE source.golabs.io
      set -gx GPG_TTY (tty)
      set -gx fzf_fd_opts --hidden --exclude=.git --exclude=node_modules
      set -gx UV_MANAGED_PYTHON true

      # PATH additions (use fish_add_path to avoid duplicates)
      fish_add_path -g $GOPATH/bin
      # fish_add_path -g "$HOME/Library/Python/3.9/bin"
      fish_add_path -g "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
      fish_add_path -g "$HOME/.cargo/bin"
      fish_add_path -g "$HOME/dot-files/bin"
      fish_add_path -g "$HOME/.Spacevim/bin"
      fish_add_path -g "$HOME/.bin"
      fish_add_path -g "$HOME/.local/bin"
      fish_add_path -g "$HOME/Library/Flutter/bin"
      fish_add_path -g "$PWD/node_modules/.bin"
      fish_add_path -g /run/current-system/sw/bin
      fish_add_path -g /opt/homebrew/bin
      fish_add_path -g "/Applications/Keybase.app/Contents/SharedSupport/bin"
      fish_add_path -g /Users/${user}/.codeium/windsurf/bin

      # Editor (kept as vim per your preference)
      set -gx ALTERNATE_EDITOR ""
      set -gx EDITOR "vim"
      set -gx VISUAL "vim"

      # Interactive-only hooks and tweaks
      if status --is-interactive
        # jump
        source (jump shell fish | psub)
        # direnv
        direnv hook fish | source
        # any-nix-shell
        any-nix-shell fish | source
        # increase open file limit
        ulimit -S -n 16384
        # starship prompt
        source (/run/current-system/sw/bin/starship init fish --print-full-init | psub)
        # zoxide
        zoxide init fish | source

        # Ghostty cursor behavior
        if string match -q -- '*ghostty*' $TERM
          set -g fish_vi_force_cursor 1
        end
      end
    '';
  };

  git = {
    enable = true;
    ignores = [ "*.swp" ];
    userName = name;
    userEmail = email;
    lfs = {
      enable = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      core = {
        editor = "vim";
        autocrlf = "input";
      };
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };

  vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ vim-airline vim-airline-themes vim-startify vim-tmux-navigator ];
    settings = { ignorecase = true; };
    extraConfig = ''
      "" General
      set number
      set history=1000
      set nocompatible
      set modelines=0
      set encoding=utf-8
      set scrolloff=3
      set showmode
      set showcmd
      set hidden
      set wildmenu
      set wildmode=list:longest
      set cursorline
      set ttyfast
      set nowrap
      set ruler
      set backspace=indent,eol,start
      set laststatus=2
      set clipboard=autoselect

      " Dir stuff
      set nobackup
      set nowritebackup
      set noswapfile
      set backupdir=~/.config/vim/backups
      set directory=~/.config/vim/swap

      " Relative line numbers for easy movement
      set relativenumber
      set rnu

      "" Whitespace rules
      set tabstop=8
      set shiftwidth=2
      set softtabstop=2
      set expandtab

      "" Searching
      set incsearch
      set gdefault

      "" Statusbar
      set nocompatible " Disable vi-compatibility
      set laststatus=2 " Always show the statusline
      let g:airline_theme='bubblegum'
      let g:airline_powerline_fonts = 1

      "" Local keys and such
      let mapleader=","
      let maplocalleader=" "

      "" Change cursor on mode
      :autocmd InsertEnter * set cul
      :autocmd InsertLeave * set nocul

      "" File-type highlighting and configuration
      syntax on
      filetype on
      filetype plugin on
      filetype indent on

      "" Paste from clipboard
      nnoremap <Leader>, "+gP

      "" Copy from clipboard
      xnoremap <Leader>. "+y

      "" Move cursor by display lines when wrapping
      nnoremap j gj
      nnoremap k gk

      "" Map leader-q to quit out of window
      nnoremap <leader>q :q<cr>

      "" Move around split
      nnoremap <C-h> <C-w>h
      nnoremap <C-j> <C-w>j
      nnoremap <C-k> <C-w>k
      nnoremap <C-l> <C-w>l

      "" Easier to yank entire line
      nnoremap Y y$

      "" Move buffers
      nnoremap <tab> :bnext<cr>
      nnoremap <S-tab> :bprev<cr>

      "" Like a boss, sudo AFTER opening the file to write
      cmap w!! w !sudo tee % >/dev/null

      let g:startify_lists = [
        \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
        \ { 'type': 'sessions',  'header': ['   Sessions']       },
        \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      }
        \ ]

      let g:startify_bookmarks = [
        \ '~/Projects',
        \ '~/Documents',
        \ ]

      let g:airline_theme='bubblegum'
      let g:airline_powerline_fonts = 1
    '';
  };

  alacritty = {
    enable = true;
    settings = {
      cursor = {
        style = "Block";
      };

      window = {
        opacity = 1.0;
        padding = {
          x = 24;
          y = 24;
        };
        dynamic_padding = true;
        decorations = "Buttonless";
        blur = true;
      };

      font = {
        normal = {
          family = "MesloLGS NF";
          style = "Regular";
        };
        size = lib.mkMerge [
          (lib.mkIf pkgs.stdenv.hostPlatform.isLinux 10)
          (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin 14)
        ];
      };

      general = {
        live_config_reload = true;
        import = [
          "~/.config/alacritty/themes/aura.toml"
        ];
      };

    };
  };

  ssh = {
    enable = true;
    includes = [
      (lib.mkIf pkgs.stdenv.hostPlatform.isLinux
        "/home/${user}/.ssh/config_external"
      )
      (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
        "/Users/${user}/.ssh/config_external"
      )
    ];
    matchBlocks = {
      # Example SSH configuration for GitHub
      # "github.com" = {
      #   identitiesOnly = true;
      #   identityFile = [
      #     (lib.mkIf pkgs.stdenv.hostPlatform.isLinux
      #       "/home/${user}/.ssh/id_github"
      #     )
      #     (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
      #       "/Users/${user}/.ssh/id_github"
      #     )
      #   ];
      # };
    };
  };

  tmux = {
    enable = false;
  };

}
