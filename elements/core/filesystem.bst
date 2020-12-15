kind: compose

build-depends:
- core/minimal/deps.bst

config:
  exclude:
  - debug
  - devel
  include-orphans: True