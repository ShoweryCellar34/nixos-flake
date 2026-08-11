{ config, pkgs, lib, ... }:
let
  c = config.lib.stylix.colors;
  f = config.stylix.fonts;
in
{
  home.username      = "ShoweryCellar34";
  home.homeDirectory = "/home/ShoweryCellar34";
  home.stateVersion  = "26.05";

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.age.keyFile     = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

  sops.secrets."ssh/public".path = "${config.home.homeDirectory}/.ssh/authorized_keys";
  sops.secrets.git_identity      = {};

  home.packages = with pkgs; [
    neovim
    libnotify
    spotify

    grim
    slurp
    swappy
    wl-clipboard
    cliphist

    hyprshutdown
    hyprpwcenter

    networkmanagerapplet
    udiskie
  ];

  imports = [
    ./rclone.nix
    ./stylix-lua.nix
    ./ashell.nix
    ./firefox.nix
  ];

  wayland.windowManager.hyprland = {
    enable         = true;
    systemd.enable = false;

    extraLuaFiles = {
      "myConfig.lua" = { content = ./hypr/myConfig.lua; };
    };
  };

  programs = {
    hyprlock.enable          = true;
    alacritty.enable         = true;
    rofi.enable              = true;
    discord.enable           = true;

    git = {
      enable                      = true;
      settings.init.defaultBranch = "main";

      includes = [
        { path = config.sops.secrets.git_identity.path; }
      ];
    };

    gh = {
      enable                     = true;
      gitCredentialHelper.enable = true; 

      settings = {
        git_protocol = "ssh";
      };
    };

    keepassxc = {
      enable = true;

      settings = {
        General = {
          BackupBeforeSave = true;
          UseAtomicSaves   = true;
        };
        Browser = {
          CustomProxyLocation = "";
          Enabled             = true;
        };
        GUI = {
          MinimizeToTray     = true;
          ShowTrayIcon       = true;
          TrayIconAppearance = "colorful";
        };
        PasswordGenerator = {
          AdditionalChars = "";
          AdvancedMode    = true;
          Braces          = true;
          Dashes          = true;
          ExcludedChars   = "";
          Length          = 32;
          Logograms       = true;
          Math            = true;
          Punctuation     = true;
          Quotes          = true;
        };
        SSHAgent = {
         Enabled = true;
        };
        Security = {
          ClearSearch                    = true;
          HideTotpPreviewPanel           = true;
          IconDownloadFallback           = true;
          LockDatabaseIdle               = true;
          LockDatabaseIdleSeconds        = 300;
          LockDatabaseMinimize           = false;
          LockDatabaseScreenLock         = true;
          NoConfirmMoveEntryToRecycleBin = false;
          Security_HideNotes             = true;
        };
      };
    };

    vscode = {
      enable = true;

      argvSettings = {
        password-store = "gnome-libsecret";
      };
    };
  };

  stylix.targets.vscode.enable = false;

  services = {
    hyprpolkitagent.enable        = true;
    hyprpaper.enable              = true;
    hyprlauncher.enable           = true;
    network-manager-applet.enable = true;
    remmina.enable                = true;

    wayvnc = {
      enable    = true;
      autoStart = true;

      settings = {
        address = "127.0.0.1";
        port    = 5900;
      };
    };

    udiskie = {
      enable    = true;
      automount = true;
      notify    = true;
      tray      = "always";
    };

    gnome-keyring = {
      enable = true;

      components = [
        "pkcs11"
        "secrets"
        "ssh"
      ];
    };

    cliphist = {
      enable         = true;
      allowImages    = true; 
      systemdTargets = [ "graphical-session.target" ]; 
    };

    hypridle = {
      enable = true;

      settings = {
        general = {
          lock_cmd         = "pidof hyprlock || hyprlock --no-fade-in";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd  = "hyprctl dispatch dpms on;";
        };
        listener = [{
            timeout    = 900;
            on-timeout = "loginctl lock-session";
        }];
      };
    };

    kanshi = {
      enable = true;

      settings = [
        {
          profile.name = "default";

          profile.outputs = [
            { criteria = "eDP-1"; }
          ];
        }
      ];
    };
  };

  systemd.user.services = {
    restart-applets = {
      Unit = {
        Description = "Restarts applets that are sometimes be missed by AShell during startup";

        After = [ "ashell.service" ];
        PartOf = [ "ashell.service" ];
      };
      Install = {
        WantedBy = [ "ashell.service" ];
      };
      Service = {
        Type         = "oneshot";
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
        ExecStart    = "${pkgs.systemd}/bin/systemctl --user restart network-manager-applet.service udiskie.service";
      };
    };
  };

  home.sessionVariables.SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/keyring/ssh";

  xdg.configFile."uwsm/env".text = ''
    export NIXOS_OZONE_WL=1
    export MOZ_ENABLE_WAYLAND=1
    export QT_QPA_PLATFORM=wayland
  '';

  xdg.configFile."hypr/hyprtoolkit.conf".text = ''
    background     = 0xFF${c.base00}
    base           = 0xFF${c.base00}
    alternate_base = 0xFF${c.base01}

    text        = 0xFF${c.base05}
    bright_text = 0xFF${c.base07}

    accent           = 0xFF${c.base0D}
    accent_secondary = 0xFF${c.base0B}

    font_size = ${toString f.sizes.applications}
    h1_size   = ${toString (f.sizes.applications + 8)}
    h2_size   = ${toString (f.sizes.applications + 4)}
    h3_size   = ${toString (f.sizes.applications + 2)}
  '';
}
