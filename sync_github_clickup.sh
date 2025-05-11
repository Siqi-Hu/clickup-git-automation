#!/bin/bash

# Define ClickUp API Token and Workspace/Spcae IDs
CLICKUP_API_URL="https://api.clickup.com/api/v2"
CLICKUP_API_KEY="pk_170606338_HLDE9WPFDF4APAIPAPLVWP48P2CGNPRM"
WORKSPACE_ID="9015861084"
SPACE_ID="90154560480"

# Get the commit message (the last commit message)
COMMIT_MESSAGE=$(git log -1 --pretty=%B)

# Extract the task ID from the commit message
BRANCH=$(git symbolic-ref --short HEAD)
TICKET_ID=$(echo $BRANCH | grep -oE '[A-Z]+-[a-z0-9]+')
TASK_ID=$(echo $TICKET_ID | grep -oE '[a-z0-9]+')

if [ -z "$TASK_ID" ]; then
    echo "No task ID found in the current branch. Skipping subtask creation"
    exit 0
fi

echo "Task ID found: $TASK_ID"

# Create the subtask in Clickup (POST request to the ClickUp API)
# Get the commit message (for a new commit, this will be from the COMMIT_EDITMSG file)
if [ -f .git/COMMIT_EDITMSG ]; then
    COMMIT_MESSAGE=$(cat .git/COMMIT_EDITMSG)
else
    # Fall back to last commit if not in a commit context
    COMMIT_MESSAGE=$(git log -1 --pretty=%B)
fi

echo "Commit message: $COMMIT_MESSAGE"

# GET the list ID for the current task

# API endpont to get the correct list ID for the current task ID
LIST_INFO=$(curl -X GET "$CLICKUP_API_URL/task/$TASK_ID" \
	-H "Authorization: $CLICKUP_API_KEY" \
        -H 'accept: application/json')

if echo "$LINST_INFO" | grep -q "err"; then
    echo "Error fetching task information: $(echo '$LIST_INFO' | jq -r '.err')"
    exit 1
fi

LIST_ID=$(echo "$LIST_INFO" | jq -r '.list.id')
echo "List ID: $LIST_ID"

# Create subtask in ClickUp
SUBTASK_NAME="Code: ${COMMIT_MESSAGE%%$'\n'*}" # use first line of commit message
SUBTASK_DESCRIPTION="Subtask created from commit:\n\n$COMMIT_MESSAGE"

SUBTASK_PAYLOAD=$(cat <<EOF
{
    "name": "$SUBTASK_NAME",
    "description": "$SUBTASK_DESCRIPTION",
    "status": "in development",
    "parent": "$TASK_ID"
}
EOF
)

SUBTASK_RESPONSE=$(curl -X POST "$CLICKUP_API_URL/list/$LIST_ID/task" \
        -H "Authorization: $CLICKUP_API_KEY" \
        -H "accept: application/json" \
	-H "content-type: application/json" \
        -d "$SUBTASK_PAYLOAD")

# Check if subtask creation was successful
if echo "$SUBTASK_RESPONSE" | grep -q "error"; then
    echo "Error creating subtask: $(echo '$SUBTASK_RESPONSE' | jq -r '.err')"
    exit 1
fi

# Extract the new subtask ID
NEW_SUBTASK_ID=$(echo "$SUBTASK_RESPONSE" | jq -r '.id')
echo "Created subtask with ID: $NEW_SUBTASK_ID"

# Update the commit message to include the subtask ID
NEW_COMMIT_MESSAGE="$COMMIT_MESSAGE [CU-$NEW_SUBTASK_ID]"
echo "$NEW_COMMIT_MESSAGE" > .git/COMMIT_EDITMSG

echo "Updated commit message with subtask ID"
echo "Done!"

exit 0
