{ lib, ... }:
{
  imports = [
    ../../../modules/disko
  ];

  disko.enable = true;
  disko.devices.disk.disk1.device = lib.mkOverride "/dev/vda";
    # disko.devices.disk.disk1.imageSize = "20G";
}
