kind: manual

build-depends:
- freedesktop-sdk.bst:bootstrap-import.bst
- freedesktop-sdk.bst:components/m4.bst

runtime-depends:
- freedesktop-sdk.bst:components/systemd.bst
- freedesktop-sdk.bst:components/ostree.bst

variables:
  (@):
  - ostree-config.yml

config:
  build-commands:
  - |
    m4 -DOSTREE_REMOTE_URL="%{ostree-remote-url}" \
      freedesktop-sdk.conf.in >freedesktop-sdk.conf

  install-commands:
  - mkdir %{install-root}/boot
  - mkdir %{install-root}/efi
  - mkdir %{install-root}/etc
  - mkdir %{install-root}/mnt
  - mkdir %{install-root}/run
  - mkdir %{install-root}/opt
  - mkdir %{install-root}/sys
  - mkdir %{install-root}/tmp
  - mkdir %{install-root}/dev
  - mkdir %{install-root}/proc

  - mkdir -p "%{install-root}/sysroot"
  - ln -s sysroot/ostree "%{install-root}/ostree"
  # Though we use /var/home in /etc/passwd and this symlink should
  # be useless removing this symlink breaks --filesystem=host on
  # flatpak.
  - ln -s var/home "%{install-root}/home"
  - ln -s var/roothome "%{install-root}/root"
  - ln -s run/media "%{install-root}/media"

  - install -Dm644 -t "%{install-root}/usr/lib/tmpfiles.d" ostree.conf
  - install -Dm644 -t "%{install-root}/etc/pki/ostree" fdsdk.gpg
  - install -Dm644 -t "%{install-root}/etc/ostree/remotes.d" freedesktop-sdk.conf

sources:
- kind: local
  path: files/ostree-config
