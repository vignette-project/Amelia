kind: manual

depends:
- freedesktop-sdk.bst:components/systemd.bst

variables:
  journald-config: "%{install-root}%{indep-libdir}/systemd/journald.conf.d"

config:
  install-commands:
  - |
    mkdir -p "%{journald-config}"
    install -m 644 -t "%{journald-config}" 99-volatile-journal.conf

sources:
- kind: local
  path: files/journald-config/99-volatile-journal.conf
