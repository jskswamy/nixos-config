{
  config,
  pkgs,
  lib,
  user,
}: {
  enable = true;
  enableDefaultConfig = false;
  includes = [
    (
      lib.mkIf pkgs.stdenv.hostPlatform.isLinux
      "/home/${user}/.ssh/config_external"
    )
    (
      lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
      "/Users/${user}/.ssh/config_external"
    )
  ];
  matchBlocks = {
    # Global fallback for terminal compatibility (including Ghostty)
    "*" = {
      setEnv = {
        TERM = "xterm-256color"; # Universal fallback TERM value
      };
    };

    # Example SSH configuration for GitHub
    # "github.com" = {
    #   identitiesOnly = true;
    #   identityFile = [
    #     (lib.mkIf pkgs.stdenv.hostPlatform.isLinux
    #       "/home/${user}/.ssh/id_github"
    #     )
    #     (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
    #       "/Users/${user}/.ssh/id_github"
    #     )
    #   ];
    # };
  };
}
