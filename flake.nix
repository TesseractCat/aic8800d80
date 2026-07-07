{
  description = "NixOS packaging for the AIC8800D80 out-of-tree Wi-Fi/Bluetooth driver";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in {
      packages = forAllSystems (system: let
        pkgs = import nixpkgs { inherit system; };
      in {
        default = pkgs.callPackage ./nix/package.nix {
          kernel = pkgs.linuxPackages.kernel;
          utilLinux = pkgs.util-linux;
          usbModeswitch = pkgs.usb-modeswitch;
        };
        aic8800d80 = pkgs.callPackage ./nix/package.nix {
          kernel = pkgs.linuxPackages.kernel;
          utilLinux = pkgs.util-linux;
          usbModeswitch = pkgs.usb-modeswitch;
        };
      });

      nixosModules.default = import ./nix/module.nix;
    };
}
