# Dot Files

Version managed portable development environment configuration.

>[!IMPORTANT]
> This repo contains no personal data or secrets, but some configs may be specific to an org and
> developer tooling.
>
> All modules are linked in [.zshrc](../zsh/.zshrc) and can be disabled to choose which to apply.

## Setup

1. Install [PREREQUISITES](./PREREQUISITES.md) before executing install script
2. Follow [INSTALL](./INSTALL.md) instructions to clone and install default tools
3. Assign [SECRETS](./SECRETS.md) required for shell and git config
4. Setup [ASDF](./ASDF.md) for multiple language and version support
5. Configure [AWS SSO](./AWSSSO.md) profiles for authenticating with AWS
6. Create [KEYS](./KEYS.md) for SSH and GPG access to git cloud providers

## Updating

#### Pulling Changes

To update your local dotfiles and get the benefit of any contributions since you setup your machine:
1. Go to the dotfiles path `cd $DOTFILES`
2. Make sure you have no uncommitted changes: `git status`
3. Ensure you're on the primary branch: `git checkout main`
4. Pull latest changes: `git pull`
6. Rerun installer to get new modules: `dotfiles-install`

#### Adding Home Configs

When installing a new tool that reads configuration from `$HOME`:
1. Create folder for configs: `mkdir $DOTFILES/config/my-new-tool`
2. Move any default configs: `mv $HOME/my-new-tool-config $DOTFILES/config/my-new-tool`
3. Stow to link back to home: `stow -v -t $HOME -d $DOTFILES/config -S my-new-tool`

#### Adding Shell Configs

When adding a new environment module (any custom shell configs, functions, alias etc):
1. Create (and edit) code: `touch $DOTFILES/environment/my-new-module.sh`
2. Start a new terminal session or run `zsh` to initialise in place

### Adding Brew Bundles

After adding a new package to `brewfile`, run `brew bundle install --file=$DOTFILES/brewfile`

### Pushing Changes

**Commit and push** any changes above to save for future installs.

**Re-running install** script will also reload modules `. $DOTFILES/install.sh`