# SSH and GPG Keys

An SSH key for this computer should have been created already in the prerequisites step, when using:

```sh
gh auth login
```

The GitHub CLI has created a key and uploaded it to your account in the authentication process.

If you need to additional SSH keys follow this tutorial to create and add them to `ssh-agent`:
[https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

### GPG (optional)

Signing commits with a GPG is an additional security step that isn't required on all codebases, but
is good practice and it might help to be ready for changing compliance requirements.

Follow the steps here to create a new GPG key:
[https://docs.github.com/en/github/authenticating-to-github/managing-commit-signature-verification/generating-a-new-gpg-key](https://docs.github.com/en/github/authenticating-to-github/managing-commit-signature-verification/generating-a-new-gpg-key)

Continue on to the [link in step 14](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account) of the guidance above to add the GPG key to your GitHub account. You can also load the key into Gitlab and/or BitBucket if you use them.

Grab your GPG key id by running the following command, then copy the id after the type prefix in what is returned e.g. `ed25519/<THIS PART>`

```sh
gpg --list-secret-keys --keyid-format=long
```

Open the `.gitconfig` file in your home directory and add the following properties to your current config:

```sh
[user]
	signingkey = <COPIED KEY>
[commit]
	gpgsign = true
```

Next time you commit, you will be prompted to enter the passphrase that you used during the GPG set up steps.

Once you have committed, you can run `git log --show-signature` to verify that your commit was signed.

Additionally, in GitHub, your commits will show up with the green 'Verified' badge.

---

That's it, you're done!

Back to [README.md](./README.md)