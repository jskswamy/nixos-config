#!/usr/bin/env fish

function workspace-edit
    # Find all workspace config files
    set workspace_files (find ~/.config/workspaces -name "*.yml" -not -path "*/templates/*" 2>/dev/null)

    if test (count $workspace_files) -eq 0
        echo "❌ No workspace files found. Please run 'nix run .#build-switch' first to decrypt workspace configs."
        return 1
    end

    # Use fzf to select workspace file
    set selected_file (printf '%s\n' $workspace_files | sed "s|$HOME/.config/workspaces/||" | fzf --prompt="Edit workspace file: ")

    if test -z "$selected_file"
        echo "❌ No workspace file selected."
        return 1
    end

    # Find corresponding encrypted file in nixos-config
    set nixos_config_dir (echo $NIXOS_CONFIG)
    if test -z "$nixos_config_dir"
        set nixos_config_dir "$HOME/nixos-config"
    end

    set encrypted_file (string replace .yml .yaml "$nixos_config_dir/secrets/workspaces/$selected_file")

    if test ! -f "$encrypted_file"
        echo "❌ Encrypted file not found: $encrypted_file"
        return 1
    end

    echo "📝 Editing encrypted workspace configuration..."
    sops "$encrypted_file"

    echo "✅ Workspace configuration edited."
    echo "💡 Run 'workspace-apply' or 'nix run .#build-switch' to apply changes."
end
