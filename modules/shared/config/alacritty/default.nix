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
      # Limit scrollback buffer to improve performance
      history = 10000; # Default is 10000, can reduce to 5000 for better performance
      # Number of lines to scroll for each scroll wheel click
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
