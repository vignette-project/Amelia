kind: stack
description: |
   Dependencies used by the base target. These are the bare minimum required to have a bootable system. If you need libdrm or something else, you would need to supply
   At least one DE. X11 is included for you, the only requirement for you to do is supply GUI-specific libraries that we cannot include in this repository.

runtime-depends:
- freedesktop-sdk.bst:bootstrap-import.bst
- freedesktop-sdk.bst:components/util-linux.bst
- freedesktop-sdk.bst:components/systemd.bst
- freedesktop-sdk.bst:components/dbus.bst
- freedesktop-sdk.bst:components/dracut.bst
- freedesktop-sdk.bst:components/os-release.bst
- freedesktop-sdk.bst:components/shadow.bst
- freedesktop-sdk.bst:components/tzdata.bst
- core/config/journald.bst
- core/config/networkd.bst
- core/config/resolved.bst
- core/config/ostree.bst
- core/config/useradd-ostree.bst
- core/boot/efi-ostree.bst
- freedesktop-sdk.bst:components/gnupg.bst
- freedesktop-sdk.bst:components/eos-updater.bst
- freedesktop-sdk.bst:components/linux-firmware.bst
- freedesktop-sdk.bst:components/wireless-regdb-bin.bst
- freedesktop-sdk.bst:components/iproute2.bst
- freedesktop-sdk.bst:components/usbutils.bst
- freedesktop-sdk.bst:components/hosts.bst
- freedesktop-sdk.bst:components/bash-config.bst
- freedesktop-sdk.bst:components/bash-completion.bst
