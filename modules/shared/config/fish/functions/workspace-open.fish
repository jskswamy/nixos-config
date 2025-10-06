#!/usr/bin/env fish

function workspace-open
    set workspace_name $argv[1]

    if test -z "$workspace_name"
        echo "❌ Usage: workspace-open <workspace-name>"
        echo "💡 Run 'workspace-list' to see available workspaces"
        return 1
    end

    set config_dir ~/.config/workspaces

    if test ! -d "$config_dir"
        echo "❌ Workspace directory not found: $config_dir"
        echo "💡 Run 'nix run .#build-switch' to activate workspace configurations"
        return 1
    end

    # Find workspace in all config files
    set workspace_found false
    set workspace_config ""

    for file in (find "$config_dir" -name "*.yml" -not -path "*/templates/*" 2>/dev/null)
        set workspace_match (yq ".workspace[]? | select(.name == \"$workspace_name\")" "$file" 2>/dev/null)
        if test -n "$workspace_match"
            set workspace_found true
            set workspace_config "$workspace_match"
            break
        end
    end

    if test "$workspace_found" = false
        echo "❌ Workspace '$workspace_name' not found"
        echo "💡 Available workspaces:"
        workspace-list
        return 1
    end

    echo "🚀 Opening workspace: $workspace_name"

    # Extract workspace details
    set workspace_root (echo "$workspace_config" | yq '.root' 2>/dev/null)
    set workspace_description (echo "$workspace_config" | yq '.description // "No description"' 2>/dev/null)

    # Remove quotes from yq output
    set workspace_root (string trim --chars='"' "$workspace_root")
    set workspace_description (string trim --chars='"' "$workspace_description")

    # Expand tilde in workspace root path
    set workspace_root (string replace --regex '^~' "$HOME" "$workspace_root")

    echo "📂 Root: $workspace_root"
    echo "📝 Description: $workspace_description"

    # Change to workspace root directory
    if test -d "$workspace_root"
        cd "$workspace_root"
        echo "✅ Changed to workspace directory"

        # Set environment variables from workspace config
        set env_vars (echo "$workspace_config" | yq '.environment // {}' 2>/dev/null)
        if test "$env_vars" != "null" -a "$env_vars" != "{}"
            echo "🔧 Setting environment variables..."
            for key in (echo "$env_vars" | yq 'keys[]' 2>/dev/null)
                set key (string trim --chars='"' "$key")
                set value (echo "$env_vars" | yq ".$key" 2>/dev/null | string trim --chars='"')
                # Expand tilde in environment variable values
                set value (string replace --regex '^~' "$HOME" "$value")
                set -gx "$key" "$value"
                echo "   $key=$value"
            end
        end

        # Launch tmux session if configured
        set tmux_config (echo "$workspace_config" | yq '.tmuxp // null' 2>/dev/null)
        if test "$tmux_config" != "null" -a -n "$tmux_config"
            echo "🎬 Creating tmux session with tmuxp..."

            # Create temporary tmuxp config file
            set tmuxp_file "/tmp/workspace-$workspace_name-"(date +%s)".yaml"
            echo "$tmux_config" > "$tmuxp_file"

            # Get session name for attachment
            set session_name (echo "$tmux_config" | yq '.session_name' 2>/dev/null | string trim --chars='"')

            # Kill existing session if it exists
            tmux kill-session -t "$session_name" 2>/dev/null || true

            # Load session with tmuxp (show output for debugging)
            echo "   📝 Using config: $tmuxp_file"
            echo "   🔍 Config content:"
            cat "$tmuxp_file"
            echo ""
            if tmuxp load "$tmuxp_file" --yes
                echo "   ✅ Session created: $session_name"

                # Clean up temp file
                rm -f "$tmuxp_file"

                # Attach to session
                echo "🎯 Attaching to tmux session: $session_name"

                # Check if we're already in tmux
                if test -n "$TMUX"
                    echo "⚠️  Already in tmux - switching to workspace session"
                    tmux switch-client -t "$session_name"
                else
                    exec tmux attach-session -t "$session_name"
                end
            else
                echo "❌ Failed to create tmux session with tmuxp"
                echo "💡 Config file: $tmuxp_file"
                cat "$tmuxp_file"
                return 1
            end
        else
            echo "🎯 Ready to work in $workspace_name"
            echo "💡 No tmux configuration found - working in current shell"
        end
    else
        echo "❌ Workspace root directory does not exist: $workspace_root"
        return 1
    end
end
