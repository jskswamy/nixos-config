# Shell scripts managed through nix configuration
{
  # Git utilities
  ".local/bin/git-ai-commit" = {
    source = ./scripts/git-ai-commit;
    executable = true;
  };

  # Nix utilities
  ".local/bin/nix-build" = {
    source = ./scripts/nix-build;
    executable = true;
  };

  ".local/bin/nix-clean" = {
    source = ./scripts/nix-clean;
    executable = true;
  };

  ".local/bin/nix-install" = {
    source = ./scripts/nix-install;
    executable = true;
  };

  ".local/bin/nix-update" = {
    source = ./scripts/nix-update;
    executable = true;
  };

  ".local/bin/nix-edit" = {
    source = ./scripts/nix-edit;
    executable = true;
  };

  # System utilities
  ".local/bin/search" = {
    source = ./scripts/search;
    executable = true;
  };

  ".local/bin/cleanup-auth" = {
    source = ./scripts/cleanup-auth;
    executable = true;
  };

  ".local/bin/fit" = {
    source = ./scripts/fit;
    executable = true;
  };
}