#!/bin/bash

# Create the prepare-commit-msg hook
cat > .git/hooks/prepare-commit-msg << 'EOF'
#!/bin/bash

# Run the ClickUp sync script
./sync_github_clickup.sh

# Exit with success
exit 0
EOF

# Make the hook executable
chmod +x .git/hooks/prepare-commit-msg

echo "Git hook installed successfully!"
