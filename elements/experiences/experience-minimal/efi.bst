kind: script

description: |
  EFI Target for a minimal experience target. This is intended only to demonstrate how to build a experience target.

build-depends:
- deploy-tools.bst
- core/boot/efi.bst
- core/filesystem.bst
- core/initial-scripts.bst
- prepare-image.bst


variables:
  uuidnamespace: df2427db-01ec-4c99-96b1-be3edb3cd9f6
  (?):
    - target_arch == "x86_64":
        linux-root: 4F68BCE3-E8CD-4DB1-96E7-FBCAF984B709
    - target_arch == "i686":
        linux-root: 44479540-F297-41B2-9AF7-D131D5F0458A
    - target_arch == "arm":
        linux-root: 69DAD710-2CE4-4E3C-B16C-21A1D49ABED3
    - target_arch == "aarch64":
        linux-root: B921B045-1DF0-41C3-AF44-4C6F280D3FAE

config:
  layout:
  - element: ''
    destination: '/genimage'
  - element: ''
    destination: '/tmp'
  - element: 'deploy-tools.bst'
    destination: '/'
  - element: 'core/boot/efi.bst'
    destination: '/sysroot/efi'
  - element: 'core/filesystem.bst'
    destination: '/sysroot'
  - element: 'core/initial-scripts.bst'
    destination: '/'

  commands:
  - |
    prepare-image.sh \
       --sysroot /sysroot \
       --seed "%{uuidnamespace}" \
       --rootpasswd "root" >/tmp/vars

  - |
    . /tmp/vars
    cat >/genimage/genimage.cfg <<EOF
    image efi.img {
        vfat {
            extraargs = "-F32 -i${id_efi} -n EFI"
        }
        mountpoint = "/efi"
        size = 100M
    }
    image root.img {
        ext4  {
            label = "root"
            extraargs = "-U ${uuid_root}"
            use-mke2fs = true
        }
        size = 1G
    }
    image disk.img {
        hdimage {
            align = 1M
            gpt = true
        }
        partition efi {
            image = "efi.img"
            partition-type-uuid = "U"
        }
        partition root {
            image = "root.img"
            partition-type-uuid = "%{linux-root}"
        }
    }
    EOF

  - |
    cd /genimage/
    genimage --rootpath /sysroot

  - |
    install -Dm644 -t "%{install-root}" /genimage/images/disk.img