{
  config,
  pkgs,
  lib,
  ...
}: let
  # Path to encrypted workspace files
  secretsPath = ../../../../secrets/workspaces;

  # Script to decrypt workspace files using SOPS CLI
  decryptWorkspaces = pkgs.writeShellScript "decrypt-workspaces" ''
    set -e

    # Set up GPG environment for SOPS
    export GPG_TTY=$(tty 2>/dev/null || echo "/dev/console")
    export GNUPGHOME="${config.home.homeDirectory}/.gnupg"

    # Force SOPS to use GnuPG binary instead of go-crypto
    export SOPS_GPG_EXEC="${pkgs.gnupg}/bin/gpg"

    # Ensure gpg-agent is running
    ${pkgs.gnupg}/bin/gpg-connect-agent /bye >/dev/null 2>&1 || true

    # Test GPG access to the key
    echo "Testing GPG key access..."
    if ! ${pkgs.gnupg}/bin/gpg --list-secret-keys 17748589D970F86E >/dev/null 2>&1; then
      echo "❌ GPG key 17748589D970F86E not accessible"
      exit 1
    fi
    echo "✅ GPG key accessible"

    WORKSPACE_DIR="${config.home.homeDirectory}/.config/workspaces"
    SECRETS_DIR="${secretsPath}"

    # Create workspace directory
    mkdir -p "$WORKSPACE_DIR"

    # Check if any encrypted files exist
    if ! ls "$SECRETS_DIR"/*.yaml >/dev/null 2>&1; then
      echo "No encrypted workspace files found in $SECRETS_DIR"
      exit 0
    fi

    # Decrypt all workspace files
    for encrypted_file in "$SECRETS_DIR"/*.yaml; do
      if [[ -f "$encrypted_file" ]]; then
        filename=$(basename "$encrypted_file" .yaml)
        decrypted_file="$WORKSPACE_DIR/$filename.yml"

        echo "Decrypting workspace: $filename"
        if ${pkgs.sops}/bin/sops --config /dev/null --decrypt --output "$decrypted_file" "$encrypted_file"; then
          chmod 644 "$decrypted_file"
          echo "✅ Decrypted $filename.yml"
        else
          echo "❌ Failed to decrypt $filename"
          exit 1
        fi
      fi
    done

    echo "🎉 All workspace configurations decrypted successfully!"
  '';
in {
  # Install required packages for workspace management
  home.packages = with pkgs; [
    sops # For editing encrypted files
    gnupg # For GPG operations (Yubikey support)
    yq # For YAML processing in fish functions
  ];

  # Public workspace templates (not encrypted)
  home.file.".config/workspaces/templates" = {
    source = ./templates;
    recursive = true;
  };

  # Decrypt workspace files during home-manager activation
  # Only run if not in dry-run mode and we have a TTY for GPG interaction
  home.activation.decryptWorkspaces = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [[ -z "$DRY_RUN_CMD" ]] && [[ -t 0 ]]; then
      echo "🔐 Decrypting workspace configurations..."
      ${decryptWorkspaces}
    else
      echo "⏭️  Skipping workspace decryption (dry-run or no TTY)"
      echo "    Run manually: ~/.config/workspaces/decrypt-workspaces.sh"
    fi
  '';

  # Also provide the script as a standalone file for manual execution
  home.file.".config/workspaces/decrypt-workspaces.sh" = {
    source = decryptWorkspaces;
    executable = true;
  };
}
