#!/bin/bash

branch="$1"

# Reset
./reset.sh --no-push
if [[ $? -ne 0 ]]; then
  echo "There was an error attempting to reset branch."
  exit 1
fi

# Rebase
./rebase.sh "$branch"
if [[ $? -ne 0 ]]; then
  echo "There was an error attempting to rebase."
  exit 1
fi

echo "Clean successful."

exit 0