#!/bin/bash

branch="${1:-origin/master}"

# 1. Fetch
git fetch origin "$branch"

# 2. Check for changes
log_output=$(git log HEAD.."$branch")

if [[ -z "$log_output" ]]; then
  echo "No new changes on $branch branch"
  exit 0
fi

echo "Changes found on $branch"
echo "$log_output"

# 3. Perform rebase
echo "Starting rebase onto $branch"
git rebase "$branch"
rebase_status=$?

if [[ $rebase_status -ne 0 ]]; then
  read -r -p "Please resolve your conflicts. Press Enter to continue or q to abort process: " choice

  case "$choice" in
  "") # Enter key
    echo "Continuing rebase..."
    ;;
  q | Q)
    echo "Aborting rebase..."
    git rebase --abort
    echo "Rebase aborted."
    exit 1
    ;;
  *)
    echo "Invalid input. Please press Enter or q."
    ;;
  esac
fi

# 4. Force Push
echo "Force pushing changes..."
git push --force-with-lease origin HEAD

exit 0
