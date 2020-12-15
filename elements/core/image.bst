kind: manual

build-depends:
- freedesktop-sdk.bst:components/ostree.bst
- deploy-tools.bst

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

  (@):
  - ostree-config.yml

  sysroot: "%{build-root}/sysroot"

environment:
  OSTREE_REPO: "%{sysroot}/ostree/repo"

config:
  build-commands:
  - mkdir -p "${OSTREE_REPO}"
  - ostree init --repo="${OSTREE_REPO}" --mode=bare

  - ostree config --group sysroot set bootloader none
  - ostree pull-local "%{build-root}/source-repo" %{ostree-branch}

  - mkdir -p "%{sysroot}/boot"

  - ostree admin init-fs "%{sysroot}"
  - ostree admin os-init --sysroot="%{sysroot}" amelia-os
  - |
    ostree admin deploy --os="amelia-os" \
         --sysroot="%{sysroot}" %{ostree-branch} \
         --karg="rw" --karg=console=ttyS0

  - |
    mkdir -p "%{sysroot}/etc/ostree"
    cp -r "%{sysroot}"/ostree/boot.1/amelia-os/*/*/etc/ostree/remotes.d "%{sysroot}/etc/ostree/remotes.d"

  - |
    ostree admin set-origin --sysroot="%{sysroot}" \
           --index=0 \
           AmeliaOS dummy \
           %{ostree-branch}

  - |
    cp -r "%{sysroot}"/ostree/boot.1/amelia-os/*/*/boot/EFI/ "%{sysroot}/boot/"

  - |
    mkdir -p genimage

  - |
    cat >genimage/genimage.cfg <<EOF
    image efi.img {
        vfat {
            extraargs = "-F32 -n EFI"
        }
        mountpoint = "/boot"
        size = 100M
    }
    image root.img {
        ext4  {
            label = "root"
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
    cd genimage
    genimage --rootpath "%{sysroot}"

  - |
    install -Dm644 -t "%{install-root}" genimage/images/disk.img

sources:
- kind: ostree_mirror
  gpg: files/vm/ostree-config/fdsdk.gpg
  path: ostree-repo
  match: 'freedesktop-sdk-*'
  directory: source-repo
  ref:
  - ref: freedesktop-sdk-20.08beta-x86_64
    checksum: 0a8eca3dfafae7cf0a1ea6485948f58152762110bd13dba36d22d9ce10d17ad4