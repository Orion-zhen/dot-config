# dot-config

## Usage

First, backup your current `~/.config/`:

```bash
cp -r ~/.config ~/.config.bak
```

Then, navigate to `~/.config` and initialize a git repository with default branch name main:

```bash
git init --initial-branch=main
```

Add remote repository:

```bash
git remote add origin https://github.com/Orion-zhen/dot-config.git
```

Associate local branch with remote branch:

```bash
git branch --set-upstream-to origin/main
```

Fetch content and reset current commit to main:

```bash
git reset --hard origin/main
```

Finally, copy the backup files:

```bash
cp -rn ~/.config.bak/* ~/.config/
```

Parameter `-n` will not overwrite existing config files.
