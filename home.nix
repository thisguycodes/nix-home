# unused: config
{
  config,
  pkgs,
  myPkgs,
  lib,
  roles,
  tailconfig,
  ...
}:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.sessionPath = [
    "$HOME/.local/bin"
    "/opt/homebrew/bin"
    "$HOME/go/bin"
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
    pkgs.nix-index

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    pkgs.nerd-fonts.jetbrains-mono
    #pkgs.ghostty
    #(pkgs.callPackage ./sigtop.nix {})
    pkgs.devcontainer
    pkgs.ansible
    pkgs.fd
    pkgs.uv
    pkgs.nodejs
    pkgs.bazelisk
    pkgs.bazel-watcher
    pkgs.ripgrep
    pkgs.k9s
    pkgs.kubectl
    pkgs.pv
    pkgs.dust
    pkgs.jq
    pkgs.tree
    pkgs.talosctl
    pkgs.gnupg
    pkgs.difftastic
    pkgs.helm-ls
    pkgs.yaml-language-server
    pkgs.entr
    pkgs.hubble

    myPkgs.mulsash

    pkgs.gron
    pkgs.dive
    pkgs.pinentry-curses
    # (pkgs.writeScriptBin "pinentry" "#!/bin/bash\nexec pinentry-curses \"$@\"")

    # out of date compared to homebrew
    # pkgs.codex

    # baseten
    pkgs.rancher
    pkgs.proto
    pkgs.helmsman
    pkgs.fluxcd

    # pkgs.comby ocaml is borked?
    # pkgs.yt-dlp
    pkgs.terraformer
    # pkgs.opentofu
    pkgs.awscli2
    pkgs.aws-vault
    pkgs.podman
    pkgs.docker
    # pkgs.podman-desktop
    pkgs.podman-tui
    pkgs.ollama

    pkgs.graphviz
    pkgs.pre-commit
    pkgs.cosign

    # dev env stuff
    # pkgs.zed-editor
    pkgs.devenv
    pkgs.direnv

    pkgs.delve

    pkgs.ffmpeg

    # lsps
    pkgs.nixd
    pkgs.nil
    pkgs.nixfmt
    pkgs.gopls
    pkgs.go

    pkgs.gitify
    pkgs.gemini-cli

    pkgs.terraform-docs
    (pkgs.wrapHelm pkgs.kubernetes-helm {
      plugins = with pkgs.kubernetes-helmPlugins; [
        helm-secrets
        helm-diff
        helm-s3
        helm-git
      ];
    })

    # my own stuff
    (pkgs.writeScriptBin "zip2img" (builtins.readFile ./tools/zip2img))
    (pkgs.writeScriptBin "nsender" (builtins.readFile ./tools/nsender))
    (pkgs.writeScriptBin "set-config" (builtins.readFile ./tools/set-config))
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".config/starship.toml".source = dotfiles/starship.toml;
    ".local/bin/bazel".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.bazelisk}/bin/bazelisk";
    # ".local/bin/zed".source =
    #   config.lib.file.mkOutOfStoreSymlink "/opt/homebrew/bin/zed-preview";
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/davish/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";
    TG_PROVIDER_CACHE = "1";
    TG_DEPENDENCY_FETCH_OUTPUT_FROM_STATE = "true";
  };

  programs.zed-editor = import ./zed-settings.nix {
    enable = false;
  };

  programs.mise = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.pay-respects = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.difftastic = {
    git.enable = true;
  };

  programs.kubeswitch = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      alias = {
        s = "switch";
        l = "log --graph --pretty='commit: %C(bold red)%h%Creset author: %C(bold blue)%an%Creset %C(blue)<%ae>%Creset %C(bold magenta)%d %Creset%ndate: %C(bold yellow)%cd%n%C(cyan)%s%n%Creset'";
        fc = "!f(){ git diff --name-only --pretty='' $1..HEAD | sort | uniq; }; f";
        cam = "commit -am";
        cm = "commit -m";
        co = "checkout";
        cob = "checkout -b";
        uncommit = "reset --soft HEAD^";
        unadd = "reset HEAD --";
        discard = "reset HEAD --hard";
        wipe = "clean -fd";
        pr = "!f() { git fetch --force origin pull/$1/head:pr-$1; }; f";
        dfm = "diff HEAD main --";
      };
      user = {
        name = "Travis Johnson";
        email = "travis@thisguy.codes";
        # signingkey = "F7B1F29963D9D8B261A707D201E95421D282D509";
        signingkey = "/Users/thisguy/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/PublicKeys/61578cbdf7cccdc289c6decd08b4fb19.pub";
      };
      diff.external = "difft";
      difftool."difftastic" = {
        cmd = "difft \"$MERGED\" \"$LOCAL\" \"abcdef1\" \"100644\" \"$REMOTE\" \"abcdef2\" \"100644\"";
      };
      diff.tool = "difftastic";
      difftool.prompt = false;
      pager.difftool = true;
      # issues with rebase files keeping old content
      # core.editor = "zed --wait";
      core.editor = "nvim";
      init = {
        defaultBranch = "main";
      };
      push = {
        autoSetupRemote = true;
      };
      commit.gpgsign = true;
      gpg.format = "ssh";
      # TODO: only disable this on specific machine
      # log.showSignature = true;
    };
  };

  programs.git-cliff.enable = true;

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };

  programs.gh-dash = {
    enable = true;
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    extraConfig = lib.strings.concatStringsSep "\n" [
      # "IdentityAgent %d/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh"
      "IdentityAgent \"%d/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\""
    ];
    matchBlocks = {
      "*" = {
        compression = true;
        forwardAgent = true;
        controlMaster = "auto";
        controlPersist = "10m";
        hashKnownHosts = true;
      };
    };
  };

  programs.ghostty = {
    enable = false;
    enableZshIntegration = true;
    installVimSyntax = true;
  };

  programs.zellij = {
    enable = true;
    # enableZshIntegration = true;
    attachExistingSession = true;
    exitShellOnExit = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
    autocd = true;
    autosuggestion.enable = true;
    autosuggestion.strategy = [
      "match_prev_cmd"
      "history"
      "completion"
    ];
    #initExtra = "eval \"\$(${pkgs.zellij}/bin/zellij setup --generate-completion zsh)\"";
    envExtra = ''
      export SSH_AUTH_SOCK=$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh
    '';
    initContent =
      let
        entries = {
          clicolor = lib.mkOrder 1501 ''
            export CLICOLOR=1
          '';
          opts = lib.mkOrder 499 ''
            setopt autopushd
          '';
          aliases = lib.mkOrder 1501 ''
            alias cdg='cd $(git rev-parse --show-toplevel)'
          '';
          # expandDots = lib.mkOrder 1501 ''
          #   function _expand-dot-to-parent-directory-path {
          #     if [[ $LBUFFER = *..  && -d $LBUFFER ]]; then
          #       LBUFFER+='/..'
          #     else
          #       LBUFFER+='.'
          #     fi
          #   }
          #   zle -N _expand-dot-to-parent-directory-path
          #   for keymap in 'emacs' 'viins'; do
          #     bindkey -M "$keymap" "." expand-dot-to-parent-directory-path
          #   done
          # '';
          deriveFunc = lib.mkOrder 1501 ''
            derive() {
              zparseopts -E -D -- \
                u=update \
                -update=update
              if [[ "$update" ]]; then
                (
                  cd ~/.config/nix-darwin
                  nix flake update
                )
              fi
              sudo darwin-rebuild switch --flake ~/.config/nix-darwin
            }
          '';
          viMode = lib.mkOrder 1001 ''
            bindkey -v
          '';
          disableSystemCompinit = lib.mkOrder 0 ''
            skip_global_compinit=1
          '';
          fuzzyCompletions = lib.mkOrder 1001 ''
            zstyle ':completion:*' completer _complete _match _approximate
            zstyle ':completion:*:match:*' original only
            zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'
          '';
          prettyCompletions = lib.mkOrder 1001 ''
            zstyle ':completion:*:matches' group 'yes'
            zstyle ':completion:*:options' description 'yes'
            zstyle ':completion:*:options' auto-description '%d'
            zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
            zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
            zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
            zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
            zstyle ':completion:*:default' list-prompt '%S%M matches%s'
            zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
            zstyle ':completion:*' group-name '''
            zstyle ':completion:*' verbose yes
            zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
            zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
            zstyle ':completion:*' use-cache true
            zstyle ':completion:*' rehash true
          '';
          menuCompletions = lib.mkOrder 1001 ''
            zstyle ':completion:*' menu select
          '';
          colorCompletions = lib.mkOrder 1001 ''
            zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
          '';
          # forGit = lib.mkOrder 2000 ''
          #   zi as'null' wait'1' lucid for sbin wfxr/forgit
          # '';
        };
      in
      lib.mkMerge (lib.attrValues entries);
    history = {
      append = true;
      expireDuplicatesFirst = true;
      extended = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      saveNoDups = true;
      share = true;
      size = 100000;
    };
    historySubstringSearch.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.gpg-agent = {
    enable = true;
    enableScDaemon = true;
    enableZshIntegration = true;
    defaultCacheTtl = 3600;
  };

  services.ollama =
    if builtins.elem "ollama" roles then
      {
        enable = true;
        host = tailconfig.ip;
      }
    else if builtins.elem "work" roles then
      {
        enable = true;
        host = "localhost";
      }
    else
      { };
}
