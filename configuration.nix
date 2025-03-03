{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "home"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;
 
  # BLUETOOTH

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  # STUPID ELECTRON

  nixpkgs.config.permittedInsecurePackages = [ "electron-25.9.0" ];
  
  # SWAP
  
  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 4*1024;
  } ];

  # DEV

  programs.direnv.enable = true;

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];

  # GVFS AND THUNAR

  services.gvfs.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
  ];

  # SOUND --------------!

  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  hardware.pulseaudio.enable = false;

  # VDAGENT
  systemd.user.services.spice-agent = { 
    enable = true;
  };

  # OPENTABLET
  hardware.opentabletdriver.daemon.enable = true;
  hardware.opentabletdriver.enable = true;

  # NVIDIA BULLSHIT ---------------!
  
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_390;
  hardware.nvidia.nvidiaPersistenced = true;
 
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  services.xserver.videoDrivers = ["nvidia"];
  
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
  };
  hardware.nvidia.prime = {
    sync.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # HYPRLAND ----------------!

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };    
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk];

  # I3    ----------------!
  services.xserver = {
    enable = true;
    excludePackages = [ pkgs.xterm ];
  };
  services.xserver.autorun = false;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
     ];
    };
  programs.dconf.enable = true;

  # ENABLE FLAKES ---------------!

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ENABLE MOUNTING NTFS FOR THE WINDOWS PARTITION

  boot.supportedFilesystems = [ "ntfs" ];
  boot.initrd.kernelModules = [ "usbhid" "joydev" "xpad" ];

  # VMS  
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Kyiv";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "uk_UA.UTF-8";
    LC_IDENTIFICATION = "uk_UA.UTF-8";
    LC_MEASUREMENT = "uk_UA.UTF-8";
    LC_MONETARY = "uk_UA.UTF-8";
    LC_NAME = "uk_UA.UTF-8";
    LC_NUMERIC = "uk_UA.UTF-8";
    LC_PAPER = "uk_UA.UTF-8";
    LC_TELEPHONE = "uk_UA.UTF-8";
    LC_TIME = "uk_UA.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us, ua";
    xkbVariant = "grp:win_alt_toggle";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nixhop = {
    isNormalUser = true;
    description = "grasshopper";
    extraGroups = [ "networkmanager" "wheel" "video" "libvirtd" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;

  # PRINTING
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.epsonscan2 ];

  services.printing.browsing = true;
  services.printing.browsedConf = ''
  BrowseDNSSDSubTypes _cups,_print
  BrowseLocalProtocols all
  BrowseRemoteProtocols all
  CreateIPPPrinterQueues All

  BrowseProtocols all
      '';
  services.avahi = {
    enable = true;
    nssmdns = true;
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    steam
    firefox
    krita
    git
    waybar
    alsa-utils
    fastfetch
    htop
    dunst
    libnotify
    swww
    libreoffice
    rofi-wayland
    pciutils
    kitty
    glxinfo
    grim
    slurp
    swappy
    pavucontrol
    xfce.thunar
    font-manager
    vscode
    reaper
    audacity
    qjackctl
    clipman
    cava
    obs-studio
    zip
    unzip
    vlc
    nwg-look
    xorg.xinit
    libinput
    gvfs
    acpi
    picom
    xfce.thunar-archive-plugin
    patchelf_0_13
    steam-run
    home-manager
    sox
    numix-icon-theme
    appimage-run
    r2modman
    prismlauncher
    wayland
    obsidian
    spice-vdagent
    xfce.thunar-archive-plugin
    jp2a
    blender
    gtk-engine-murrine
    flameshot
    polybar
    arandr
#    opentabletdriver
    xorg.xinit
    feh
    spicetify-cli 
    spotify
    # ALL OF THE LINUX BUILDING DEPENDS
    bzip2
    ncurses
    flex
    bison
    bc
    libelf
    openssl
    xz
    autoconf
    libgcc
    gnumake
    libtool
    libpng
    freetype
    virt-manager
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects
    sassc
    libsForQt5.qt5ct
    libsForQt5.bluedevil
    libsForQt5.kdenlive
    lxqt.qps
    libguestfs-with-appliance
    dotnet-sdk_8
    imhex
    gperftools
    system-config-printer
    speedcrunch
    blueberry
    # WINE
    wineWowPackages.stable
    bottles
    winetricks
    otpclient
    lutris
    drumgizmo
    guitarix
    gxplugins-lv2
    godot3
    (pkgs.discord.override { withVencord = true; })
    ventoy-full
    (ventoy.override {
      defaultGuiType = "gtk3";
      withGtk3 = true;
     })
   ];
  nixpkgs.config.packageOverrides = pkgs: {
    xfce = pkgs.xfce // {
      gvfs = pkgs.gvfs;
    };
  };
 
 # FONTS
  fonts.packages = with pkgs; [
    font-awesome
  ];
	
  # QT
  environment.variables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };  

  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
