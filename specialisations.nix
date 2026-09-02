{
  config,
  lib,
  pkgs,
  ...
}:
let
  lightTheme = {
    stylix = {
      polarity = lib.mkForce "light";
      base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/ayu-light.yaml";
      image = lib.mkForce ./light-background.png;
      cursor.name = lib.mkForce "phinger-cursors-dark";
    };
  };

  nvidiaSync = {
    hardware.nvidia = {
      powerManagement.enable = lib.mkForce false;
      powerManagement.finegrained = lib.mkForce false;

      prime = {
        sync.enable = true;
        offload.enable = lib.mkForce false;
        offload.enableOffloadCmd = lib.mkForce false;
      };
    };
  };
in
{
  specialisation.light.configuration = lib.mkMerge [
    {
      system.nixos.tags = [ "light" ];
      environment.variables.NIXOS_SPECIALISATION = "light";
    }
    lightTheme
  ];

  specialisation.sync.configuration = lib.mkMerge [
    {
      system.nixos.tags = [ "sync" ];
      environment.variables.NIXOS_SPECIALISATION = "sync";
    }
    nvidiaSync
  ];

  specialisation.light-sync.configuration = lib.mkMerge [
    {
      system.nixos.tags = [ "light-sync" ];
      environment.variables.NIXOS_SPECIALISATION = "light-sync";
    }
    lightTheme
    nvidiaSync
  ];
}
