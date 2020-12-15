kind: script

description: |
  Create directories needed by bootable Linux systems that are not in the SDK.

  Since Flatpak runtimes and SDKs do not need to be bootable, they do not
  provide a full filesystem heirarchy.

  For bootable systems, we should follow the Filesystem Heirarchy Standard:
  see <http://refspecs.linuxfoundation.org/fhs.shtml> for more information.

depends:
- filename: freedesktop-sdk.bst:bootstrap-import.bst
  type: build

config:
  commands:
  - |
    mkdir %{install-root}/boot
    mkdir %{install-root}/efi
    mkdir %{install-root}/etc
    mkdir %{install-root}/home
    mkdir %{install-root}/media
    mkdir %{install-root}/mnt
    mkdir %{install-root}/root
    mkdir %{install-root}/run
    mkdir %{install-root}/opt
    mkdir %{install-root}/sys
    mkdir %{install-root}/tmp
    mkdir %{install-root}/dev
    mkdir %{install-root}/proc
