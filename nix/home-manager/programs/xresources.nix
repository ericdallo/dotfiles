{ config, lib, pkgs, ... }:

{
  xresources.properties = {
    # URxvt appearance
    "URxvt.allow_bold" = true;
    "URxvt*font" = [
      "xft:Hack:size=12:antialias=true"
      "xft:Material Design"
      "Icons:size=14:minspace=false"
    ];
    "URxvt*boldFont" = [
      "xft:Hack:bold:size=12:antialias=true"
      "xft:Material Design"
      "Icons:size=14:minspace=false"
    ];
    "URxvt*italicFont" = [
      "xft:Hack:italic:size=12:antialias=true"
      "xft:Material Design"
      "Icons:size=14:minspace=false"
    ];
    "URxvt*boldItalicFont" = [
      "xft:Hack:bold:italic:size=12:antialias=true"
      "xft:Material Design"
      "Icons:size=14:minspace=false"
    ];
    "URxvt.letterSpace" = 0;
    "URxvt.lineSpace" = 0;
    "URxvt.geometry" = "180x180";
    "URxvt.internalBorder" = 8;
    "URxvt.cursorBlink" = true;
    "URxvt.cursorUnderline" = false;
    "URxvt.scrollBar" = false;
    "URxvt.scrollBar_right" = false;
    "URxvt.urgentOnBell" = true;
    "URxvt.depth" = 24;
    "URxvt.iso14755" = false;

    # Common keybindings for navigations
    "URxvt.keysym.Shift-Up" = "command:033]720;1007";
    "URxvt.keysym.Shift-Down" = "command:033]721;1007";
    "URxvt.keysym.Control-Down" = "033[1;5B";
    "URxvt.keysym.Control-Right" = "033[1;5C";
    "URxvt.keysym.Control-Left" = "033[1;5D";
    "URxvt.keysym.Control-Shift-Up" = "font-size:increase";
    "URxvt.keysym.Control-Shift-Down" = "font-size:decrease";
    "URxvt.keysym.F11" = "perl:fullscreen:switch";
    "URxvt.keysym.Shift-Control-C" = "perl:clipboard:copy";
    "URxvt.keysym.Shift-Control-V" = "perl:clipboard:paste";
    "URxvt.keysym.M-e" = "perl:keyboard-select:activate";
    "URxvt.keysym.M-s" = "perl:keyboard-select:search";
    "URxvt.keysym.M-u" = "perl:url-select:select_next";
    "URxvt.keysym.C-Delete" = "matcher:last";

    # Copy Paste & Other Extensions
    "URxvt.perl-ext-common" =
      "default,matcher,clipboard,keyboard-select,font-size,fullscreen";
    "URxvt.clipboard.autocopy" = "true";
    "URxvt.url-launcher" = "google-chrome-stable";
    "URxvt.matcher.button" = "1";
    "URxvt.matcher.pattern.1" = "\\bwww\\.[\\w-]+\\.[\\w./?&@#-]*[\\w/-]";
    "URxvt.matcher.pattern.2" = "\\B(/\\S+?):(\\d+)(?=:|$)";

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
