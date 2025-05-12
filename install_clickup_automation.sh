#!/bin/bash

# Create scripts directory if it doesn't exist
mkdir -p .clickup-automation

# Download the scripts from GitHub
echo "Downloading ClickUp Git automation scripts..."
curl -s -o .clickup-automation/sync_github_clickup.sh https://raw.githubusercontent.com/Siqi-Hu/clickup-git-automation/refs/heads/main/sync_github_clickup.sh
curl -s -o .clickup-automation/setup_git_hooks.sh https://raw.githubusercontent.com/Siqi-Hu/clickup-git-automation/refs/heads/main/setup_git_hooks.sh
curl -s -o .clickup-automation/clickup_setup.sh https://raw.githubusercontent.com/Siqi-Hu/clickup-git-automation/refs/heads/main/clickup_setup.sh

# Make scripts executable
chmod +x .clickup-automation/sync_github_clickup.sh .clickup-automation/setup_git_hooks.sh .clickup-automation/clickup_setup.sh

# Run the setup script to configure ClickUp
echo "Setting up ClickUp configuration..."
./.clickup-automation/clickup_setup.sh

# Install Git hook
echo "Installing Git hook..."
./.clickup-automation/setup_git_hooks.sh

echo "✅ ClickUp Git automation setup complete!"
echo "The automation will run automatically when you make Git commits in this repository."
