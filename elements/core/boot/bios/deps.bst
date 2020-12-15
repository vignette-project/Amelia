kind: stack

runtime-depends:
- bootstrap-import.bst
- components/util-linux.bst
- components/linux.bst
- components/linux-firmware.bst
- components/wireless-regdb-bin.bst
- components/systemd.bst
- components/dbus.bst
- components/dracut.bst
- components/os-release.bst
- components/shadow.bst
- components/tzdata.bst
- components/pkg-config.bst
- vm/deploy-tools.bst
- components/gzip.bst
kind: stack

runtime-depends:
- freedesktop-sdk.bst:bootstrap-import.bst
- freedesktop-sdk.bst:components/util-linux.bst
- freedesktop-sdk.bst:components/linux.bst
- freedesktop-sdk.bst:components/linux-firmware.bst
- freedesktop-sdk.bst:components/wireless-regdb-bin.bst
- freedesktop-sdk.bst:components/systemd.bst
- freedesktop-sdk.bst:components/dbus.bst
- freedesktop-sdk.bst:components/dracut.bst
- freedesktop-sdk.bst:components/os-release.bst
- freedesktop-sdk.bst:components/shadow.bst
- freedesktop-sdk.bst:components/tzdata.bst
- freedesktop-sdk.bst:components/pkg-config.bst
- deploy-tools.bst
- freedesktop-sdk.bst:components/gzip.bst