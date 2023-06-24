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
        key = "%%GPG_KEY_ID%%";
        signByDefault = true;
      };
    };

    fish = {
      enable = true;
      plugins = [
      ];
      shellInit = ''
        set -x GPG_TTY (tty)
      '';
      shellAliases = {
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
      };
    };
  };

  programs.home-manager.enable = true;
}
