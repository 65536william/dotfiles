#!/usr/bin/env bash
set -e

# Download Nix with Flake support
echo "Downloading Nix with Flake support..."
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm

# Load Nix into current shell session
echo "Loading Nix environment variables..."
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Build and setup home-manager
echo "Building and setting up home-manager..."
nix run . switch -- --flake .

# Add fish to /etc/shells
echo "Adding fish to /etc/shells..."
if ! grep -q $(which fish) /etc/shells; then
  echo $(which fish) | sudo tee -a /etc/shells
else
  echo "Fish shell is already in /etc/shells."
fi

# Set fish as the shell
echo "Setting fish as the shell..."
if [[ "$SHELL" != $(which fish) ]]; then
  chsh -s $(which fish) $USER
else
  echo "Fish shell is already the default shell."
fi

# Check SSH keys
echo "Checking SSH keys..."
if ! [ -f ~/.ssh/id_ed25519 ]; then
  ssh-keygen -t ed25519 -C 75908561+65536william@users.noreply.github.com -N "" -f ~/.ssh/id_ed25519
  echo "A new SSH key pair was generated. Public key:"
  cat ~/.ssh/id_ed25519.pub
else
  echo "An existing SSH key pair was found."
fi

# Check GPG keys
echo "Checking GPG keys..."
if ! gpg --list-secret-keys --keyid-format LONG "75908561+65536william@users.noreply.github.com" >/dev/null; then
  # Prompt the user for the passphrase
  echo "Please enter a passphrase for the new GPG key pair:"
  stty -echo  # Turn off input echoing
  read gpg_passphrase
  stty echo  # Turn input echoing back on

  # Use a heredoc to pass the configuration to gpg
  gpg --batch --gen-key <<-EOF
    Key-Type: RSA
    Key-Length: 4096
    Subkey-Type: RSA
    Subkey-Length: 4096
    Name-Real: 65536william
    Name-Email: 75908561+65536william@users.noreply.github.com
    Expire-Date: 0
    Passphrase: $gpg_passphrase
    %commit
    %echo done
EOF

  # Extract the key ID in one line using awk
  KEY_ID=$(gpg --list-secret-keys --keyid-format LONG "75908561+65536william@users.noreply.github.com" | awk '/sec/ {split($2,a,"/"); print a[2]}')

  echo "A new GPG key pair was generated. Public key:"
  gpg --armor --export $KEY_ID

  sed "s/%%GPG_KEY_ID%%/$KEY_ID/" home.nix > home.nix.tmp && mv home.nix.tmp home.nix
else
  echo "An existing GPG key pair was found."
fi

echo "Setup script completed successfully."
