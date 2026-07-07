{ config, lib, pkgs, ... }:

let
  cfg = config.hardware.aic8800d80;
in {
  options.hardware.aic8800d80 = {
    enable = lib.mkEnableOption "AIC8800D80 USB Wi-Fi/Bluetooth adapter support";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage ./package.nix {
        kernel = config.boot.kernelPackages.kernel;
        utilLinux = pkgs.util-linux;
      };
      defaultText = lib.literalExpression "pkgs.callPackage ./nix/package.nix { kernel = config.boot.kernelPackages.kernel; utilLinux = pkgs.util-linux; }";
      description = "Package providing the AIC8800D80 kernel modules, firmware, udev rules, and usb_modeswitch data.";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.extraModulePackages = [ cfg.package ];
    boot.kernelModules = [ "aic_load_fw" "aic8800_fdrv" "btusb" ];

    hardware.firmware = [ cfg.package ];
    services.udev.packages = [ cfg.package ];

    hardware.bluetooth.enable = lib.mkDefault true;

    environment.etc."usb_modeswitch.d/1111:1111".source = "${cfg.package}/etc/usb_modeswitch.d/1111:1111";
    environment.systemPackages = [ pkgs.usb-modeswitch ];
  };
}
