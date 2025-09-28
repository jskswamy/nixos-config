{
  config,
  pkgs,
  lib,
  user,
}: {
  enable = true;
  settings = {
    cursor = {
      style = "Block";
    };

    scrolling = {
      history = 1000; # Very low since tmux handles session persistence
      multiplier = 3;
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
}
