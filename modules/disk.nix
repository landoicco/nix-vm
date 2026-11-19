# Disk layout, applied by disko during install: BIOS boot, root and 4 GiB swap.
{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/sda";
    content = {
      type = "gpt";
      partitions = {
        # GRUB's core image on a GPT disk booted by BIOS; disko points GRUB here
        boot = {
          size = "1M";
          type = "EF02";
        };
        root = {
          end = "-4G";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
        swap = {
          size = "100%";
          content.type = "swap";
        };
      };
    };
  };
}
