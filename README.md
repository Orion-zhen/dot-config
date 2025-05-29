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
git remote add origin https://Orion-zhen/dot-config.git
```

Fetch content and reset current commit to main:

```bash
git reset --hard origin/main
```

Finally, copy the backup files:

```bash
cp -rn ~/.config.bak ~/.config
```

Parameter `-n` will not overwrite existing config files.

