{
  pkgs,
  config,
  ...
}: let
  ohMyTmux = pkgs.fetchFromGitHub {
    owner = "gpakosz";
    repo = ".tmux";
    rev = "master";
    sha256 = "sha256-ynbmBELDhuFxXWExcOuy73uumsZanB8rAvK3/lalHQ0=";
  };
  alacrittyTheme = pkgs.fetchFromGitHub {
    owner = "alacritty";
    repo = "alacritty-theme";
    rev = "master";
    sha256 = "sha256-R7OdOSGhT0ag0HOfGaCklxo2py1qhSFhapkgTNwzRC4=";
  };
in {
  ".tmux.conf" = {
    source = "${ohMyTmux}/.tmux.conf";
  };

  ".tmux.conf.local" = {
    source = ./config/tmux/conf.local;
  };

  ".config/pet/config.toml" = {
    source = ./config/pet/config.toml;
  };

  ".config/pet/snippet.toml" = {
    source = ./config/pet/snippet.toml;
  };

  ".config/ghostty/config" = {
    source = ./config/ghostty/config;
  };

  ".config/alacritty/themes" = {
    source = "${alacrittyTheme}/themes";
    recursive = true;
  };

  ".config/nvim" = {
    source = ./config/nvim;
    recursive = true;
  };

  ".config/tmuxp" = {
    source = ./config/tmuxp;
    recursive = true;
  };

  ".config/fish/functions" = {
    source = ./config/fish/functions;
    recursive = true;
  };

  ".config/tig/config" = {
    source = ./config/tig/config;
  };

  # Install wallpapers to user directory
  ".local/share/wallpapers/red-planet-with-rings.jpg" = {
    source = ./wallpapers/red-planet-with-rings.jpg;
  };

  ".local/share/wallpapers/islands-at-sunset.jpg" = {
    source = ./wallpapers/islands-at-sunset.jpg;
  };

  ".config/nbdime/config.json" = {
    source = ./config/nbdime/config.json;
  };
}
