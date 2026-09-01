{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.btop;
in
{
  meta = {
    doc = ./btop.md;
    maintainers = with lib.maintainers; [ ChaosAttractor ];
  };

  options.programs.btop = {
    enable = lib.mkEnableOption "btop with the capabilities required for process and GPU monitoring";
    package = lib.mkPackageOption pkgs "btop" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    security.wrappers.btop = {
      owner = "root";
      group = "root";
      capabilities = "cap_perfmon,cap_dac_read_search+ep";
      source = lib.getExe cfg.package;
    };
  };
}
