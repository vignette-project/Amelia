kind: script

build-depends:
- core/boot/efi-ostree/deps.bst
- core/boot/efi-ostree/initial-scripts.bst
- core/prepare-image.bst

variables:
  uuidnamespace: df2427db-01ec-4c99-96b1-be3edb3cd9f6

  efi-arch: "%{arch}"
  (?):
  - target_arch == "x86_64":
      efi-arch: x64
  - target_arch == "i686":
      efi-arch: ia32

config:

  layout:
  - element: ''
    destination: '/tmp'
  - element: ''
    destination: '/efi'
  - element: ''
    destination: '/var/tmp'
  - element: core/boot/efi-ostree/deps.bst
    destination: '/'
  - element: core/boot/efi-ostree/initial-scripts.bst
    destination: '/'
  - element: core/prepare-image.bst
    destination: '/'

  commands:
  - |
    prepare-image.sh --rootpasswd root --seed "%{uuidnamespace}" \
         --efipath /boot --efisource LABEL=EFI >/tmp/vars

  - |
    mkdir -p "%{install-root}/usr/lib/"
    cp -r /usr/lib/modules "%{install-root}/usr/lib/"

  - |
    . /tmp/vars
    version="$(ls -1 /lib/modules | head -n1)"
    mkdir -p "%{install-root}/usr/lib/modules/${version}"
    dracut -v --fstab \
           --no-machineid \
           --kver "${version}" \
           --add ostree \
           --install 'fsck.ext4' \
           "%{install-root}/usr/lib/modules/${version}/initramfs"

  - |
    version="$(ls -1 /lib/modules | head -n1)"
    cp /boot/vmlinuz "%{install-root}/usr/lib/modules/${version}/vmlinuz"

  - dbus-uuidgen >/etc/machine-id
  - SYSTEMD_RELAX_ESP_CHECKS=1 bootctl --path='/efi' --no-variables install
  - rm /etc/machine-id

  - |
    cp -r /efi "%{install-root}/boot"

  - |
    cat <<EOF >%{install-root}/boot/loader/loader.conf
    timeout 3
    editor yes
    console-mode keep
    default *
    EOF