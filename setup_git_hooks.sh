#!/bin/bash

# Get the absolute path to the repository root
REPO_ROOT=$(git rev-parse --show-toplevel)

# Create the prepare-commit-msg hook
cat > "$REPO_ROOT/.git/hooks/prepare-commit-msg" << 'EOF'
#!/bin/bash

# Run the ClickUp sync script
"$REPO_ROOT/scripts/sync_github_clickup.sh"

# Exit with success
exit 0
EOF

# Make the hook executable
chmod +x "$REPO_ROOT/.git/hooks/prepare-commit-msg"

echo "Git hook installed successfully!"
