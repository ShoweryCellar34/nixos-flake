{ config, pkgs, lib, noctalia, ... }:
let
  c = config.lib.stylix.colors;
  f = config.stylix.fonts;
in
{
  home.username      = "ShoweryCellar34";
  home.homeDirectory = "/home/ShoweryCellar34";
  home.stateVersion  = "26.05";

  home.activation = {
    createFolders = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD mkdir -p $HOME/downloads
      $DRY_RUN_CMD mkdir -p $HOME/documents
      $DRY_RUN_CMD mkdir -p $HOME/pictures/screenshots
      $DRY_RUN_CMD mkdir -p $HOME/videos
    '';
  };

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.age.keyFile     = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

  sops.secrets."ssh/public".path = "${config.home.homeDirectory}/.ssh/authorized_keys";
  sops.secrets.git_identity      = {};

  home.packages = with pkgs; [
    neovim
    libnotify
    spotify
    zathura

    wl-clipboard
    cliphist
    xwayland-satellite

    hyprshutdown
    hyprpwcenter
  ];

  imports = [
    noctalia.homeModules.default
    ./rclone.nix
    ./firefox.nix
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf"        = "org.pwmt.zathura.desktop";
      "image/png"              = "ristretto.desktop";
      "image/jpeg"             = "ristretto.desktop";
      "text/plain"             = "mousepad.desktop";
      "video/mp4"              = "vlc.desktop";
      "inode/directory"        = "thunar.desktop";
      "x-scheme-handler/http"  = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };
  };

  home.file.".config/gtk-3.0/bookmarks".text = ''
    file://${config.home.homeDirectory}/downloads Downloads
    file://${config.home.homeDirectory}/documents Documents
    file://${config.home.homeDirectory}/pictures Pictures
    file://${config.home.homeDirectory}/videos Videos
    file://${config.home.homeDirectory}/Downloads Downloads
    file://${config.home.homeDirectory}/google-drive Google Drive
    file://${config.home.homeDirectory}/proton-drive Proton Drive
    file://${config.home.homeDirectory}/mega-drive MEGA Drive
  '';

  wayland.windowManager.hyprland = {
    enable                              = true;
    systemd.enable                      = false;
    extraLuaFiles."hpyrland-config.lua" = { content = ./hyprland-config.lua; };
  };

  stylix.targets.noctalia.enable = true;
  stylix.targets.vscode.enable   = false;

  programs = {
    alacritty.enable         = true;
    rofi.enable              = true;
    discord.enable           = true;
    prismlauncher.enable     = true;

    noctalia = {
      enable         = true;
      systemd.enable = true;
      settings       = lib.importTOML ./noctalia.toml;
    };

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
          MinimizeOnClose    = true;
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

  services = {
    remmina.enable = true;

    wl-clip-persist = {
      enable         = true;
      systemdTargets = [ "graphicla-session.target" ];
    };

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

  home.sessionVariables = {
    SSH_AUTH_SOCK      = "$XDG_RUNTIME_DIR/keyring/ssh";
    NIXOS_OZONE_WL     = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM    = "wayland";
  };

  xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

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
