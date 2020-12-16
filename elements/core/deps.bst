kind: stack

runtime-depends:
- core/installer-dirs.bst

- freedesktop-sdk.bst:components/plymouth.bst
- freedesktop-sdk.bst:components/xorg-server.bst
- freedesktop-sdk.bst:components/systemd.bst
- freedesktop-sdk.bst:components/linux.bst
- freedesktop-sdk.bst:components/linux-firmware.bst
- freedesktop-sdk.bst:components/shadow.bst
- freedesktop-sdk.bst:vm/mesa-default.bst
- freedesktop-sdk.bst:vm/config/journald.bst
- core/os-release-user.bst