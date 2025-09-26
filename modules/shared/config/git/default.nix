{
  config,
  pkgs,
  lib,
  user,
}: let
  name = "Krishnaswamy Subramanian";
  email = "jskswamy@gmail.com";
in {
  enable = true;
  ignores = ["*.swp"];
  userName = name;
  userEmail = email;
  lfs = {
    enable = true;
  };
  extraConfig = {
    init.defaultBranch = "main";
    core = {
      editor = "vim";
      autocrlf = "input";
    };
    pull.rebase = true;
    rebase.autoStash = true;
  };
}
