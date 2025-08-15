# Spell Check for Git commit messages 

Modified from the following article:

https://janosh.dev/posts/git-spellchecker


## Steps

```

### Set a git hooks directory path


```bash
git config --global core.hooksPath ~/.gitHooks
```

Make sure the directory is created or exists.

```bash
mkdir -p ~/.gitHooks
```

### Create a spell check hook

Add the following script to a file named `commit-msg` in the `~/.gitHooks` directory:

```bash
#!/bin/sh

# Adapted from https://reddit.com/r/bash/comments/49sflp/spellcheck_git_commit_hook.
if ! command -v aspell &>/dev/null; then
  printf "%s\n" "[commit-msg hook] Warning: 'aspell' not installed. Unable to spell check commit message."
  exit 0
fi

commit_msg_file="$1"
wordList=( $(grep -v "^  " "$commit_msg_file" | aspell list) )

if (( "${#wordList[@]}" > 0 )); then
  printf "%s\n" "[commit-msg hook] Possible spelling errors found in commit message:" "${wordList[@]}"
  # Check if running inside a terminal where the user can be prompted to handle
  # possible spelling errors. See https://stackoverflow.com/a/911213.
  if [ -t 1 ]; then
    # Adapted from https://stackoverflow.com/a/10015707.
    exec < /dev/tty
    while true; do
      read -p "[commit-msg hook] Proceed anyway? (y/n) " yn
      if [ "$yn" = "" ]; then
        yn='y'
      fi
      case $yn in
          [Yy] ) break;;
          [Nn] ) exit 1;;
          * ) echo "Please answer y for yes or n for no.";;
      esac
    done
  else
    exit 1
  fi
fi
```




