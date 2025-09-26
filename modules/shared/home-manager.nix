{
  config,
  pkgs,
  lib,
  ...
}: let
  name = "Krishnaswamy Subramanian";
  user = "subramk";
  email = "jskswamy@gmail.com";
in {
  # Shared shell configuration
  zsh = import ./config/zsh {inherit config pkgs lib user;};

  # Fish shell configuration (modularized)
  fish = import ./config/fish {
    inherit config pkgs lib user;
  };

  # Git configuration (modularized)
  git = import ./config/git {inherit config pkgs lib user;};

  vim = import ./config/vim {inherit config pkgs lib user;};

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
        # Make Option key send Alt sequences on macOS
        option_as_alt = "Both";
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
          "~/.config/alacritty/themes/gruvbox_dark.toml"
        ];
      };

      keyboard = {
        bindings = [
          # Additional key bindings can be added here if needed
        ];
      };
    };
  };

  gpg = {
    enable = true;
    settings = {
      # Privacy & UI
      no-greeting = true;
      no-comments = true;
      no-emit-version = true;
      armor = true;
      throw-keyids = true;

      # Strong cryptography preferences
      personal-cipher-preferences = "AES256 AES192 AES";
      personal-digest-preferences = "SHA512 SHA384 SHA256";
      personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
      default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";

      # Strong algorithms for key operations
      cert-digest-algo = "SHA512";
      s2k-digest-algo = "SHA512";
      s2k-cipher-algo = "AES256";

      # Security and validation
      require-cross-certification = true;
      with-fingerprint = true;
      keyid-format = "0xlong";
      list-options = "show-uid-validity";
      verify-options = "show-uid-validity";

      # Compatibility
      charset = "utf-8";
      use-agent = true;

      # Memory protection (comment out if it causes issues)
      require-secmem = true;
      no-symkey-cache = true;
    };
  };

  ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [
      (
        lib.mkIf pkgs.stdenv.hostPlatform.isLinux
        "/home/${user}/.ssh/config_external"
      )
      (
        lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
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
