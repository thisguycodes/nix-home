# unused: lib
{
  pkgs,
  inputs,
  roles,
  ...
}:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    # pkgs.ghostty
  ];

  nix.settings = {
    substituters = [
      "https://devenv.cachix.org"
      "https://cache.nixos.org"
      "https://ghostty.cachix.org"
    ];
    trusted-public-keys = [
      # this is the default one
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
    ];
  };

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  homebrew = {
    enable = true;
    global = {
      autoUpdate = true;
    };
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };
    brews = [
      "mas"
      # "gemini-cli"
      "ast-grep"
      "ykman"
      "opencode"
      # "ollama"
      "logcli"
      "yoanbernabeu/tap/grepai"
      "depot/tap/depot"
    ]
    ++ (
      if builtins.elem "work" roles then
        [
        ]
      else
        [ ]
    );
    taps = [
      "brewforge/extras"
      "anomalyco/tap"
      "yoanbernabeu/tap"
      "depot/tap"
    ]
    ++ (if builtins.elem "work" roles then [ "withgraphite/tap" ] else [ ]);
    casks = [
      "gcloud-cli"
      "1password-cli"
      "codex"
      "opencode-desktop"
      "secretive"
      "discord"
      "google-chrome"
      "ghostty"
      "signal"
      "rectangle-pro"
      "zed"
      "notion"
      "yubico-authenticator"
      # "gitify"
      # "podman-desktop"
      "docker-desktop"
      "linear-linear"
      "zoom"
      "1password"
      # "gpg-suite-no-mail"
      # {
      #   name = "grishka/grishka/neardrop";
      #   args = { no_quarantine = true; };
      # }
      # "podman-desktop"
    ]
    ++ (if builtins.elem "work" roles then [ "1password-cli" ] else [ ]);
    masApps = {
      todoist = 585829637;
      openin = 1643649331;
      bitwarden = 1352778147;
      # tailscale = 1475387142;
      # slack = 803453959;
    };
  };

  environment.shells = [ pkgs.zsh ];

  system.primaryUser = "thisguy";
  system.keyboard = {
    remapCapsLockToEscape = true;
  };

  system.defaults = {
    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "Nlsv";
      FXRemoveOldTrashItems = true;
      ShowPathbar = true;
      ShowStatusBar = true;
    };
    loginwindow = {
      GuestEnabled = false;
      DisableConsoleAccess = true;
    };

    menuExtraClock = {
      Show24Hour = true;
      ShowDate = 2;
      ShowDayOfWeek = true;
    };

    screensaver = {
      askForPassword = true;
      askForPasswordDelay = 5;
    };

    dock = {
      autohide = true;
      persistent-apps = [ ];
      persistent-others = [ ];
      showhidden = true;
      tilesize = 32;
    };

    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;

    NSGlobalDomain = {
      AppleInterfaceStyleSwitchesAutomatically = true;
      AppleShowAllFiles = true;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      AppleICUForce24HourTime = true;
    };
  };

  users.users.thisguy = {
    home = "/Users/thisguy";
    shell = pkgs.zsh;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  nix.optimise = {
    automatic = true;
    interval = {
      Hour = 4;
      Minute = 15;
      Weekday = 7;
    };
  };

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
