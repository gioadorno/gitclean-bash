# GitClean-Bash

An easy to use script for rebasing and cleaning up branches. You can either use Reset or Rebase separetely or a combination of both with Clean.

### Scripts
- gitclean.sh (command) [branch_name - optional]
  ## Commands
  - clean
  - rebase
  - reset

## Rebase
This will fetch the requested branch (default is origin/master) to retrieve the updated changes. Then it will log if there are changes/conflicts. If there are no changes the script will exit, since there is no rebase to be had. Otherwise it will continue to perform a rebase. If there are conflicts, you will have to manually resolve those. You will be prompted press Enter to continue if all conflicts are resolved or press q to abort the process. The code will then be force pushed to the HEAD.

##### Example
```
gitclean rebase
```
or
```
gitclean rebase dashboard-feature-branch
```

## Reset
This will grab the latest commit hash of the parent branch and do a reset --soft to that commit hash. User will then be prompted to type a commit message and select git files to add (default is .). Then it will push to your branch, which should now have one commit.

##### Example
```
gitclean reset

### Enter a commit message:
Initiate dashboard feature

### Git file(s) or path to add. Default is '.':
(left blank for default)
```
## Clean
```
gitclean clean
```
or
```
gitclean clean dashboard-feature-branch
```
Will perform both the Rebase and Reset function
##
