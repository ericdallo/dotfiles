{ ... }:

let
  personalNote = "00ffffffffffff0006af3d3800000000001a0104951f1178028d15a156529d280a505400000001010101010101010101010101010101143780b87038244010103e0035ae100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231343048414e30332e38200a003d";
  workNote = "00ffffffffffff004d1053140000000028190104a52313780ede50a3544c99260f5054000000010101010101010101010101010101011a3680a070381f40302035005ac210000018000000000000000000000000000000000000000000fe00313230334d814c513135364d31000000000002410328001200000a010a2020004a";
  workMonitor = "00ffffffffffff0010ac69d04c464a30081a0103803c2278ee4455a9554d9d260f5054a54b00b300d100714fa9408180778001010101565e00a0a0a029503020350055502100001a000000ff00483759434336324f304a464c0a000000fc0044454c4c205532373135480a20000000fd0038561e711e000a20202020202001b6020322f14f1005040302071601141f1213202122230907078301000065030c002000023a801871382d40582c250055502100001e011d8018711c1620582c250055502100009e011d007251d01e206e28550055502100001e8c0ad08a20e02d10103e9600555021000018483f00ca808030401a50130055502100001e00000084";
  homeMonitor = "";
  homeTv = "";
  baseConfig = {
    eDP-1 = {
      enable = true;
      primary = true;
      crtc = 0;
      mode = "1920x1080";
      position = "0x0";
      rate = "60.05";
    };
    # DP1 = {
    #   enable = true;
    #   crtc = 0;
    #   mode = "1920x1080";
    #   position = "1x1";
    #   rate = "60.00";
    # };
    HDMI-1 = {
      enable = true;
      crtc = 0;
      mode = "1920x1080";
      position = "1x1";
      rate = "60.00";
    };
    # DP2 = {
    #   enable = true;
    #   crtc = 0;
    #   mode = "1920x1080i";
    #   position = "1x1";
    #   rate = "60.00";
    # };
  };
in {
  programs.autorandr = {
    enable = true;
    profiles = {
      # "personal-home-tv" = {
      #   fingerprint = {
      #     eDP-1 = personalNote;
      #     DP1 = homeTv;
      #     DP2 = homeTv;
      #   };
      #   config = baseConfig;
      # };
      "nubank-notebook" = {
        fingerprint = {
          eDP-1 = workNote;
        };
        config = baseConfig;
      };
      "nubank-monitor" = {
        fingerprint = {
          eDP-1 = workNote;
          HDMI-1 = workMonitor;
        };
        config = baseConfig;
      };
    };
  };
}
