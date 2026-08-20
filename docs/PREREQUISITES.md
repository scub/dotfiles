[Homebrew]: https://docs.brew.sh/
[Xcode]: https://developer.apple.com/xcode/

# Prerequisites

The following are required **before** executing the install script.

## Xcode

On a new (mac) machine [Xcode][Xcode] is required for most anything.

Open a terminal, enter the following, then go for a coffee...

```sh
xcode-select --install
```

It may say "Command line tools are already installed". If so, continue to next steps.

## Homebrew

[Homebrew][Homebrew] manages most of the utilities and apps we need to do the job.

Visit [https://brew.sh](https://brew.sh) to confirm install command is up to date.

See [Homebrew on Linux](https://docs.brew.sh/Homebrew-on-Linux) for Windows subsystem setup.

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

Follow "Next Steps" from the Homebrew installer's terminal output.

Ensure it's working before proceeding...

```sh
brew -v
```

## Hostname

At this point you may want to give your computer a recognizable host name.

This name will display in places like Github settings when you create tokens to authenticate this computer.

Change the default name in:
- System Settings > About > Name
- System Settings > Sharing > Local hostname

e.g. `MyMachine` and `MyMachine.local`

## Github

Since Github auth from the default terminal can be tricky, the best approach to cloning this repo is to use the GitHub CLI.

Install it with Homebrew...

```
brew install gh
```

Then authenticate your user, via web login...

```
gh auth login
```

Choose `Github.com`, `SSH` and `Yes` to generate a new SSH key to add to your GitHub account
(passphrase is optional).

The GitHub CLI will create and upload the SSH key. Before proceeding you will need to grant that
key access to any organization you want to access.

Go to your [account settings for SSH Keys](https://github.com/settings/keys) and select "Configure
SSO" for the key you just uploaded then click Authorize for each required org.

---
Continue to [INSTALL](./INSTALL.md)