{
  config,
  pkgs,
  ...
}: {
  nixpkgs.config.permittedInsecurePackages = ["openssl-1.1.1w"];
  imports = [
    ./hardware-configuration.nix
  ];
	
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  networking.hostName = "tuckernix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.redis.servers."tbredis" = { 
    enable = true;
    port = 6379;
  };
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
  services.postgresql = {
	enable = true;
	ensureDatabases = ["chicken_tinder" ];
	authentication = pkgs.lib.mkOverride 10 ''
	  local all all              trust
	  host  all all 127.0.0.1/32 trust
	  host  all all ::1/128      trust
	  host 	all all 172.16.199.1/32 trust
	'';
	enableTCPIP = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mtuckerb = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Tucker Bradford";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      firefox
      jq
      neovim
      asdf
      openssh
      nix
      nushellFull
      ripgrep
      #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    vim
    wget
    git
    tmux
    zsh
    spice-vdagent
    openssl
    openssl.dev
    openssl_1_1
    gcc
    automake
    gnumake
    m4
    bison
    flex
    texinfo
    zlib
    zlib.dev
    xz
    xz.dev
    gmp
    gmp.dev
    libffi
    libffi.dev
    libmpc
    libxcrypt
    mpfr
    mpfr.dev
    pkg-config
    stdenv.cc
    stdenv.cc.libc
    stdenv.cc.libc_dev
    autogen
    isl
    home-manager
    cifs-utils
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:


  # For mount.cifs, required unless domain name resolution is not needed.
  fileSystems."/home/mtuckerb/Mac" = {
    device = "//172.16.199.1/mtuckerb";
    fsType = "cifs";
    options = let
      # this line prevents hanging on network split
       automount_opts = "user,users";

      in ["${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=100"];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [22 5432];
   networking.firewall.allowedUDPPorts = [ 5432 ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    nerdfonts
    proggyfonts
  ];
    programs._1password = { enable = true; };
    programs._1password-gui = { enable = true; };
#    polkitPolicyOwners = [ "mtuckerb" ];
#    virtualisation.vmware.guest.enable = true;
  programs.zsh.enable = true; 
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
# add any missing dynamic libs for unpackaged bins here
  ];
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
