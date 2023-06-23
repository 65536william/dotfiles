1. Download Nix with Flake support:

```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

2. Clone this repository and enter it.

3. Build and set up home-manager:

```
nix run . switch -- --flake .
```

4. On Linux, add fish to `/etc/shells`:

```
echo $(which fish) | sudo tee -a /etc/shells
```

Then set fish as the shell:

```
sudo chsh -s $(which fish) william
```