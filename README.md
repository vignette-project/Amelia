# Project Amelia

Amelia is a distribution project at Vignette that is aimed for low-latency applications. Based on GNOME's gnome-build-meta project, Amelia promises to be a solid, secure, and *idiot-proof*.

### Solid

Built with Buildstream and OSTree, Amelia is designed to be reproducible and ensures each machine has the same copy and revision we release on our servers. 

### Secure

Always building against latest versions, we make sure Amelia is built with only the latest source versions.

### Idiot-proof

The main OS is hidden away from the user as much as possible. This makes sure you don't break your OS in any way possible that is beyond your control. In the near future, we will also abstract the terminal session away so you can  have a traditional Linux experience, sans the breaking part.


## Roadmap

There is still a lot to do with Amelia. For now we track the following based on the current state of the repo:

- [] CI
- [] OSTree CDN
  -  We might need to inquire with a upstream project to host Amelia's OSTree branches.
- Core features
  - [] Isolated Terminal experience (WSL2-like as much as possible)
  - [] Low-latency/Realtime Kernel (targeting LTS as much as possible).
- Developer QoL
  - [] Allow people to make deriverative by using us as a junction base.
  - [] Forward X11/Wayland from the isolated terminal to ours. 

### 2.0 Roadmap

- [] Modularity
  - This would allow us to supply multiple versions but ship the same secure base.

- [] Editions
  - [] Desktop
  - [] Datacenter

## Inspiration and Motivation

The main inspiration for this is the Chrome OS ecosystem. Ayane Satomi used to run her own distribution (maru) but it was progressively getting worse to maintain due to the fact:

- It's  using the Gentoo buildsystem and the cascading errors were getting hard to fix.

- Architectural changes in CrOS would have to be done in a 5-year timespan at most.

- There is no way to fix the current CrOS buildsystem debacle. Everyone would have to invest at least 5+ years to migrate the buildsystems and adapt the CI for it.

- A lot of Chrome OS's parts are still undocumented. It was too much pain to get those undocumented parts to work.

So Amelia was created to address these issues. It's also a experiment on how it would impact applications if we use a real time kernel.

## Credits

Amelia is Copyright &copy; The Vignette Developers. Licensed under MIT.

Amelia is based on gnome-build-meta. Licensed under MIT.

Amelia 1.0 contains software from GNOME. GNOME Software Stack is licensed under GPLv3.

