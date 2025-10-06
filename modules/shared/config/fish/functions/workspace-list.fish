#!/usr/bin/env fish

function workspace-list
    set config_dir ~/.config/workspaces

    if test ! -d "$config_dir"
        echo "❌ Workspace directory not found: $config_dir"
        echo "💡 Run 'nix run .#build-switch' to activate workspace configurations"
        return 1
    end

    # Find all workspace YAML files
    set workspace_files (find "$config_dir" -name "*.yml" -not -path "*/templates/*" 2>/dev/null)

    if test (count $workspace_files) -eq 0
        echo "❌ No workspace configurations found"
        echo "💡 Create workspace configs in secrets/workspaces/ and run 'nix run .#build-switch'"
        return 1
    end

    echo "📋 Available workspaces:"
    echo ""

    # Parse and display workspaces from each file
    for file in $workspace_files
        set file_name (basename "$file" .yml)
        echo "📁 $file_name:"

        # Extract workspace names and descriptions
        yq '.workspace[]? | "  🎯 " + .name + " - " + (.description // "No description")' "$file" 2>/dev/null
        echo ""
    end

    echo "💡 Commands:"
    echo "  workspace-open <name>   - Open a workspace"
    echo "  workspace-edit          - Edit workspace configurations"
    echo "  workspace-status        - Check configuration status"
end
