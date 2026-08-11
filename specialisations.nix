{ config, lib, pkgs, ... }:
{
  specialisation.light.configuration = {
    system.nixos.tags = [
      "light"
    ];

    environment.variables.NIXOS_SPECIALISATION = "light";

    stylix = {
      polarity     = lib.mkForce "light";
      base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/ayu-light.yaml";
      image        = lib.mkForce ./gruvbox-light-blue.png;

      cursor.name = lib.mkForce "phinger-cursors-dark";
    };
  };

  specialisation.sync.configuration = {
    system.nixos.tags = [
      "sync"
    ];

    environment.variables.NIXOS_SPECIALISATION = "sync";

    hardware.nvidia = {
      powerManagement = {
        enable      = lib.mkForce false;
        finegrained = lib.mkForce false;
      };

      prime = {
        sync.enable = true;

        offload = {
          enable           = lib.mkForce false;
          enableOffloadCmd = lib.mkForce false;
        };
      };
    };
  };

  specialisation.light-sync.configuration = {
    system.nixos.tags = [
      "light-sync"
    ];

    environment.variables.NIXOS_SPECIALISATION = "light-sync";

    stylix = {
      polarity     = lib.mkForce "light";
      base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/ayu-light.yaml";
      image        = lib.mkForce ./gruvbox-light-blue.png;

      cursor.name = lib.mkForce "phinger-cursors-dark";
    };

    hardware.nvidia = {
      powerManagement = {
        enable      = lib.mkForce false;
        finegrained = lib.mkForce false;
      };

      prime = {
        sync.enable = true;

        offload = {
          enable           = lib.mkForce false;
          enableOffloadCmd = lib.mkForce false;
        };
      };
    };
  };
}
