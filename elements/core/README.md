## The Amelia Core

This is the core system that all experience targets rely on. Amelia Core only contains the bare minimum things needed to run a CLI environment with a OSTree setup.

## What can I include here?

The Amelia Core should *only* contain things that is shared accross all experiences and is deemed to be important for inclusion that merits it to be in this target.
This, however, does not allow you to include things that is only shared between GUI experiences, for that purpose, use the `shared` target and include your BSTs from there.

## Things included

As much as possible, Amelia includes only the following:

- `ostree`
- `systemd`
- `pulseaudio`
- `NetworkManager`
- the kernel (xanmod-rt)

## Building

The core by now is not buildable, it's intended to be a base for a full experience. The experiences are expected to generate their own images as well, given they also used the same configuration provided over at `boot/`. A demo of a "experience target" is on `experiences/experience-minimal`.