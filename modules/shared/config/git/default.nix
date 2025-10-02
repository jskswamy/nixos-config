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
    diff.jupyternotebook = {
      command = "git-nbdiffdriver diff --ignore-metadata --ignore-details";
    };
    merge.jupyternotebook = {
      driver = "git-nbmergedriver merge %O %A %B %L %P";
      name = "jupyter notebook merge driver";
    };
    difftool.nbdime = {
      cmd = "git-nbdifftool diff $LOCAL $REMOTE $BASE";
    };
    difftool.prompt = false;
    mergetool.nbdime = {
      cmd = "git-nbmergetool merge $BASE $LOCAL $REMOTE $MERGED";
    };
  };
}
