{ config, lib, pkgs, ... }:
let
  llvmPkgs = pkgs.llvmPackages_22;
  c        = config.lib.stylix.colors.withHashtag;
  cursor   = config.stylix.cursor;

  fillModeMap = {
    stretch = "stretch";
    fill    = "crop";
    fit     = "fit";
    center  = "center";
    tile    = "repeat";
  };
in
{
  imports = [
    ./hardware-configuration.nix
    ./specialisations.nix
  ];

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.age.keyFile     = "/home/ShoweryCellar34/.config/sops/age/keys.txt";

  sops.secrets."wireguard/surfshark_private_key"  = {};
  sops.secrets."wireguard/proton_usa_private_key" = {};

  sops.templates."wireguard-nm.env" = {
    owner = "root";
    mode  = "0400";

    content = ''
      SURFSHARK_VPN_PRIVATE_KEY=${config.sops.placeholder."wireguard/surfshark_private_key"}
      PROTON_USA_VPN_PRIVATE_KEY=${config.sops.placeholder."wireguard/proton_usa_private_key"}
    '';
  };

  environment.systemPackages = with pkgs; [
    fastfetch
    wget
    btop
    sops
    age
    ssh-to-age
    git
    ntfs3g
    noctalia-greeter
  ];

  programs = {
    dconf.enable               = true;
    xfconf.enable              = true;
    direnv.enable              = true;
    nix-ld.enable              = true;
    gamemode.enable            = true;
    gpu-screen-recorder.enable = true;

    ccache = {
      enable   = true;
      cacheDir = "/var/cache/ccache";

      packageNames = [
        "hello" # just here to trigger the ccacheWrapper overlay
      ];
    };

    hyprland = {
      enable   = true;
      withUWSM = true;
    };

    thunar = {
      enable = true;

      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-media-tags-plugin
      ];
    };

    steam = {
      enable                       = true;
      remotePlay.openFirewall      = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable      = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  hardware = {
    graphics = {
      enable      = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        intel-media-driver
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    };

    nvidia = {
      modesetting.enable          = true;
      open                        = true;
      nvidiaSettings              = true;
      package                     = config.boot.kernelPackages.nvidiaPackages.stable;

      powerManagement = {
        enable      = true;
        finegrained = true;
      };

      prime = {
        offload = {
          enable           = true;
          enableOffloadCmd = true;
        };
        intelBusId  = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    bluetooth = {
      enable      = true;
      powerOnBoot = true;
    };
  };

  boot = {
    plymouth.enable  = true;
    enableContainers = true;
    kernelPackages   = pkgs.linuxPackages_zen;

    extraModulePackages = [
      config.boot.kernelPackages.msi-ec
    ];
    kernelModules = [
      "ec_sys"
      "msi-ec"
      "ntsync"
    ];
    kernelParams = [
      "ec_sys.write_support=1"
      "splash"
      "quiet"
    ];
    kernel.sysctl = {
      "kernel.sched_cfs_bandwidth_slice_us" = 3000;
      "net.ipv4.tcp_fin_timeout"            = 5;
      "kernel.split_lock_mitigate"          = 0;
      "vm.max_map_count"                    = 2147483642;
    };

    # Use the GRUB EFI boot loader.
    loader = {
      efi.canTouchEfiVariables = true;
      timeout                  = 5;

      limine = {
        enable         = true;
        efiSupport     = true;
        maxGenerations = 5;
      };
    };
  };

  # System Services
  services = {
    power-profiles-daemon.enable  = true;
    gnome.gnome-keyring.enable    = true;
    udisks2.enable                = true;
    gvfs.enable                   = true;
    tumbler.enable                = true;
    teamviewer.enable             = true;

    udev.extraRules = ''
      KERNEL=="ntsync", MODE="0660", TAG+="uaccess"
    '';

    upower = {
      enable              = true;
      percentageLow       = 20;
      percentageCritical  = 10;
      percentageAction    = 5;
      criticalPowerAction = "Hibernate";
    };

    logind.settings.Login = {
      HandleLidSwitch = "lock";
      HandlePowerKey  = "poweroff";
    };

    xserver.videoDrivers = [
      "modesetting"
      "nvidia"
    ];

    printing = {
      enable          = true;
      cups-pdf.enable = true;
      openFirewall    = true;

      drivers = with pkgs; [
        cups-filters
        gutenprint
        gutenprintBin
        hplip
        hplipWithPlugin
        brlaser
        splix
        samsung-unified-linux-driver
        postscript-lexmark
        cnijfilter2
      ];
    };

    pipewire = {
      enable            = true;
      alsa.enable       = true;
      alsa.support32Bit = true;
      jack.enable       = true;
      pulse.enable      = true;

      extraConfig = {
        pipewire."99-lowlatency" = {
          "context.properties"."default.clock.min-quantum" = 64;
          "context.modules" = [{
            name = "libpipewire-module-rt";

            flags = [
              "ifexists"
              "nofail"
            ];
            args = {
              "nice.level"   = -15;
              "rt.prio"      = 88;
              "rt.time.soft" = 200000;
              "rt.time.hard" = 200000;
            };
          }];
        };
        pipewire-pulse."99-lowlatency"."pulse.properties" = {
          "pulse.min.req"     = "64/48000";
          "pulse.min.quantum" = "64/48000";
          "pulse.min.frag"    = "64/48000";

          "server.address" = [
            "unix:native"
          ];
        };
        client."99-lowlatency"."stream.properties" = {
          "node.latency"     = "64/48000";
          "resample.quality" = 1;
        };
      };
    };

    avahi = {
      enable       = true;
      nssmdns4     = true;
      openFirewall = true;

      publish = {
        enable       = true;
        userServices = true;
      };
    };

    openssh = {
      enable = true;

      settings = {
        PasswordAuthentication       = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin              = "no";
      };
    };

    displayManager.noctalia-greeter = {
      enable = true;

      settings = {
        appearance = {
          scheme      = "Synced";
          theme_mode  = if config.stylix.polarity == "dark" then "dark" else "light";
          font_family = config.stylix.fonts.sansSerif.name;

          palette = {
            primary            = c.base0D;
            on_primary         = c.base00;
            secondary          = c.base0E;
            on_secondary       = c.base00;
            tertiary           = c.base0C;
            on_tertiary        = c.base00;
            error              = c.base08;
            on_error           = c.base00;
            surface            = c.base00;
            on_surface         = c.base05;
            surface_variant    = c.base01;
            on_surface_variant = c.base04;
            outline            = c.base03;
            shadow             = c.base00;
            hover              = c.base0C;
            on_hover           = c.base00;
          };

          wallpaper = {
            path      = toString config.stylix.image;
            fill_mode = fillModeMap.${config.stylix.imageScalingMode};
          };
        };

        keyboard = {
          layout = config.services.xserver.xkb.layout or "us";
        };

        cursor = {
          theme = cursor.name;
          size = cursor.size;
          path = "${cursor.package}/share/icons";
        };
      };
    };
  };

  # Security Settings
  security = {
    rtkit.enable = true;

    pam = {
      services.greetd.enableGnomeKeyring = true;
    };

    polkit = {
      enable              = true;
      enablePkexecWrapper = true;
    };
  };

  users.users.ShoweryCellar34 = {
    isNormalUser = true;

    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    packages = with pkgs; [
      brightnessctl
      playerctl
      kdePackages.ark
      gamescope
      mangohud
      whatsapp-electron
      vlc
      ristretto
      mousepad
      qbittorrent
      tor-browser
    ];
  };

  # Network Settings
  networking = {
    hostName = "MSI-Katana-15-B13V-NixOS";

    networkmanager = {
      enable = true;

      ensureProfiles = {
        environmentFiles = [ config.sops.templates."wireguard-nm.env".path ];

        profiles = {
          surfshark-auckland = {
            connection = {
              id                   = "Surfshark Auckland";
              type                 = "wireguard";
              interface-name       = "wg-vpn";
              autoconnect          = false;
            };
            wireguard = {
              private-key = "$SURFSHARK_VPN_PRIVATE_KEY";
            };
            "wireguard-peer.xv8P19y0m9ojrLelCaPzGtaVv7tlPzLgZxvAD7lpYDg=" = {
              endpoint             = "nz-akl.prod.surfshark.com:51820";
              allowed-ips          = "0.0.0.0/0;";
              persistent-keepalive = "25";
            };
            ipv4 = {
              method        = "manual";
              address1      = "10.14.0.2/16";
              dns           = "162.252.172.57;149.154.159.92";
              never-default = false;
            };
            ipv6.method = "disabled";
          };
          surfshark-san-francisco = {
            connection = {
              id                   = "Surfshark San Francisco";
              type                 = "wireguard";
              interface-name       = "wg-vpn";
              autoconnect          = false;
            };
            wireguard = {
              private-key = "$SURFSHARK_VPN_PRIVATE_KEY";
            };
            "wireguard-peer.7SpGSSI78hf8jy689ec5Ql0/Gsq0LLHDmjEFsGUWl1k=" = {
              endpoint             = "us-sfo.prod.surfshark.com:51820";
              allowed-ips          = "0.0.0.0/0";
              persistent-keepalive = "25";
            };
            ipv4 = {
              method        = "manual";
              address1      = "10.14.0.2/16";
              dns           = "162.252.172.57;149.154.159.92";
              never-default = false;
            };
            ipv6.method = "disabled";
          };
          surfshark-sydney = {
            connection = {
              id                   = "Surfshark Sydney";
              type                 = "wireguard";
              interface-name       = "wg-vpn";
              autoconnect          = false;
            };
            wireguard = {
              private-key = "$SURFSHARK_VPN_PRIVATE_KEY";
            };
            "wireguard-peer.Y5KM9kHdM0upMsIJWUQquOY1RgkWX69AHw/Dl5KyIk4=" = {
              endpoint             = "au-syd.prod.surfshark.com:51820";
              allowed-ips          = "0.0.0.0/0";
              persistent-keepalive = "25";
            };
            ipv4 = {
              method        = "manual";
              address1      = "10.14.0.2/16";
              dns           = "162.252.172.57;149.154.159.92";
              never-default = false;
            };
            ipv6.method = "disabled";
          };

          proton-usa-ipv4-endpoint = {
            connection = {
              id                   = "Proton USA (IPv4)";
              type                 = "wireguard";
              interface-name       = "wg-vpn";
              autoconnect          = false;
            };
            wireguard = {
              private-key = "$PROTON_USA_VPN_PRIVATE_KEY";
            };
            "wireguard-peer.gucaLaM/mgJQbHVvnZNtW+1L4Mi7E2mtTMrhS0K4miU=" = {
              endpoint             = "146.70.230.146:51820";
              allowed-ips          = "0.0.0.0/0;::/0";
              persistent-keepalive = "25";
            };
            ipv4 = {
              method        = "manual";
              address1      = "10.2.0.2/32";
              dns           = "10.2.0.1";
              never-default = false;
            };
            ipv6 = {
              method        = "manual";
              address1      = "2a07:b944::2:2/128";
              dns           = "2a07:b944::2:1";
              never-default = false;
            };
          };
          proton-usa-ipv6-endpoint = {
            connection = {
              id                   = "Proton USA (IPv6)";
              type                 = "wireguard";
              interface-name       = "wg-vpn";
              autoconnect          = false;
            };
            wireguard = {
              private-key = "$PROTON_USA_VPN_PRIVATE_KEY";
            };
            "wireguard-peer.gucaLaM/mgJQbHVvnZNtW+1L4Mi7E2mtTMrhS0K4miU=" = {
              endpoint             = "[2a0d:5600:4f:23::10]:51820";
              allowed-ips          = "0.0.0.0/0;::/0";
              persistent-keepalive = "25";
            };
            ipv4 = {
              method        = "manual";
              address1      = "10.2.0.2/32";
              dns           = "10.2.0.1";
              never-default = false;
            };
            ipv6 = {
              method        = "manual";
              address1      = "2a07:b944::2:2/128";
              dns           = "2a07:b944::2:1";
              never-default = false;
            };
          };
        };
      };
    };

    firewall = {
      enable           = true;
      checkReversePath = "loose";

      trustedInterfaces = [
        "lo"
      ];
      allowedTCPPorts = [
      ];
      allowedUDPPorts = [
      ];
    };
  };

  stylix = {
    enable       = true;
    polarity     = "dark";    
    base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";
    image        = ./dark-background.png;

    icons = {
      enable  = true;
      package = pkgs.papirus-icon-theme;
      dark    = "Papirus-Dark";
      light   = "Papirus-Light";
    };

    cursor = {
      package = pkgs.phinger-cursors;
      name    = "phinger-cursors-light";
      size    = 24;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name    = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name    = "DejaVu Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name    = "DejaVu Serif";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name    = "Noto Color Emoji";
      };
      sizes = {
        applications = 14;
        terminal     = 8;
        desktop      = 10;
        popups       = 10;
      };
    };
  };

  time.timeZone = "Pacific/Auckland";

  i18n = {
    defaultLocale = "en_NZ.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS        = "en_NZ.UTF-8";
      LC_IDENTIFICATION = "en_NZ.UTF-8";
      LC_MEASUREMENT    = "en_NZ.UTF-8";
      LC_MONETARY       = "en_NZ.UTF-8";
      LC_NAME           = "en_NZ.UTF-8";
      LC_NUMERIC        = "en_NZ.UTF-8";
      LC_PAPER          = "en_NZ.UTF-8";
      LC_TELEPHONE      = "en_NZ.UTF-8";
      LC_TIME           = "en_NZ.UTF-8";
    };
  };

  xdg.portal = {
    enable = true;

    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      # xdg-desktop-portal-hyprland is pulled in automatically by programs.hyprland
    ];
    config.common.default = [
      "hyprland"
      "gtk"
    ];
  };

  nix.settings = {
    auto-optimise-store = true;

    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      "@wheel"
    ];
    extra-sandbox-paths = [
      config.programs.ccache.cacheDir
    ];
  };

  system.stateVersion = "26.05";
}
