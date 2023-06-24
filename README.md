1. Clone this repository:

```
git clone https://github.com/65536william/dotfiles
```

2. Enter the `dotfiles` folder:

```
cd dotfiles
```

3. Run the setup script:

```
sh setup.sh
```

4. Copy the SSH public key and the GPG public key (which should have been printed to the terminal) to [GitHub](https://github.com/settings/keys).

# Notes

- Whenever pushing a change to this repo, make sure to swap out the true git signing key id with `%%GPG_KEY_ID%%`.