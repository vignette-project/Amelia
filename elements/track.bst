kind: stack
description: |
  Do not build! 
  This is simply a stack to track all that needs to be tracked properly by Buildstream.
  As much as possible, only run `bst track` here!

depends:
  - vm/image.bst
  - boards/pinebook-pro/image.bst
  - boards/rock64/image.bst
  - boards/raspberrypi-4/image.bst
  - vm/repo-devel.bst
  - iso/image.bst