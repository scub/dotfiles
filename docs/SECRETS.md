[Keychain]: https://ss64.com/osx/security.html
[Weather CLI]: https://github.com/chubin/wttr.in

## Secrets

The [`secrets.sh`](../environment/secret.sh) file provides a function to store key/value pairs in Apple [Keychain] for simple and secure loading.

Dotfiles exports a set of secrets as environment variables, allowing per-user shell configuration without committing to source.

### Generic Setup

Set **all below** that apply, e.g. `secret set NPM_TOKEN "<YOUR_TOKEN>"`

| Variable             | Description                                             | Example                         |
| -------------------- | ------------------------------------------------------- | ------------------------------- |
| `GIT_NAME`           | Set your git username for generating user config        | `Name`                          |
| `GIT_EMAIL`          | Set your git username for generating user config        | `name@gmail.com`                |
| `GIT_USERNAME`       | Set your git username for generating user config        | `user_name`                     |
| `HOMETOWN`           | Set home town for weather util                          | `Philadelphia`                  |
| `NPM_TOKEN`          | Set NPM.js token                                        |                                 |                   


#### Secrets to obfuscate internal sauce 

| Variable             | Description                                             | Example                         |
| -------------------- | ------------------------------------------------------- | ------------------------------- |
| `1P_VAULT`           | Set personal 1password vault name                       | `personal`                      |
| `1P_ENV_ITEM`        | Set 1password item name holding environment config      | `myenv`                         |
| `INTERNAL_REG`       | Set URL for internal registry (npm/yarn)                | `myregurl.com`                  |
| `QMAN_URL`           | Set the QMAN Url for surfacing queue info               | `qman.fu`                       |
| `TELEPORT_ENTRY`     | Set the teleport instance for use by helpers            | `teleport.sh`                   |

### Usage

- Set secret value with `secret set MY_SECRET_KEY MY_SECRET_VALUE`
- Get secret value with `secret get MY_SECRET_KEY`
- Unset secret with `secret unset MY_SECRET_KEY`
- Export secret to shell `secret export MY_SECRET_KEY`

### Configure Git

Once you've set all `GIT_` vars you can run the [config](../config.sh) script to populate local
git configuration.

First restart your shell for all secrets to be read into environment

```sh
zsh
```

Now run the config script...

```sh
. $DOTFILES/config.sh
```

---
Continue to [ASDF](./ASDF.md)