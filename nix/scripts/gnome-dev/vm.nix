{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    gnomeExtensions.draw-on-your-screen

    gnome3.gnome-tweaks
  ];

  services.openssh.enable = true;
  boot.cleanTmpDir = true;

  services.xserver = {
    enable = true;

    desktopManager = {
      gnome3.enable = true;
      gnome3.debug = true;
    };

    displayManager = {
      gdm.enable = true;
      gdm.debug = true;
    };
  };

  users.users.greg = {
    isNormalUser = true;
    uid = 1000;
    password = "123456";
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = [
      # put your machines public key here to get ssh access
    ];
  };

  system.stateVersion = "20.09";
}
