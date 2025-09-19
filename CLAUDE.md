# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a unified Nix flake configuration that manages both macOS (nix-darwin) and NixOS systems with Home Manager for user-level configuration. The repository consolidates system-level and user-level configuration across platforms.

## Architecture

- **Platform-based configuration**: Systems are configured by platform (aarch64-darwin, x86_64-darwin, x86_64-linux, aarch64-linux) rather than hostname
- **Modular structure**: Shared modules for cross-platform consistency, platform-specific modules for OS differences
- **Flake-based**: All dependencies and inputs are managed through `flake.nix` with locked versions in `flake.lock`

### Key Directories

- `flake.nix`: Main flake configuration defining inputs, outputs, and system configurations
- `hosts/`: Platform-specific host configurations
  - `darwin/`: macOS system configuration via nix-darwin
  - `nixos/`: NixOS system configuration
- `modules/`: Modular configuration components
  - `shared/`: Cross-platform Home Manager modules, packages, and dotfiles
  - `darwin/`: macOS-specific modules (Homebrew casks, Dock configuration)
  - `nixos/`: Linux-specific modules (disk layout, desktop environment, services)
- `apps/`: Platform-specific executable scripts for common operations
- `overlays/`: Custom Nix packages and overrides

## Common Commands

### Development Environment

```bash
nix develop                           # Enter development shell
```

### Building and Switching

```bash
# macOS
nix run .#build                       # Build configuration only
nix run .#build-switch                # Build and switch to new configuration
nix run .#rollback                    # Rollback to previous generation

# NixOS
sudo nixos-rebuild build --flake .#x86_64-linux     # Build only
sudo nixos-rebuild switch --flake .#x86_64-linux    # Build and switch
```

### Configuration Management

```bash
nix run .#apply                       # Apply template personalization (replace %USER%, %EMAIL%, etc.)
nix flake update                      # Update all flake inputs
```

### Code Quality

```bash
# Formatting
nix run nixpkgs#nixpkgs-fmt -- .      # Format Nix code

# Linting
nix run nixpkgs#statix -- check .     # Static analysis for Nix
nix run nixpkgs#deadnix -- .          # Detect unused Nix code

# Security
nix run nixpkgs#gitleaks -- detect    # Check for secrets
```

### Git Hooks

```bash
nix run nixpkgs#lefthook -- install   # Install pre-commit hooks
```

## Configuration Guidelines

### Code Style

- Use 2-space indentation
- Follow nixpkgs-fmt formatting
- Use camelCase for variables and kebab-case for file names
- Organize imports at the top of files
- Use `let ... in` for local variables
- Use `inherit` to bring variables into scope

### Module Organization

- Place shared configuration in `modules/shared/`
- Platform-specific overrides go in `modules/darwin/` or `modules/nixos/`
- Group related functionality into separate module files
- Use descriptive file names that reflect their purpose

### Package Management

- Add packages to appropriate package lists:
  - `modules/shared/packages.nix`: Cross-platform CLI tools and development packages
  - `modules/darwin/casks.nix`: macOS GUI applications via Homebrew
  - `modules/darwin/brews.nix`: macOS CLI tools via Homebrew (when not available in nixpkgs)

### Security Notes

- SSH keys are managed in host configurations
- Secrets scanning is enabled via gitleaks pre-commit hook
- Template variables (%USER%, %EMAIL%, etc.) are replaced by the apply script

## Agent Behavior Guidelines

### Nix Configuration Management

- You are an expert in Nix, nix-darwin, and Home Manager
- Always follow best practices when writing and managing Nix files
- Always clearly explain proposed changes before implementing them
- Search documentation, GitHub issues, and web resources for relevant information
- After making changes, only run `nix run .#build` to verify configuration
- The user is responsible for running `nix run .#build-switch` to apply changes

### Git Commit Guidelines

- Follow the seven rules of great Git commit messages:
  1. Separate subject from body with a blank line
  2. Limit subject line to 50 characters
  3. Capitalize the subject line
  4. Do not end subject line with a period
  5. Use imperative mood in subject line
  6. Wrap body at 72 characters
  7. Use body to explain what and why vs. how
- For package commits, provide brief description of each tool's purpose
- No prefixes like `Doc:`, `Feat:`, or `Fix:` in subject line
- Review staged changes before writing commit message
- Present commit message to user for confirmation before executing
- Do not add `Co-Authored-By: Crush <crush@charm.land>` to commit messages

## Important Notes

- Always run `nix run .#build` to verify configuration before switching
- The user is responsible for running build-switch to apply changes
- Platform configurations don't use hostname-based keys by design for simplicity
- Home Manager manages user dotfiles and programs across both platforms
- Homebrew integration is handled via nix-homebrew for macOS

