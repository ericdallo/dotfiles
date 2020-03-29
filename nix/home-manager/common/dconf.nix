{
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options = [
        "terminate:ctrl_alt_bksp"
        "ctrl:swapcaps"
      ];
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;

      enabled-extensions = [
        "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
        "hibernate-status@dromi"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "terminal";
      command = "urxvt";
      binding = "<Alt>t";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "lock";
      command = "i3lock-fancy -f Roboto-Medium";
      binding = "<Alt>l";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      name = "nautilius";
      command = "nautilus";
      binding = "<Alt>q";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      name = "swith-workspace";
      command = "bash -c \"~/.dotfiles/scripts/alternate-desktop.sh\"";
      binding = "<Alt>backslash";
    };
  };
}
