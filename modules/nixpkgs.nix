{ inputs, config, lib, pkgs, ... }:
{
  nixpkgs = { config = import ./config.nix; };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';
    settings = {
      allowed-users = [ "${config.user.name}" "root" "@admin" "@wheel" ];
      max-jobs = 8;
      trusted-users = [ "${config.user.name}" "root" "@admin" "@wheel" ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };
    readOnlyStore = true;
    nixPath = builtins.map
      (source: "${source}=/etc/${config.environment.etc.${source}.target}") [
      "home-manager"
      "nixpkgs"
      "stable"
    ];

    registry = {
      nixpkgs = {
        from = {
          id = "nixpkgs";
          type = "indirect";
        };
        flake = inputs.nixpkgs;
      };

      stable = {
        from = {
          id = "stable";
          type = "indirect";
        };
        flake = inputs.stable;
      };
    };
  };
}