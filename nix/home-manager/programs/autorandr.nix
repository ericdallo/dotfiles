{ ... }:

let
  personalNote = "00ffffffffffff0006af3d3800000000001a0104951f1178028d15a156529d280a505400000001010101010101010101010101010101143780b87038244010103e0035ae100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231343048414e30332e38200a003d";
  workNote = "";
  homeMonitor = "";
  homeTv = "";
  mickeyTv = "00ffffffffffff006318512800000100141d0103807944780a0dc9a05747982712484c2108008140a940818081c0a9c001010101010131ce0046f0705a8008208a00b9a84200001e023a801871382d40582c4500b9a84200001e000000fc004265796f6e642054560a202020000000fd00324b1e503c000a202020202020013a020358f25a5f5f5f5f5f909f051420041312110302161507060121225e5d622909070715175055170083010000e200cb6e030c001000b8442100800102030467d85dc401788807e305e301e20f00e3060f01e50e61606665023a801871382d40582c4500b9a84200001e011d007251d01e206e285500b9a84200001e00000003";
  baseConfig = {
    eDP1 = {
      enable = true;
      primary = true;
      crtc = 0;
      mode = "1920x1080";
      position = "0x0";
      rate = "60.05";
    };
    DP1 = {
      enable = true;
      crtc = 0;
      mode = "1920x1080";
      position = "1x1";
      rate = "60.00";
    };
    DP2 = {
      enable = true;
      crtc = 0;
      mode = "1920x1080i";
      position = "1x1";
      rate = "60.00";
    };
  };
in {
  programs.autorandr = {
    enable = true;
    profiles = {
      "personal-home-tv" = {
        fingerprint = {
          eDP1 = personalNote;
          DP1 = homeTv;
          DP2 = homeTv;
        };
        config = baseConfig;
      };
      "personal-mickey-tv" = {
        fingerprint = {
          eDP1 = personalNote;
          DP1 = mickeyTv;
          DP2 = mickeyTv;
        };
        config = baseConfig;
      };
    };
  };
}
