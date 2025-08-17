{ pkgs, config, ... }:
let
   ohMyTmux = pkgs.fetchFromGitHub {
      owner = "gpakosz";
      repo = "oh-my-tmux";
      rev = "master";
      sha256 = "sha256-ynbmBELDhuFxXWExcOuy73uumsZanB8rAvK3/lalHQ0=";
    };
in
{
  ".tmux.conf" = {
    source = "${ohMyTmux}/.tmux.conf";
  };

  ".tmux.conf.local" = {
    source = ./config/tmux/conf.local;
  };

  ".config/starship.toml" = {
    source = ./config/starship/starship.toml;
  };

  ".config/pet/config.toml" = {
    source = ./config/pet/config.toml;
  };

  ".config/pet/snippet.toml" = {
    source = ./config/pet/snippet.toml;
  };
}
