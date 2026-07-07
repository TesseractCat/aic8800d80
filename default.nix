{ pkgs ? import <nixpkgs> {}, kernel ? pkgs.linuxPackages.kernel }:

pkgs.callPackage ./nix/package.nix {
  inherit kernel;
  utilLinux = pkgs.util-linux;
  usbModeswitch = pkgs.usb-modeswitch;
}
