#!/bin/bash

# Clean Command
clean() {
  branch="$1"

  # Reset
  reset --no-push
  if [[ $? -ne 0 ]]; then
    echo "There was an error attempting to reset branch."
    exit 1
  fi

  # Rebase (call the rebase function)
  rebase "$branch"
  if [[ $? -ne 0 ]]; then
    echo "There was an error attempting to rebase."
    exit 1
  fi

  echo "Clean successful."
}

# Rebase Command
rebase() {
  branch="${1:-master}"

  # 1. Fetch
  git fetch "$branch"

  # 2. Check for changes
  log_output=$(git log HEAD.."$branch")

  if [[ -z "$log_output" ]]; then
    echo "No new changes on $branch branch"
    exit 0
  fi

  echo "Changes found on $branch"

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

}

# Reset Command
reset() {
  # 1. Find the parent's last commit
  echo "Fetching parent's last commit..."
  first_commit=$(git rev-list --max-parents=0 HEAD)

  # 2. Reset commits
  echo "Resetting commits..."
  git reset --soft "$first_commit"
  if [[ $? -ne 0 ]]; then
    echo "Reset failed."
    exit 1
  fi
  echo "Reset complete."

  # 3. Prompt the user for a commit message
  read -r -p "Enter a commit message: " commit_msg

  # 4. Prompt the user to add file(s) or path
  read -r -p "Git file(s) or path to add. Default is '.': " file_path
  if [[ -z "$file_path" ]]; then
    file_path="."
  fi
  git add "$file_path"

  # 5. Commit the changes
  git commit -a -m "$commit_msg"
  if [[ $? -ne 0 ]]; then
    echo "Commit failed."
    exit 1
  fi
  echo "Commit complete."

  # 6. Push to the HEAD branch
  if [[ "$1" == "--no-push" ]]; then
    echo "Skipping force push..."
  else
    echo "Pushing changes..."
    git push --force-with-lease origin HEAD
    if [[ $? -ne 0 ]]; then
      echo "Push failed."
      exit 1
    fi
  fi
  echo "Branch is cleaned and updated."
}

# Main script logic
if [[ $# -eq 0 ]]; then
  echo "Usage: gitclean {clean|rebase|reset} [branch_name]"
  exit 1
fi

case "$1" in
clean)
  clean "$2"
  ;;
rebase)
  rebase "$2"
  ;;
reset)
  reset
  ;;
*)
  echo "Invalid command: $1"
  exit 1
  ;;
esac

exit 0
