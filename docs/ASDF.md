[ASDF]: http://asdf-vm.com/

# ASDF

[ASDF] is installed for installing and switching runtime environment versions.

## Setup NodeJS

Install the Node plugin

```sh
asdf plugin-add nodejs
```

List the all Node versions (or find the [LTS versions
online](https://nodejs.org/en/about/previous-releases))

```sh
asdf list all nodejs
```

Define a **global** Node version. e.g. `22.2.0` for new features...

```sh
asdf install nodejs 22.2.0
asdf global nodejs 22.2.0
```

When you move into project directories, you may need to install the local version.

**For example** in a project path there might be a `.tool-versions` with `nodejs 20.9.0`

To make that version available, install it with:

```sh
asdf install nodejs 20.9.0
```

> [!NOTE]
> For MAC M1, if you want to install Node version `<16.x` run with `arch > -x86_64`

```sh
arch -x86_64 asdf install nodejs 14.15.4
```

### Setup PNPM

ASDF can also manage your PNPM version per project.

This is an **optional** step as opposed to using a global PNPM installed via Homebrew or Node's own
[Corepack](https://nodejs.org/api/corepack.html) (which is still experimental).

e.g. for setting up PNPM version `9.12.0` in a given project...

```sh
asdf plugin-add pnpm
asdf install pnpm 9.12.0
asdf local pnpm 9.12.0
```

### Setup Python

Install the Python plugin

```sh
asdf plugin-add python
```

List all Python 3 versions to find latest

```sh
asdf list all python 3
```

install any version greater than `3.9` for compatibility, e.g. `3.12.3`

```sh
asdf install python 3.12.3
```

Set the global version if you need to for system utils and ad-hoc scripts outside projects:

```sh
asdf global python 3.12.3
```

---
Continue to [AWSSSO](./AWSSSO.md)