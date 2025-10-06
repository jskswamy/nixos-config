#!/usr/bin/env fish

function workspace-apply
    set nixos_config_dir (echo $NIXOS_CONFIG)
    if test -z "$nixos_config_dir"
        set nixos_config_dir "$HOME/nixos-config"
    end

    if test ! -d "$nixos_config_dir"
        echo "❌ nixos-config directory not found: $nixos_config_dir"
        echo "💡 Set NIXOS_CONFIG environment variable or ensure $HOME/nixos-config exists"
        return 1
    end

    echo "🔄 Applying workspace configuration changes..."
    echo "📂 Working directory: $nixos_config_dir"

    cd "$nixos_config_dir"
    nix run .#build-switch

    if test $status -eq 0
        echo "✅ Workspace configuration applied successfully!"
        echo "🎯 Decrypted workspace configs are now available in ~/.config/workspaces/"
    else
        echo "❌ Failed to apply workspace configuration"
        return 1
    end
end
