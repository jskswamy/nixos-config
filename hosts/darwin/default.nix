{ config, pkgs, ... }:

let user = "subramk"; in

{
  imports = [
    ../../modules/darwin/home-manager.nix
    ../../modules/shared
  ];

  nix = {
    package = pkgs.nix;

    settings = {
      trusted-users = [ "@admin" "${user}" ];
      substituters = [ "https://nix-community.cachix.org" "https://cache.nixos.org" ];
      trusted-public-keys = [ 
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" 
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    gc = {
      automatic = true;
      interval = { Weekday = 0; Hour = 2; Minute = 0; };
      options = "--delete-older-than 30d";
    };

    optimise = {
      automatic = true;
    };

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Enable fish system-wide and register it in /etc/shells
  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];

  # Enable GnuPG agent with SSH support
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  environment.systemPackages = with pkgs; [
  ] ++ (import ../../modules/shared/packages.nix { inherit pkgs; });

  # Install fonts system-wide on macOS (for Alacritty and others)
  fonts = {
    packages = with pkgs; [
      meslo-lgs-nf
      jetbrains-mono
      noto-fonts
      noto-fonts-emoji
      dejavu_fonts
      font-awesome
    ];
  };

  # Set desktop wallpaper using system activation script
  system.activationScripts.setWallpaper.text = ''
    # Set desktop wallpaper for current user
    /usr/bin/osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"/Users/${user}/.local/share/wallpapers/red-planet-with-rings.jpg\""
  '';

  system = {
    checks.verifyNixPath = false;
    primaryUser = user;
    stateVersion = 5;

    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;

        KeyRepeat = 2; # Values: 120, 90, 60, 30, 12, 6, 2
        InitialKeyRepeat = 15; # Values: 120, 94, 68, 35, 25, 15

        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.trackpad.scaling" = 1.0;
        "com.apple.trackpad.forceClick" = true;
        AppleEnableMouseSwipeNavigateWithScrolls = true;
        AppleEnableSwipeNavigateWithScrolls = true;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
        _HIHideMenuBar = true;
      };

      dock = {
        autohide = true;
        show-recents = false;
        launchanim = true;
        orientation = "bottom";
        tilesize = 48;
      };

      finder = {
        _FXShowPosixPathInTitle = false;
      };

      trackpad = {
        Clicking = true;
        Dragging = true;
        TrackpadRightClick = true;
        ActuationStrength = 0;
        FirstClickThreshold = 1;
        SecondClickThreshold = 1;
        TrackpadThreeFingerTapGesture = 2;
      };

    };

    defaults.CustomUserPreferences = {
      "com.apple.AppleMultitouchTrackpad" = {
        TrackpadThreeFingerVertSwipeGesture = 2;
        TrackpadTwoFingerFromRightEdgeSwipeGesture = 3;
        TrackpadThreeFingerHorizSwipeGesture = 2;
        TrackpadFourFingerVertSwipeGesture = 2;
      };
      "com.apple.driver.AppleBluetoothMultitouch.trackpad" = {
        TrackpadThreeFingerVertSwipeGesture = 2;
        TrackpadTwoFingerFromRightEdgeSwipeGesture = 3;
        TrackpadThreeFingerHorizSwipeGesture = 2;
        TrackpadFourFingerVertSwipeGesture = 2;
      };
      "pbs" = {
        NSServicesStatus = {
          "com.apple.Terminal - Search man Page Index in Terminal - searchManPages" = {
            enabled_context_menu = false;
            enabled_services_menu = false;
            presentation_modes = {
              ContextMenu = false;
              ServicesMenu = false;
            };
          };
        };
      };
    };
  };
}
