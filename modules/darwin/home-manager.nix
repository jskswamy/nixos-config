{ config, pkgs, lib, home-manager, ... }:

let
  user = "subramk";
  # Define the content of your file as a derivation
  sharedFiles = import ../shared/files.nix { inherit config pkgs; };
  additionalFiles = import ./files.nix { inherit user config pkgs; };
in
{
  imports = [
    ./dock
  ];

  # It me
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.fish;
  };

  homebrew = {
    enable = true;
    casks = pkgs.callPackage ./casks.nix { };
    brews = pkgs.callPackage ./brews.nix { };
    onActivation = {
      cleanup = "uninstall";
      upgrade = true;
      autoUpdate = true;
    };

    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    #
    # If you have previously added these apps to your Mac App Store profile (but not installed them on this system),
    # you may receive an error message "Redownload Unavailable with This Apple ID".
    # This message is safe to ignore. (https://github.com/dustinlyons/nixos-config/issues/83)
    masApps = {
      # Security & Privacy
      "bitwarden" = 1352778147;
      "wipr2" = 1662217862;
      "yubico authenticator" = 1497506650;

      # Productivity & Utilities
      "jomo" = 1609960918;
      "raycast" = 6738274497;
      "session" = 1521432881;
      "things3" = 904280696;

      # Communication
      "whatsapp" = 310633997;

      # AI & LLM
      "enchanted llm" = 6474268307;
      "perplexity" = 6714467650;
      "whisper transcription" = 1668083311;

      # Reading & Writing
      "kindle" = 302584613;
      "languagetool" = 1534275760;

      # Home & Automation
      "homeassistant" = 1099568401;

      # Health & Wellness
      "endel focus relax sleep" = 1346247457;

      # Network & VPN
      # "wireguard" = 1451685025;

      # Development & Tools
      "goodnotes 6" = 1444383602;
      "slack" = 803453959;
      "testflight" = 899247664;
      "xcode" = 497799835;
    };
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    users.${user} = { pkgs, config, lib, ... }: {
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix { };
        file = lib.mkMerge [
          sharedFiles
          additionalFiles
        ];
        stateVersion = "23.11";
      };
      programs = { } // import ../shared/home-manager.nix { inherit config pkgs lib; };

      services.gpg-agent = {
        enable = true;
        enableSshSupport = true;
        enableFishIntegration = true;
        defaultCacheTtl = 86400;
        maxCacheTtl = 86400;
        pinentry.package = pkgs.pinentry_mac;
        extraConfig = ''
          ttyname $GPG_TTY
          extra-socket ~/.gnupg/S.gpg-agent.extra
        '';
      };

      # Configure auto-start applications via launchd
      launchd.agents = {
        raycast = {
          enable = true;
          config = {
            ProgramArguments = [ "/Applications/Raycast.app/Contents/MacOS/Raycast" ];
            RunAtLoad = true;
            KeepAlive = false;
          };
        };
        things3 = {
          enable = true;
          config = {
            ProgramArguments = [ "/Applications/Things3.app/Contents/MacOS/Things3" ];
            RunAtLoad = true;
            KeepAlive = false;
          };
        };
        timing = {
          enable = true;
          config = {
            ProgramArguments = [ "/Applications/Timing.app/Contents/MacOS/Timing" ];
            RunAtLoad = true;
            KeepAlive = false;
          };
        };
        jomo = {
          enable = true;
          config = {
            ProgramArguments = [ "/Applications/Jomo.app/Contents/MacOS/Jomo" ];
            RunAtLoad = true;
            KeepAlive = false;
          };
        };
        keybase = {
          enable = true;
          config = {
            ProgramArguments = [ "/Applications/Keybase.app/Contents/SharedSupport/bin/keybase" "launchd" "forservice" ];
            RunAtLoad = true;
            KeepAlive = true;  # Keybase service should stay running
          };
        };
        google-drive = {
          enable = true;
          config = {
            ProgramArguments = [ "/Applications/Google Drive.app/Contents/MacOS/Google Drive" ];
            RunAtLoad = true;
            KeepAlive = false;
          };
        };
      };

      # Marked broken Oct 20, 2022 check later to remove this
      # https://github.com/nix-community/home-manager/issues/3344
      manual.manpages.enable = false;
    };
  };

  # Fully declarative dock using the latest from Nix Store
  local.dock = {
    enable = true;
    username = user;
    entries = [
      { path = "/Applications/Safari.app/"; }
      { path = "/Applications/Arc.app/"; }
      { path = "/System/Applications/Mail.app";}
      { path = "${pkgs.alacritty}/Applications/Alacritty.app/"; }
      { path = "/Applications/Capacities.app/"; }
      { path = "/Applications/Things3.app/"; }
      { path = "/System/Applications/Messages.app/"; }
      { path = "/System/Applications/Notes.app/"; }
      { path = "/System/Applications/Music.app/"; }
      { path = "/System/Applications/System Settings.app/"; }
      {
        path = "${config.users.users.${user}.home}/Downloads";
        section = "others";
        options = "--sort datecreated --view fan --display stack";
      }
    ];
  };

}
