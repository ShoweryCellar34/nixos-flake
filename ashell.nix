{ pkgs, config, ... }:
{
  programs.ashell = {
    enable         = true;
    systemd.enable = true;

    settings = {
      log_level          = "warn";
      position           = "Top";
      layer              = "Top";
      outputs            = "All";
      enable_esc_key     = true;
      animations.enabled = false;

      osd = {
        enabled                    = true;
        timeout                    = 2000;
        show_volume_percentage     = true;
        show_brightness_percentage = true;
      };

      modules = {
        left   = [
          "Workspaces"
        ];
        center = [
          "Tempo"
        ];
        right  = [
          "Tray"
          "MediaPlayer"
          "SystemInfo"
          [ "Privacy" "Notifications" "Settings" ]
        ];
      };

      workspaces = {
        visibility_mode          = "All";
        enable_workspace_filling = false;
      };

      window_title = {
        mode                        = "Title";
        truncate_title_after_length = 96;
      };

      system_info = {
        interval = 1;

        indicators = [
          "Cpu"
          "Memory"
          "Temperature"
        ];

        cpu = {
          warn_threshold  = 65;
          alert_threshold = 80;
        };

        memory = {
          warn_threshold  = 70;
          alert_threshold = 85;
          format          = "Fraction";
        };

        temperature = {
          sensor = "Cpu";
        };

        disk = {
          warn_threshold  = 80;
          alert_threshold = 90;
          format          = "Fraction";
        };
      };

      tray = { };

      tempo = {
        clock_format      = "%a %d %b %T";
        weather_indicator = "None";
      };

      media_player = {
        indicator_format = "IconAndTitle";
        max_title_length = 32;
      };

      notifications = {
        toast           = true;
        toast_position  = "top_right";
        toast_timeout   = 5000;
        grouped         = false;
        show_timestamps = true;
        show_bodies     = true;
      };

      settings = {
        enable_tooltips = true;

        lock_cmd      = "loginctl lock-session";
        suspend_cmd   = "systemctl suspend";
        hibernate_cmd = "systemctl hibernate";
        reboot_cmd    = "systemctl reboot";
        logout_cmd    = "hyprshutdown";
        shutdown_cmd  = "systemctl poweroff";

        audio_sinks_more_cmd   = "hyprpwcontrol";
        audio_sources_more_cmd = "hyprpwcontrol";
        wifi_more_cmd          = "nm-connection-editor";
        vpn_more_cmd           = "nm-connection-editor";
        bluetooth_more_cmd     = "blueman-manager";

        battery_format         = "IconAndPercentage";
        battery_hide_when_full = false;

        audio_indicator_format      = "Icon";
        microphone_indicator_format = "Icon";
        network_indicator_format    = "Icon";
        bluetooth_indicator_format  = "Icon";
        brightness_indicator_format = "Icon";

        volume_step = 5;
        max_volume  = 100;

        indicators = [
          "IdleInhibitor"
          "PowerProfile"
          "Audio"
          "Microphone"
          "Bluetooth"
          "Network"
          "Vpn"
          "Battery"
          "Brightness"
        ];
      };

      appearance = {
        style        = "Solid";
        scale_factor = 1.0;
        opacity      = 1.0;

        menu = {
          opacity   = 1.0;
          backdrop = 0.0;
        };
      };
    };
  };
}
