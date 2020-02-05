with import <nixpkgs> {}; {
    devEnv = stdenv.mkDerivation {
        name = "hover-deps";
        buildInputs = [ stdenv
                        go
                        pkgconfig
                        glfw
                        glxinfo
                        xorg.libX11
                        xorg.libX11.dev
                        xorg.libX11.dev.out
                        xorg.libXcursor
                        xorg.libXrandr
                        xorg.libXinerama
                        xorg.libXxf86vm
                        xorg.libXi
                        haskellPackages.x11-xinput
                        libGLU
                        libGL];
    };
}
