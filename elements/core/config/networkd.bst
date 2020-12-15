kind: manual

depends:
- freedesktop-sdk.bst:components/systemd.bst

variables:
  networkd-config: "%{install-root}%{indep-libdir}/systemd/network/"

config:
  install-commands:
  - |
    install -Dm 644 -t "%{networkd-config}" 20-wired.network
    install -Dm 644 \
        -t "%{install-root}%{indep-libdir}/systemd/system-preset" \
        networkd.preset

sources:
- kind: local
  path: files/systemd-networkd
