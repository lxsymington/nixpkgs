{ config, lib, pkgs, ... }: {
  user.name = "lxs";
  hm = { imports = [ ./home-manager/lxs-work.nix ]; };
}
