# Dots

Configuration files, managed using a bare repository.

## Setup

The Git repository lives in `~/.dots`, while configuration files stay in their normal locations under `$HOME`.

```bash
git init --bare $HOME/.dots
```

Fish aliases (`~/.config/fish/config.fish`):

```fish
alias config='/usr/bin/git --git-dir=$HOME/.dots/ --work-tree=$HOME'
alias config:update='config add -u'
alias config:status='config status --short'
alias config:diff='config diff master'
alias config:diff:short='config diff master --name-only'
alias config:commit='config commit -m'
alias config:push='config push -u origin master'
alias config:leaks='gitleaks git --redact --verbose "$HOME/.dots"'
alias config:leaks:staged='gitleaks git --staged --redact --verbose "$HOME/.dots"'
```

Git configuration:

```bash
config config --local status.showUntrackedFiles no
```

## Basic usage

```bash
# Check status
config status
config status --short
# Add a configuration file
config add ~/.config/example
config add -A
config add -u
# See changes
config diff master
config diff master --names-only
# Commit
config commit -m "Add example config"
# Push
config push
# Pull
config pull
```

## Managing nested Git repositories

### Neovim / LazyVim

```bash
config rm --cached -r ~/.config/nvim
```

```bash
rm -rf ~/.config/nvim/.git
```

Then add the configuration:

```bash
config add ~/.config/nvim
```

### Tmux / TPM

Create `~/.config/tmux/.gitignore`:

```gitignore
/plugins/
```

```bash
config rm --cached -r ~/.config/tmux/plugins
```

Then add the Tmux configuration:

```bash
config add ~/.config/tmux
config status
```

On a new machine, install TPM and use `prefix + I` inside Tmux to install the plugins declared in your configuration.

## Using `dots` on a new machine

Clone the bare repository:

```bash
git clone --bare <repository-url> $HOME/.dots
```

```bash
config checkout
config config --local status.showUntrackedFiles no
```

## Branches

```bash
# Create a branch
config switch -c new-branch

# Switch branches
config switch main
```

## Security: scanning for secrets

Check with [Gitleaks](https://github.com/gitleaks/gitleaks).

### Scan Git history

```bash
config:leaks
```

This scans committed history, including secrets that may have been deleted in later commits.

### Scan staged changes

```bash
config:leaks-staged
```

## Removing files from tracking

```bash
config rm --cached ~/.some-config
```

```bash
config restore ~/.bashrc
```

Be careful: restoring discards uncommitted changes to that file.

## Reference

| Task | Command |
|---|---|
| Check status | `config status` |
| See changes | `config diff` |
| Add file | `config add FILE` |
| Commit | `config commit -m "message"` |
| Push | `config push` |
| Pull | `config pull` |
| Restore file | `config restore FILE` |
| Scan Git history | `config:leaks` |
| Scan staged changes | `config:leaks-staged` |
