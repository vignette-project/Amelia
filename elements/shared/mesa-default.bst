kind: manual

depends:
- freedesktop-sdk.bst:bootstrap-import.bst
- freedesktop-sdk.bst:extensions/mesa/mesa.bst

config:
  install-commands:
  - |
    for i in vulkan/icd.d glvnd/egl_vendor.d OpenCL/vendors lib/dri \
             lib/d3d vulkan/explicit_layer.d; do
      mkdir -p "%{install-root}%{libdir}/GL/$(dirname "${i}")"
      ln -rs "%{install-root}%{libdir}/GL/default/${i}" "%{install-root}%{libdir}/GL/${i}"
    done

public:
  bst:
    integration-commands:
    - |
      echo "%{libdir}/GL/default/lib" >>/etc/ld.so.conf

    - |
      ldconfig
