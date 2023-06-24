{ config, pkgs, ... }: {
  home.username = "william";
  home.homeDirectory = "/home/william";
  home.packages = with pkgs; [ openssh gawk ];

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
        # Set syntax highlighting colours; var names defined here:
        # http://fishshell.com/docs/current/index.html#variables-color
        set fish_color_autosuggestion brblack
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

  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
