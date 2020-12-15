kind: script

build-depends:
- freedesktop-sdk.bst:components/ostree.bst
- deploy-tools.bst
- core/filesystem.bst
- core/initial-scripts.bst
- prepare-image.bst

variables:
  uuidnamespace: df2427db-01ec-4c99-96b1-be3edb3cd9f6

  (@):
  - ostree-config.yml

environment:
  OSTREE_REPO: "%{install-root}/ostree/repo"

config:
  layout:
  - element: ''
    destination: '/tmp'
  - element: 'freedesktop-sdk.bst:vm/deploy-tools.bst'
    destination: '/'
  - element: 'freedesktop-sdk.bst:components/ostree.bst'
    destination: '/'
  - element: 'core/filesystem.bst'
    destination: '/sysroot'
  - element: 'core/initial-scripts.bst'
    destination: '/'
  - element: ''
    destination: '/efi'

  commands:
  - |
    prepare-image.sh \
       --sysroot /sysroot \
       --seed "%{uuidnamespace}" \
       --rootsource /dev/gpt-auto-root \
        --efisource LABEL=EFI \
       --efipath /boot \
       --rootpasswd "root" >"%{install-root}/vars"

  - mkdir -p "${OSTREE_REPO}"
  - ostree init --repo="${OSTREE_REPO}" --mode=archive
  - mv /sysroot/etc /sysroot/usr/etc
  - ostree commit --branch=%{ostree-branch} /sysroot
