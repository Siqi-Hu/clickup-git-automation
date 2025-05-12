# ClickUp Git Automation

Automatically create ClickUp subtasks from Git commits and include the subtask ID in commit messages.

## Features

- Extracts the ClickUp task ID from branch names (format: `feat/CU-TASK_ID-description`)
- Creates a subtask in ClickUp for each commit
- Adds the new subtask ID to commit messages
- Works via Git hooks - no manual steps needed after setup
- **Secure**: Stores API keys in a local configuration file that's never committed to version control

## Installation

### Option 1: Quick Install (Recommended)

Run this command in your repository:

```bash
curl -s https://raw.githubusercontent.com/Siqi-Hu/clickup-git-automation/refs/heads/main/install_clickup_automation.sh | bash
```

You'll be prompted to enter your ClickUp API key during setup.

### Option 2: Manual Installation

1. Download the scripts:
   ```bash
   mkdir -p scripts
   curl -s -o scripts/sync_github_clickup.sh https://raw.githubusercontent.com/Siqi-Hu/clickup-git-automation/refs/heads/main/sync_github_clickup.sh
   curl -s -o scripts/setup_git_hooks.sh https://raw.githubusercontent.com/Siqi-Hu/clickup-git-automation/refs/heads/main/setup_git_hooks.sh
   curl -s -o scripts/clickup_setup.sh https://raw.githubusercontent.com/Siqi-Hu/clickup-git-automation/refs/heads/main/clickup_setup.sh
   chmod +x scripts/sync_github_clickup.sh scripts/setup_git_hooks.sh scripts/clickup_setup.sh
   ```

2. Run the setup script to configure ClickUp:
   ```bash
   ./scripts/clickup_setup.sh
   ```

3. Install the Git hook:
   ```bash
   ./scripts/setup_git_hooks.sh
   ```

## Configuration

Your ClickUp configuration is stored securely in `scripts/clickup_config.sh`. This file:
- Is automatically added to `.gitignore` to prevent accidental commits
- Has permissions set to owner-only access (chmod 600)
- Can be reconfigured at any time by running `./scripts/clickup_setup.sh` again

## Security Features

- API keys are never hardcoded in version-controlled files
- Configuration is stored with restricted permissions
- Automatic .gitignore entries prevent accidental exposure
- Secure input when providing API keys

## Usage

Once installed, the automation works automatically:

1. Create a branch with the ClickUp task ID in the name: `feat/CU-12345-add-feature`
2. Make changes and commit as usual: `git commit -m "Add new functionality"`
3. The script will:
   - Create a subtask in ClickUp under task 12345
   - Update your commit message to include the subtask ID

## Troubleshooting

If you encounter issues:

1. **Missing Configuration**: If you see "ClickUp configuration not found", run `./scripts/clickup_setup.sh`
2. **API Errors**: Check your API key by running setup again
3. **Task ID Not Found**: Ensure your branch name contains `CU-TASKID` (e.g., `feat/CU-12345-feature`)
4. **Hook Not Running**: Verify the hook is executable with `chmod +x .git/hooks/prepare-commit-msg`
