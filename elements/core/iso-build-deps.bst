kind: stack

runtime-depends:
- core/pkgs/libostree.bst
- core/pkgs/libisoburn.bst
- core/isomd5sum.bst
- freedesktop-sdk.bst:integration/mtab.bst
- freedesktop-sdk.bst:components/genimage.bst
- freedesktop-sdk.bst:vm/prepare-image.bst
- freedesktop-sdk.bst:snap-images/squashfs-tools.bst