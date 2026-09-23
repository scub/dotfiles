[Granted]: https://granted.dev

# AWS SSO

Some libraries use legacy credentials to authenticate AWS accounts

[Granted] can populate those values from SSO sessions.

## Setup

If you don't have `~/.aws/config` with your profile configs already, create one...

```sh
sso new
```

To find details for filling your account config:
- Login to AWS in the browser (e.g. through Okta tile) to review your available SSO accounts.
- Select "Access Keys" for the account you're setting up to see Start URL and Region settings.
- Choose a short session/profile name e.g. `dev` for your team dev account
- Use `JSON` as default output

[See docs for more details on AWS SSO configuration files](https://docs.aws.amazon.com/cli/latest/userguide/sso-configure-profile-token.html#sso-configure-profile-token-manual).

You'll need to do that once per profile to create the local config.

> [!Tip]
> Give profiles a simple name like `dev`, `staging` or `production`.
>
> The command is an alias for `aws configure sso` but also unsets active profile so configs don't
> apply to the wrong one.

## Usage

Switch into the desired profile, for example `dev`:

```sh
sso dev
```

Your prompt should now show the active session, e.g. `~/Code on ☁️  dev (us-east-1)`

Try the following to confirm the active account details:

```sh
aws sts get-caller-identity
```

---
Continue to [KEYS](./KEYS.md)