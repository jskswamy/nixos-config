#!/usr/bin/env fish

function workspace-status
    echo "📋 Workspace System Status"
    echo "=========================="
    echo ""

    # Check decrypted workspace files
    set config_dir ~/.config/workspaces
    if test -d "$config_dir"
        echo "✅ Workspace directory exists: $config_dir"

        set decrypted_files (find "$config_dir" -name "*.yml" -not -path "*/templates/*" 2>/dev/null)
        if test (count $decrypted_files) -gt 0
            echo "✅ Available workspace files: "(count $decrypted_files)
            for file in $decrypted_files
                set file_name (basename "$file" .yml)
                set workspace_count (yq '.workspace | length' "$file" 2>/dev/null)
                echo "   📄 $file_name ($workspace_count workspaces)"
            end
        else
            echo "❌ No workspace configurations found"
            echo "💡 Run 'nix run .#build-switch' to activate configurations"
        end
    else
        echo "❌ Workspace directory not found: $config_dir"
        echo "💡 Run 'nix run .#build-switch' to create and populate workspace directory"
    end

    echo ""

    # Check template availability
    set template_dir ~/.config/workspaces/templates
    if test -d "$template_dir"
        set templates (find "$template_dir" -name "*.yml" 2>/dev/null)
        if test (count $templates) -gt 0
            echo "✅ Workspace templates: "(count $templates)
            for template in $templates
                echo "   📋 "(basename "$template" .yml)
            end
        else
            echo "⚠️  No workspace templates found"
        end
    else
        echo "❌ Template directory not found: $template_dir"
    end

    echo ""

    # List current tmux sessions related to workspaces
    if command -q tmux
        set workspace_sessions (tmux list-sessions 2>/dev/null | grep -E '^(nixos-config|workspace-)' || true)
        if test -n "$workspace_sessions"
            echo "✅ Active workspace tmux sessions:"
            echo "$workspace_sessions" | while read -l session
                echo "   🎬 $session"
            end
        else
            echo "📭 No active workspace tmux sessions"
        end
    else
        echo "❌ tmux not available"
    end

    echo ""
    echo "🔧 Commands:"
    echo "  workspace-list   - List available workspaces"
    echo "  workspace-open   - Open a workspace with tmux session"
    echo "  workspace-edit   - Edit encrypted workspace configurations"
end
