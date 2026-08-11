{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    rclone
  ];

  sops.secrets."rclone/google_drive_client_id"     = {};
  sops.secrets."rclone/google_drive_client_secret" = {};

  sops.secrets."rclone/proton_drive_username"       = {};
  sops.secrets."rclone/proton_drive_password"       = {};
  sops.secrets."rclone/proton_drive_otp_secret_key" = {};

  sops.secrets."rclone/mega_drive_user" = {};
  sops.secrets."rclone/mega_drive_pass" = {};

  sops.templates."rclone-google-drive.env".content = ''
    RCLONE_CONFIG_GOOGLE_DRIVE_TYPE=drive
    RCLONE_CONFIG_GOOGLE_DRIVE_CLIENT_ID=${config.sops.placeholder."rclone/google_drive_client_id"}
    RCLONE_CONFIG_GOOGLE_DRIVE_CLIENT_SECRET=${config.sops.placeholder."rclone/google_drive_client_secret"}
    RCLONE_CONFIG_GOOGLE_DRIVE_SCOPE=drive
  '';

  sops.templates."rclone-proton-drive.env".content = ''
    RCLONE_CONFIG_PROTON_DRIVE_TYPE=protondrive
    RCLONE_CONFIG_PROTON_DRIVE_USERNAME=${config.sops.placeholder."rclone/proton_drive_username"}
    RCLONE_CONFIG_PROTON_DRIVE_PASSWORD=${config.sops.placeholder."rclone/proton_drive_password"}
    RCLONE_CONFIG_PROTON_DRIVE_OTP_SECRET_KEY=${config.sops.placeholder."rclone/proton_drive_otp_secret_key"}
  '';

  sops.templates."rclone-mega-drive.env".content = ''
    RCLONE_CONFIG_MEGA_DRIVE_TYPE=mega
    RCLONE_CONFIG_MEGA_DRIVE_USER=${config.sops.placeholder."rclone/mega_drive_user"}
    RCLONE_CONFIG_MEGA_DRIVE_PASS=${config.sops.placeholder."rclone/mega_drive_pass"}
  '';

  systemd.user.services = {
    rclone-google-drive = {
      Unit = {
        Description = "Automount Rclone Google Drive Remote";
        After       = [ "network-online.target" ];
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        Type            = "simple";
        ExecStartPre    = "${pkgs.coreutils}/bin/mkdir -p ${config.home.homeDirectory}/google-drive";
        ExecStart       = "${pkgs.rclone}/bin/rclone mount --vfs-cache-mode full google_drive: ${config.home.homeDirectory}/google-drive";
        ExecStop        = "/run/wrappers/bin/fusermount -u ${config.home.homeDirectory}/google-drive";
        Restart         = "on-failure";
        RestartSec      = 10;
        EnvironmentFile = config.sops.templates."rclone-google-drive.env".path;

        Environment = [
          "PATH=/run/wrappers/bin:$PATH"
        ];
      };
    };

    rclone-proton-drive = {
      Unit = {
        Description = "Automount Rclone Proton Drive Remote";
        After       = [ "network-online.target" ];
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        Type            = "simple";
        ExecStartPre    = "${pkgs.coreutils}/bin/mkdir -p ${config.home.homeDirectory}/proton-drive";
        ExecStart       = "${pkgs.rclone}/bin/rclone mount --vfs-cache-mode full proton_drive: ${config.home.homeDirectory}/proton-drive";
        ExecStop        = "/run/wrappers/bin/fusermount -u ${config.home.homeDirectory}/proton-drive";
        Restart         = "on-failure";
        RestartSec      = 10;
        EnvironmentFile = config.sops.templates."rclone-proton-drive.env".path;

        Environment = [
          "PATH=/run/wrappers/bin:$PATH"
        ];
      };
    };

    rclone-mega-drive = {
      Unit = {
        Description = "Automount Rclone MEGA Drive Remote";
        After       = [ "network-online.target" ];
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        Type            = "simple";
        ExecStartPre    = "${pkgs.coreutils}/bin/mkdir -p ${config.home.homeDirectory}/mega-drive";
        ExecStart       = "${pkgs.rclone}/bin/rclone mount --vfs-cache-mode full mega_drive: ${config.home.homeDirectory}/mega-drive";
        ExecStop        = "/run/wrappers/bin/fusermount -u ${config.home.homeDirectory}/mega-drive";
        Restart         = "on-failure";
        RestartSec      = 10;
        EnvironmentFile = config.sops.templates."rclone-mega-drive.env".path;

        Environment = [
          "PATH=/run/wrappers/bin:$PATH"
        ];
      };
    };
  };
}
