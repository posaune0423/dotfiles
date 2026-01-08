{
  description = "macOS dotfiles managed by nix-darwin + home-manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, ... }:
    let
      system = "aarch64-darwin";
      username = "asumayamada";

      # Flake output key for nix-darwin.
      # You can rename this to match `scutil --get HostName` later.
      host = "mac";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      mkApp = name: script:
        {
          type = "app";
          program = "${pkgs.writeShellScriptBin name script}/bin/${name}";
        };
    in
    {
      darwinConfigurations.${host} = darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit inputs self system username host; };
        modules = [
          ./nix/darwin/default.nix

          home-manager.darwinModules.home-manager
          {
            nixpkgs.pkgs = pkgs;

            users.users.${username}.home = "/Users/${username}";

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs self system username host; };
            home-manager.users.${username} = import ./nix/home/default.nix;
          }
        ];
      };

      apps.${system} = {
        switch = mkApp "switch" ''
          set -euo pipefail
          sudo nix run nix-darwin -- switch --flake ".#${host}"
        '';

        build = mkApp "build" ''
          set -euo pipefail
          nix build ".#darwinConfigurations.${host}.system"
        '';

        check = mkApp "check" ''
          set -euo pipefail
          nix flake check
        '';

        update = mkApp "update" ''
          set -euo pipefail
          nix flake update
        '';
      };

      formatter.${system} = pkgs.nixfmt;
    };
}

