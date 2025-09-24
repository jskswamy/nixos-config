{
  description = "Starter Configuration for MacOS and NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    darwin,
    nix-homebrew,
    homebrew-bundle,
    homebrew-core,
    homebrew-cask,
    home-manager,
    nixpkgs,
    disko,
    git-hooks,
  } @ inputs: let
    user = "subramk";
    linuxSystems = ["x86_64-linux" "aarch64-linux"];
    darwinSystems = ["aarch64-darwin" "x86_64-darwin"];
    forAllSystems = f: nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) f;
    devShell = system: let
      pkgs = nixpkgs.legacyPackages.${system};
      pre-commit-check = git-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          # Nix formatting only (statix/deadnix check entire repo)
          alejandra.enable = true;

          # Secrets detection (always runs on staged files)
          gitleaks = {
            enable = true;
            entry = "${pkgs.gitleaks}/bin/gitleaks protect --staged --redact --verbose";
            language = "system";
            pass_filenames = false;
            always_run = true;
          };

          # General file checks (using only well-supported hooks)
          check-added-large-files.enable = true;
          check-merge-conflicts.enable = true;
          end-of-file-fixer.enable = true;

          # Custom trailing whitespace hook
          trailing-whitespace = {
            enable = true;
            entry = "${pkgs.python3}/bin/python -c 'import sys,re; [sys.exit(1) for line in sys.stdin if re.search(r\"\\s+$\", line)]'";
            language = "system";
            types = ["text"];
          };

          # Shell linting
          shellcheck.enable = true;
          shfmt.enable = true;

          # Lua formatting (for Neovim config)
          stylua.enable = true;

          # YAML linting
          yamllint.enable = true;

          # Markdown linting
          markdownlint.enable = true;

          # JSON/YAML/Markdown formatting with prettier
          prettier = {
            enable = true;
            types_or = ["json" "yaml" "markdown"];
          };
        };
      };
    in {
      default = pkgs.mkShell {
        inherit (pre-commit-check) shellHook;
        nativeBuildInputs = with pkgs;
          [
            bashInteractive
            git
          ]
          ++ pre-commit-check.enabledPackages;
      };
    };

    # Separate checks configuration for git-hooks
    mkChecks = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      pre-commit-check = git-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          # Nix tools for comprehensive checking
          alejandra.enable = true;
          statix.enable = true;
          deadnix.enable = true;

          # Secrets detection (always runs on staged files)
          gitleaks = {
            enable = true;
            entry = "${pkgs.gitleaks}/bin/gitleaks protect --staged --redact --verbose";
            language = "system";
            pass_filenames = false;
            always_run = true;
          };

          # General file checks (conservative set to avoid sandbox issues)
          check-added-large-files.enable = true;
          check-merge-conflicts.enable = true;
          end-of-file-fixer.enable = true;

          # Custom trailing whitespace hook
          trailing-whitespace = {
            enable = true;
            entry = "${pkgs.python3}/bin/python -c 'import sys,re; [sys.exit(1) for line in sys.stdin if re.search(r\"\\s+$\", line)]'";
            language = "system";
            types = ["text"];
          };

          # Shell linting
          shellcheck.enable = true;
          shfmt.enable = true;

          # Lua formatting (for Neovim config)
          stylua.enable = true;

          # YAML linting
          yamllint.enable = true;

          # Markdown linting
          markdownlint.enable = true;

          # JSON/YAML/Markdown formatting with prettier
          prettier = {
            enable = true;
            types_or = ["json" "yaml" "markdown"];
          };
        };
      };
    });
    mkApp = scriptName: system: {
      type = "app";
      program = "${(nixpkgs.legacyPackages.${system}.writeScriptBin scriptName ''
        #!/usr/bin/env bash
        PATH=${nixpkgs.legacyPackages.${system}.git}/bin:$PATH
        echo "Running ${scriptName} for ${system}"
        exec ${self}/apps/${system}/${scriptName}
      '')}/bin/${scriptName}";
    };
    mkLinuxApps = system: {
      "apply" = mkApp "apply" system;
      "build-switch" = mkApp "build-switch" system;
      "copy-keys" = mkApp "copy-keys" system;
      "create-keys" = mkApp "create-keys" system;
      "check-keys" = mkApp "check-keys" system;
      "install" = mkApp "install" system;
    };
    mkDarwinApps = system: {
      "apply" = mkApp "apply" system;
      "build" = mkApp "build" system;
      "build-switch" = mkApp "build-switch" system;
      "copy-keys" = mkApp "copy-keys" system;
      "create-keys" = mkApp "create-keys" system;
      "check-keys" = mkApp "check-keys" system;
      "rollback" = mkApp "rollback" system;
    };
  in {
    devShells = forAllSystems devShell;
    checks = mkChecks;
    apps = nixpkgs.lib.genAttrs linuxSystems mkLinuxApps // nixpkgs.lib.genAttrs darwinSystems mkDarwinApps;

    darwinConfigurations = nixpkgs.lib.genAttrs darwinSystems (
      system: let
        user = "subramk";
      in
        darwin.lib.darwinSystem {
          inherit system;
          specialArgs = inputs;
          modules = [
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                inherit user;
                enable = true;
                taps = {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                  "homebrew/homebrew-bundle" = homebrew-bundle;
                };
                mutableTaps = false;
                autoMigrate = true;
              };
            }
            ./hosts/darwin
          ];
        }
    );

    nixosConfigurations = nixpkgs.lib.genAttrs linuxSystems (system:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = inputs;
        modules = [
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${user} = import ./modules/nixos/home-manager.nix;
            };
          }
          ./hosts/nixos
        ];
      });
  };
}
