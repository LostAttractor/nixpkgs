{ config, pkgs, lib, ... }:
with lib;
{
  options.programs.sharing = {
    enable = mkEnableOption (lib.mdDoc ''
      sharing.

      Note that it will open the TCP 7478 as they are needed for it to function properly.
    '');
  };
  config =
    let
      cfg = config.programs.sharing;
    in
      mkIf cfg.enable {
        environment.systemPackages = [ sharing ];
        networking.firewall.allowedTCPPorts = [ 7478 ];
      };
}
