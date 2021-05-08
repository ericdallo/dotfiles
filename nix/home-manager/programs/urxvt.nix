{ config, lib, pkgs, ... }:

{
  programs.urxvt = {
    enable = true;
    scroll.lines = 20000;
    package = pkgs.urxvt_font_size;

    iso14755 = false;

    keybindings = {
      "Control-Shift-Up" = "font-size:increase";
      "Control-Shift-Down" = "font-size:decrease";
      "F11" = "perl:fullscreen:switch";
      "Shift-Control-C" = "perl:clipboard:copy";
      "Shift-Control-V" = "perl:clipboard:paste";
      "M-e" = "perl:keyboard-select:activate";
      "M-s" = "perl:keyboard-select:search";
      "M-u" = "perl:url-select:select_next";
      "C-Delete" = "matcher:last";
    };

    fonts = [
      "xft:Hack:size=12:antialias=true"
      "xft:Material Design Icons:size=14:minspace=false"
    ];

    extraConfig = {
      "allow_bold" = true;
      "letterSpace" = 0;
      "lineSpace" = 0;
      "geometry" = "180x180";
      "internalBorder" = 8;
      "cursorBlink" = true;
      "cursorUnderline" = false;
      "scrollBar" = false;
      "scrollBar_right" = false;
      "urgentOnBell" = true;
      "depth" = 24;

      "perl-ext-common" =
        "default,matcher,clipboard,keyboard-select,font-size,fullscreen";
      "clipboard.autocopy" = "true";
      "url-launcher" = "google-chrome-stable";
      "matcher.button" = "1";
      "matcher.pattern.1" = "\\bwww\\.[\\w-]+\\.[\\w./?&@#-]*[\\w/-]";
      "matcher.pattern.2" = "\\B(/\\S+?):(\\d+)(?=:|$)";

    };
  };

  xresources.properties = {
    "URxvt*boldFont" = [
      "xft:Hack:bold:size=12:antialias=true"
      "xft:Material Design Icons:size=14:minspace=false"
    ];
    "URxvt*italicFont" = [
      "xft:Hack:italic:size=12:antialias=true"
      "xft:Material Design Icons:size=14:minspace=false"
    ];
    "URxvt*boldItalicFont" = [
      "xft:Hack:bold:italic:size=12:antialias=true"
      "xft:Material Design Icons:size=14:minspace=false"
    ];

    # Dracula Xresources palette
    "*.foreground" = "#F8F8F2";
    "*.background" = "#282A36";
    "*.color0" = "#000000";
    "*.color8" = "#4D4D4D";
    "*.color1" = "#FF5555";
    "*.color9" = "#FF6E67";
    "*.color2" = "#50FA7B";
    "*.color10" = "#5AF78E";
    "*.color3" = "#F1FA8C";
    "*.color11" = "#F4F99D";
    "*.color4" = "#BD93F9";
    "*.color12" = "#CAA9FA";
    "*.color5" = "#FF79C6";
    "*.color13" = "#FF92D0";
    "*.color6" = "#8BE9FD";
    "*.color14" = "#9AEDFE";
    "*.color7" = "#BFBFBF";
    "*.color15" = "#E6E6E6";
  };
}
