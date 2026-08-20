This path uses the `.stow-local-ignore` to override the default behaviour of stow which would ignore
the `.gitignore` file, which is intended to be linked so the `.gitconfig` can reference it.

Dotfiles `.gitconfig` is not linked as a stow (ignored). Instead use `dotfiles-config` to run the
[config](../../config.sh) script and update the global configs at `~/.gitconfig` to **include** it.

The include config has only generic attributes, so user specific configs aren't committed to
dotfiles. They are generated in the uncommitted global config using secret values like `GIT_USER`.

Run `git config -l` After `dotfiles-config` to list all config values.