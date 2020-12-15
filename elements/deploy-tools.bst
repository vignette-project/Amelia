kind: stack
description: Deployment tooling

depends:
- freedesktop-sdk.bst:components/e2fsprogs.bst
- freedesktop-sdk.bst:components/systemd.bst
- freedesktop-sdk.bst:components/dosfstools.bst
- freedesktop-sdk.bst:components/mtools.bst
- freedesktop-sdk.bst:components/syslinux.bst
- freedesktop-sdk.bst:components/tzdata.bst
- freedesktop-sdk.bst:components/genimage.bst
- freedesktop-sdk.bst:integration/mtab.bst
- prepare-image.bst