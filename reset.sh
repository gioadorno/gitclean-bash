#!/bin/bash

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
  git push --force-with-lease origin HEAD
  if [[ $? -ne 0 ]]; then
    echo "Push failed."
    exit 1
  fi
fi
echo "Branch is cleaned and updated."

exit 0
