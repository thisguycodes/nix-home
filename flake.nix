{
  description = "Travis' nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    mulsash.url = "github:thisguycodes/mulsash";
    mulsash.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      home-manager,
      nixpkgs,
      mulsash,
      ...
    }:
    let
      setup =
        {
          tailconfig ? {
            ip = "127.0.0.1";
            name = "";
          },
          roles ? [ ],
          taildomain ? "giraffe-ide.ts.net",
          ...
        }:
        nix-darwin.lib.darwinSystem {
          # TODO: an array of... functions?!
          modules = [
            ./darwin.nix
            home-manager.darwinModules.home-manager
            (
              { pkgs, ... }:
              {
                # TODO: better understand this option
                # https://discourse.nixos.org/t/home-manager-useuserpackages-useglobalpkgs-settings/34506/4
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.thisguy = import ./home.nix;
                home-manager.extraSpecialArgs = {
                  inherit roles taildomain tailconfig;
                  myPkgs = {
                    mulsash = mulsash.packages.${pkgs.stdenv.hostPlatform.system}.default;
                  };
                };
              }
            )
            {
              nixpkgs.config.allowUnfreePredicate =
                pkg:
                builtins.elem (nixpkgs.lib.getName pkg) [
                  "terraform"
                ];
            }
          ];
          specialArgs = {
            inherit inputs;
            inherit roles taildomain tailconfig;
          };
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Traviss-MacBook-Pro
      darwinConfigurations."Traviss-MacBook-Pro" = setup {
        roles = [ "ollama" ];
        tailconfig = {
          ip = "100.97.56.50";
          name = "oc";
        };
      };
      darwinConfigurations.ThisGrunt = setup {
        roles = [ "ollama" ];
      };
      darwinConfigurations.ThisBase = setup {
      };
      darwinConfigurations.ThisAir = setup {
      };
    };
}
