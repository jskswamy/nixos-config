{
  config,
  pkgs,
  lib,
  user,
}: {
  enable = true;
  plugins = [
    {
      name = "gruvbox";
      inherit (pkgs.fishPlugins.gruvbox) src;
    }
  ];

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
    hackspace = "tmuxp load -a -y ~/.config/tmuxp/hackspace.yml";
  };

  functions = {
    gcloud_tmux = {
      body = ''
        # Get available gcloud configurations
        set configs (gcloud config configurations list --format="value(name)" | tail -n +2)

        if test (count $configs) -eq 0
          echo "No gcloud configurations found"
          return 1
        end

        # Use fzf to select configuration
        set selected_config (printf '%s\n' $configs | fzf --height=40% --layout=reverse --prompt="Select gcloud config: ")

        if test -z "$selected_config"
          echo "No configuration selected"
          return 1
        end

        # Launch tmuxp with selected configuration
        echo "Launching tmuxp with gcloud config: $selected_config"
        env GCLOUD_CONFIG=$selected_config tmuxp load gcloud-env
      '';
    };
  };

  interactiveShellInit = ''
    # Bind Ctrl+G to launch gcloud tmux selector
    bind \cg gcloud_tmux

    # Locale and general environment
    set -gx LC_CTYPE en_US.UTF-8
    set -gx LANG en_US.UTF-8
    set -gx LC_ALL en_US.UTF-8
    set -gx EDITOR "nvim"
    set -gx VISUAL "nvim"
    set -gx GPG_TTY (tty)

    # Tooling environment variables
    set -gx GOPATH "$HOME/go"
    set -gx GO111MODULE on
    set -gx FZF_TMUX 1
    set -gx FZF_TMUX_HEIGHT 80
    set -gx FZF_ALT_C_COMMAND "fd -t d . $HOME"
    set -l find_source_code_command "fd . $HOME/source/ --exclude vendor --exclude node_modules"
    set -gx FZF_CTRL_T_COMMAND $find_source_code_command
    set -gx FZF_CTRL_T_OPTS "--preview 'bat --color always {} 2>/dev/null or cat -n {} || eza --color always -l --git --git-ignore {} 2>/dev/null || tree -C {} 2>/dev/null | head -200' --select-1 --exit-0"
    set -gx FZF_CTRL_R_OPTS "--sort --exact --preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
    set -gx NIX_IGNORE_SYMLINK_STORE 1
    set -gx MANPAGER "bat -l man -p"
    set -gx DOCKER_HOST "unix:///Users/${user}/.colima/default/docker.sock"
    set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    set -gx GNUPGHOME "$HOME/.gnupg"
    set -gx BAT_THEME "gruvbox-dark"
    set -gx GOPRIVATE source.golabs.io
    set -gx fzf_fd_opts --hidden --exclude=.git --exclude=node_modules
    set -gx UV_MANAGED_PYTHON true
    set -gx FABRIC_COMMIT_PATTERN git_commit_message

    # PATH additions (use fish_add_path to avoid duplicates)
    fish_add_path -g $GOPATH/bin
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
    fish_add_path -g "/Users/${user}/.codeium/windsurf/bin"

    # Editor (kept as vim per your preference)
    set -gx ALTERNATE_EDITOR ""

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
      # zoxide
      zoxide init fish | source

      # Ghostty cursor behavior
      if string match -q -- '*ghostty*' $TERM
        set -g fish_vi_force_cursor 1
      end
    end

    # Source additional fish functions from our config
    for func_file in ~/.config/fish/functions/*.fish
      source $func_file
    end
  '';
}
