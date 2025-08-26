## Build, Lint, and Test Commands

- **Enter Dev Shell**: `nix develop`
- **Run Apps**: `nix run .#<app-name>` (e.g., `nix run .#apply`)
- **Build Config**: `nix run .#build`
- **Build and Switch Config**: `nix run .#build-switch`
- **Format Code**: `nix run nixpkgs#nixpkgs-fmt -- .` (or uncomment `nixfmt` in `lefthook.yml`)
- **Lint Code**: `nix run nixpkgs#statix -- check .` and `nix run nixpkgs#deadnix -- .` (or uncomment `statix` and `deadnix` in `lefthook.yml`)
- **Check for Secrets**: `nix run nixpkgs#gitleaks -- detect`
- **Update Flakes**: `nix flake update`

## Code Style Guidelines

- **Formatting**: Use `nixpkgs-fmt` for consistent formatting. Indent with 2 spaces.
- **Naming**: Use camelCase for variables and function arguments (`pkgs`, `system`). Use kebab-case for file names.
- **Variables**: Use `let ... in` for local variable definitions.
- **Imports**: Use `inherit` to bring variables into scope from `let` blocks or function arguments.
- **Types**: Use Nix's dynamic types. Add comments to clarify complex types if necessary.
- **Error Handling**: Use `builtins.tryEval` for expressions that might fail. Use `throw` for unrecoverable errors.
- **Structure**: Group related configurations in separate modules. Use `imports` to compose modules.
- **Comments**: Use `#` for single-line comments. Add comments to explain complex logic.

## Agent Instructions

- You are an agent who is an expert in managing applications and configurations using Nix, Nix-Darwin, and Home Manager.
- You always follow best practices when writing and managing Nix files.
- You always clearly explain the changes you are proposing before performing them.
- You always search the documentation, GitHub docs/issues/gists, and the web for relevant information.
- You must strictly follow all instructions provided in this document.

## Git Commit Message Guidelines

- **Style**: Follow the seven rules of a great Git commit message:
  1. Separate subject from body with a blank line.
  2. Limit the subject line to 50 characters.
  3. Capitalize the subject line.
  4. Do not end the subject line with a period.
  5. Use the imperative mood in the subject line.
  6. Wrap the body at 72 characters.
  7. Use the body to explain what and why vs. how.
- **Package Commits**: If adding packages, provide a brief description of each tool's purpose.
- **Output**: Generate only the final commit message, sticking strictly to the facts from the diff.
- **No Prefixes**: Do not use prefixes like `Doc:`, `Feat:`, or `Fix:` in the subject line.
- **Review Staged Changes**: Always review the staged changes to understand the overall modifications before writing the commit message.
- **Confirmation**: After generating the commit message, present it to the user for confirmation before executing the commit.
- **No Co-Author**: Do not add `Co-Authored-By: Crush <crush@charm.land>` to the commit message.
