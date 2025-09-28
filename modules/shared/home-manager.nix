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
  zsh = import ./config/zsh {inherit config pkgs lib user;};

  fish = import ./config/fish {
    inherit config pkgs lib user;
  };

  git = import ./config/git {inherit config pkgs lib user;};

  vim = import ./config/vim {inherit config pkgs lib user;};

  alacritty = import ./config/alacritty {inherit config pkgs lib user;};

  gpg = import ./config/gpg {inherit config pkgs lib user;};

  ssh = import ./config/ssh {inherit config pkgs lib user;};

  tmux = {
    enable = false;
  };
}
