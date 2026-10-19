# Disk layout: what the installer formats (disko), and also this host's
# fileSystems, swap, resume device and LUKS settings.
#
#   nvme0n1p1  2G    ESP, vfat, /boot (GRUB + kernels: room for many)
#   nvme0n1p2  rest  LUKS "crypted" (one passphrase at boot) -> LVM "vg":
#                      swap  32G   as big as the RAM: hibernation
#                      root  rest  ext4, /
{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "2G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "fmask=0022" "dmask=0022" ];
            };
          };
          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypted";
              # No passwordFile/keyFile: disko asks for the passphrase while
              # formatting, and the initrd asks for it at boot.
              settings = {
                allowDiscards = true; # TRIM (services.fstrim) through LUKS
                bypassWorkqueues = true; # faster on NVMe
              };
              content = {
                type = "lvm_pv";
                vg = "vg";
              };
            };
          };
        };
      };
    };

    lvm_vg.vg = {
      type = "lvm_vg";
      lvs = {
        swap = {
          size = "32G";
          content = {
            type = "swap";
            resumeDevice = true;
          };
        };
        # "100%" LVs are created last, so the swap above gets its 32G first.
        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
  };
}
