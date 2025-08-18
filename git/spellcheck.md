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

Add the following script to a file named `commit-msg` in the `~/.gitHooks` directory.
