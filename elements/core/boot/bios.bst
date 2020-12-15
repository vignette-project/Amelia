kind: script

build-depends:
- core/boot/bios/deps.bst
- core/boot/bios/initial-scripts.bst
- prepare-image.bst

variables:
  uuidnamespace: df2427db-01ec-4c99-96b1-be3edb3cd9f6
  install-root: /boot

config:

  layout:
  - element: ''
    destination: '/tmp'
  - element: ''
    destination: '/var/tmp'
  - element: ''
    destination: '/boot'
  - element: core/boot/bios/deps.bst
    destination: '/'
  - element: core/boot/bios/initial-scripts.bst
    destination: '/'
  - element: core/prepare-image.bst
    destination: '/'

  commands:
  - |
    prepare-image.sh --rootpasswd root --seed "%{uuidnamespace}" \
                     --efipath=/boot >/tmp/vars

  - |
    dracut -v --fstab \
           --no-machineid \
           --kver $(ls -1 /lib/modules | head -n1) \
           --install 'fsck.ext4' \
           --gzip \
           /boot/initramfs.gz

  - |
    . /tmp/vars
    mkdir -p /boot/syslinux
    cat <<EOF >/boot/syslinux/syslinux.cfg
    PROMPT 0
    TIMEOUT 5
  
    ALLOWOPTIONS 1
    SERIAL 0 115200
  
    DEFAULT linux
    LABEL linux
      KERNEL /vmlinuz
      INITRD /initramfs.gz
      APPEND rw console=tty0 console=ttyS0 root=UUID=${uuid_root} quiet
    EOF
