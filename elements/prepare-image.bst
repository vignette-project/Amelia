kind: manual

depends:
- freedesktop-sdk.bst:bootstrap-import.bst

runtime-depends:
- freedesktop-sdk.bst:components/systemd.bst
- freedesktop-sdk.bst:components/tzdata.bst

config:
  install-commands:
  - |
    install -Dm 755 -t "%{install-root}%{bindir}" prepare-image.sh

sources:
- kind: local
  path: files/prepare-image.sh