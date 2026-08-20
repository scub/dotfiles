[ASDF]: http://asdf-vm.com/
[Glow]: https://github.com/charmbracelet/glow
[Granted]: https://granted.dev
[Homebrew]: https://docs.brew.sh/
[Oh-My-ZSH]: https://ohmyz.sh/
[Stow]: https://www.gnu.org/software/stow/manual/stow.html
[Tabby]: https://tabby.sh/
[VS-Code]: https://code.visualstucdio.com/
[ZimFW]: https://github.com/zimfw/zimfw

# Install

This repo is self-installing for consistent cross-machine configuration. [See tutorial for more info.](https://www.jakewiesler.com/blog/managing-dotfiles)

> [!WARNING]
> **Before installing** use `rm ~/.zshrc` to delete the default ZSH profile. The installer will not
> overwrite any files, so if a ZSH profile exists it won't be able to link the one from dot files.

Run the install script below.

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/scub/dotenv-new/main/install.sh)"
```

OR clone this repo and run it locally

```sh
gh repo clone scub/dotenv-new $HOME/.dotfiles
. $HOME/.dotfiles/install.sh
```

## Process

The install script will do the following:
1. Clones the repo to  `$HOME/.dotfiles`
2. Set ZSH as default shell
3. Installs [Homebrew] utility [bundle](../Brewfile), including apps:
	- [Stow] manages system config modules
	- [Visual Studio Code][VS-Code] for... code
	- [Tabby] for cross platform terminal
	- [Granted] for AWS SSO session management
	- [Glow] to render markdown in shell
1. Links "stows" to `$HOME` folder, including:
	- A ZSH config file with sensible defaults
	- A script for storing shell secrets in Apple keychain
	- NPM config for setting token for private package
	- Yarn config for defaulting to use NPM token
	- ASDF config for legacy version file support

## Shell Modules

[Stow] is used to link configs for tools that are required to be in the `$HOME` dir.

All paths in `.dotfiles/config` are linked as Stow packages by the install script.

Shell modules are installed and loaded by [ZimFW] for ZSH (the default shell on Mac OS).
- Initialised by the [ZSH profile](../config/zsh/.zshrc) and [Zim script](../environment/zim.sh).
- Includes a suite of [Oh-My-ZSH] plugins, listed in the [`.zimrc`](../config/zim/.zimrc) config.

If there's an issue loading plugins see [manual installation guide](https://github.com/zimfw/zimfw#manual-installation).

---
Continue to [SECRETS](./SECRETS.md)