kind: autotools

sources:
- kind: tar
  url: libburnia:libisofs-1.5.2.tar.gz

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-autotools.bst

depends:
- freedesktop-sdk.bst:bootstrap-import.bst