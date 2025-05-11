#!/bin/bash

# Create scripts directory if it doesn't exist
mkdir -p scripts

# Download the scripts from GitHub
echo "Downloading ClickUp Git automation scripts..."
curl -s -o scripts/sync_github_clickup.sh https://github.com/Siqi-Hu/clickup-git-automation/blob/main/sync_github_clickup.sh
curl -s -o scripts/setup_git_hooks.sh https://github.com/Siqi-Hu/clickup-git-automation/blob/main/setup_git_hooks.sh
curl -s -o scripts/clickup_setup.sh https://github.com/Siqi-Hu/clickup-git-automation/blob/main/clickup_setup.sh

# Make scripts executable
chmod +x scripts/sync_github_clickup.sh scripts/setup_git_hooks.sh scripts/clickup_setup.sh

# Run the setup script to configure ClickUp
echo "Setting up ClickUp configuration..."
./scripts/clickup_setup.sh

# Install Git hook
echo "Installing Git hook..."
./scripts/setup_git_hooks.sh

echo "✅ ClickUp Git automation setup complete!"
echo "The automation will run automatically when you make Git commits in this repository."
