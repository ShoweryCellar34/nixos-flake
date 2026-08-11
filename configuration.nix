{ config, lib, pkgs, ... }:
let
  llvmPkgs = pkgs.llvmPackages_22;
in
{
  imports = [
      ./hardware-configuration.nix
      ./specialisations.nix
  ];

  environment.systemPackages = with pkgs; [
    fastfetch
    wget
    btop
    sops
    age
    ssh-to-age

    brightnessctl
    playerctl
    kdePackages.ark
    gamescope
    whatsapp-electron
    vlc
    ristretto
    mousepad
  ];

  programs = {
    dconf.enable  = true;
    xfconf.enable = true;
    direnv.enable = true;
    nix-ld.enable = true;

    bash = {
      enable = true;

      promptInit = ''
        export PS1='\[\e[38;5;201m\]$?\[\e[0m\] \[\e[38;5;64m\][\[\e[38;5;214m\]\D{%d/%m/%G}\[\e[0m\] \[\e[38;5;208m\]\t\[\e[0m\] \[\e[38;5;69m\]\u\[\e[38;5;141m\]@\[\e[38;5;63m\]\h\[\e[0m\] \[\e[38;5;196m\]\w\[\e[38;5;64m\]]\$\[\e[0m\] '
        # AI slop code
        _newline_if_needed() {
            local pos
            exec < /dev/tty
            local oldstty
            oldstty=$(stty -g)
            stty raw -echo min 0
            echo -en "\033[6n" > /dev/tty
            read -sdR pos
            stty "$oldstty"
            pos=''${pos#*[}
            local col=''${pos##*;}
            [ "$col" != "1" ] && echo
        }
        PROMPT_COMMAND="_newline_if_needed''${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
      '';

      shellAliases = {
        nrs = "sudo nixos-rebuild boot --flake . && sudo /nix/var/nix/profiles/system/\${NIXOS_SPECIALISATION:+specialisation/\${NIXOS_SPECIALISATION}/}bin/switch-to-configuration test";
      };
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
    };
  };

  nixpkgs.config.allowUnfree = true;

  hardware = {
    graphics = {
      enable      = true;
      enable32Bit = true;
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
    plymouth.enable = true;

    extraModulePackages = [
      config.boot.kernelPackages.msi-ec
    ];
    kernelModules = [
      "ec_sys"
      "msi-ec"
    ];
    kernelParams = [
      "ec_sys.write_support=1"
      "splash"
      "quiet"
    ];

    kernelPackages = pkgs.linuxPackages_zen;

    # Use the GRUB EFI boot loader.
    loader = {
      efi.canTouchEfiVariables = true;
      timeout                  = 5;

      limine = {
        enable     = true;
        efiSupport = true;
      };
    };
  };

  # System Services
  services = {
    power-profiles-daemon.enable  = true;
    displayManager.regreet.enable = true;
    gnome.gnome-keyring.enable    = true;
    blueman.enable                = true;
    udisks2.enable                = true;
    gvfs.enable                   = true;
    tumbler.enable                = true;

    upower = {
      enable              = true;
      percentageLow       = 15;
      percentageCritical  = 5;
      percentageAction    = 3;
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
  };

  # Security Settings
  security = {
    rtkit.enable = true;

    pam = {
      services.login.enableGnomeKeyring = true;
      services.hyprlock                 = {};
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
    ]; 
  };

  # Network Settings
  networking = {
    firewall = {
      enable = true;

      trustedInterfaces = [
        "lo"
      ];
      allowedTCPPorts = [
      ];
      allowedUDPPorts = [
      ];
    };

    hostName              = "MSI-Katana-15-B13V-NixOS";
    networkmanager.enable = true;
  };

  stylix = {
    enable       = true;
    polarity     = "dark";    
    base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";
    image        = ./gruvbox-dark-blue.png;

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

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "26.05";
}

