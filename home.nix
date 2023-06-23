{ config, pkgs, ... }: {
    home.username = "william";
    home.homeDirectory = "/home/william";
    home.packages = [ pkgs.openssh ];

    home.activation.checkSSH = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      if ! [ -f ~/.ssh/id_ed25519 ]; then
        ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -C admin@williameliot.com -N "" -f ~/.ssh/id_ed25519
        echo "A new SSH key pair was generated."
      else
        echo "An existing SSH key pair was found."
      fi
    '';

    home.activation.checkVSCodeSettings = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      VSCODE_SETTINGS_PATH="$HOME/.vscode-server/data/Machine/settings.json"
      VSCODE_SETTINGS_DIR="$(dirname "$VSCODE_SETTINGS_PATH")"

      # Create the directory if it does not exist
      if [ ! -d "$VSCODE_SETTINGS_DIR" ]; then
        mkdir -p "$VSCODE_SETTINGS_DIR"
      fi

      # If the file does not exist, create it with the desired content
      if [ ! -f "$VSCODE_SETTINGS_PATH" ]; then
        echo '{
          "terminal.integrated.profiles.linux": {
            "Fish": {
              "path": "/home/william/.nix-profile/bin/fish"
            }
          },
          "terminal.integrated.defaultProfile.linux": "Fish"
        }' > "$VSCODE_SETTINGS_PATH"
        echo "VSCode settings were generated."
      else
        echo "Existing VSCode settings were found."
      fi
    '';
    programs = {
      git = {
        enable = true;
        userName = "65536william";
        userEmail = "75908561+65536william@users.noreply.github.com";
        extraConfig = {
          init = {
            defaultBranch = "main";
          };
          url."git@github.com:" = {
            insteadOf = "gh:";
            pushInsteadOf = "gh:";
          };
          push = {
            default = "current";
          };
        };
      };

      fish = {
        enable = true;
        plugins = [
        ];
        shellInit = ''
          # Set syntax highlighting colours; var names defined here:
          # http://fishshell.com/docs/current/index.html#variables-color
          set fish_color_autosuggestion brblack
        '';
        shellAliases = {
          cssh = "cat ~/.ssh/id_ed25519.pub";
        };
        shellAbbrs = {
        };
        functions = {
          g = ''
            function g -a message
              git add .
              git commit -m $message
              git push
            end
          '';
        };
      };
    };

    home.stateVersion = "23.05";
    programs.home-manager.enable = true;
}