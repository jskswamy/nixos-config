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
      history = 500; # Extremely aggressive for performance (was 1000)
      multiplier = 1; # Reduce scroll sensitivity for smoother experience
    };

    window = {
      opacity = 1.0;
      padding = {
        x = 24;
        y = 24;
      };
      dynamic_padding = false; # Static padding for better performance
      decorations = "None"; # Remove decorations for fastest rendering
      blur = false; # Disable blur for performance
      # Make Option key send Alt sequences on macOS
      option_as_alt = "Both";
      resize_increments = true; # Resize by character grid for performance
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

    # Performance and debug optimizations
    debug = {
      # GPU acceleration (replaces old renderer.backend)
      renderer = "glsl3"; # Force modern OpenGL for best performance

      # Performance optimizations
      render_timer = false; # Disable debug render timer
      print_events = false; # Disable event logging
      log_level = "off"; # Disable all logging for performance (lowercase)
    };

    # Environment optimizations
    env = {
      TERM = "alacritty";
      ALACRITTY_LOG = "/dev/null"; # Suppress all logging
    };
  };
}
