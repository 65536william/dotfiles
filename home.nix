{ config, pkgs, ... }: {
  home = {
    username = "william";
    homeDirectory = "/home/william";
    packages = with pkgs; [];
    stateVersion = "23.05";
  };

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
      signing = {
        key = "%%GPG_KEY_ID%%"";
        signByDefault = true;
      };
    };

    fish = {
      enable = true;
      plugins = [
      ];
      shellInit = ''
        # Set the default kube context if present
        set -gx DEFAULT_KUBE_CONTEXTS "$HOME/.kube/config"
        if test -f "$DEFAULT_KUBE_CONTEXTS"
          set -gx KUBECONFIG "$DEFAULT_KUBE_CONTEXTS"
        end

        # Additional contexts should be in ~/.kube/clusters/
        set -gx CUSTOM_KUBE_CONTEXTS "$HOME/.kube/clusters"
        mkdir -p "$CUSTOM_KUBE_CONTEXTS"

        for contextFile in (find "$CUSTOM_KUBE_CONTEXTS" -type f)
          set -gx KUBECONFIG "$contextFile":"$KUBECONFIG"
        end
        set -gx GPG_TTY (tty)
      '';
      shellAliases = {
        s = "source venv/bin/activate.fish";
        cssh = "cat ~/.ssh/id_ed25519.pub";
        cgpg = "gpg --armor --export";
        nswitch = "nix run . switch -- --flake .";
      };
      shellAbbrs = {
      };
      functions = {
        g = ''
          function g -a message
            git add .
            git commit -m "$message"
            git push
          end
        '';
        d = ''
          function d
            if test -f package.json
              if command -s yarn
                yarn dev
              else if command -s npm
                npm run dev
              end
            else
              echo "No package.json file found or 'dev' script is not defined in package.json."
            end
          end
        '';
      };
    };
  };

  programs.home-manager.enable = true;
}
