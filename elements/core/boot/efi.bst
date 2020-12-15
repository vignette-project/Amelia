kind: script

build-depends:
- core/boot/efi/deps.bst
- core/boot/efi/initial-scripts.bst
- prepare-image.bst

variables:
  uuidnamespace: df2427db-01ec-4c99-96b1-be3edb3cd9f6
  # FIXME: dracut uses wront directory when using /efi
  install-root: '/boot'

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
    destination: '/var/tmp'
  - element: ''
    destination: '/boot'
  - element: core/boot/efi/deps.bst
    destination: '/'
  - element: core/boot/efi/initial-scripts.bst
    destination: '/'
  - element: prepare-image.bst
    destination: '/'

  commands:
  - prepare-image.sh --sysroot / --rootpasswd root \
                     --seed "%{uuidnamespace}" \
                     --rootsource /dev/gpt-auto-root >/tmp/vars

  - dbus-uuidgen >/etc/machine-id
  - SYSTEMD_RELAX_ESP_CHECKS=1 bootctl --path='/boot' --no-variables install
  - rm /etc/machine-id
  - |
    cat <<EOF >/boot/loader/loader.conf
    timeout 3
    editor yes
    console-mode keep
    default *
    EOF

  - |
    . /tmp/vars
    dracut -v --fstab --uefi \
           --uefi-stub /usr/lib/systemd/boot/efi/linux%{efi-arch}.efi.stub \
           --no-machineid --kernel-image /boot/vmlinuz \
           --kver $(ls -1 /lib/modules | head -n1) \
           --kernel-cmdline "rw console=tty0 console=ttyS0 quiet" \
           --install 'fsck.ext4'

  - |
    rm -f /boot/vmlinuz
