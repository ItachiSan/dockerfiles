# dockerfiles
My collection of `Dockerfile`s.
Mainly, I need 2 kind of them:
- devtools: containers of specific distros with development tools already in.
- Android: containers meant to build Android (would like to use them in Jenkins). 

# devtools
Containers with development tools installed.
Inside them, you can build packages using the normal packaging tools or
the chroot-based tools provided by the distros.
- [ ] Ubuntu (chroot: `pbuilder-dist`)
- [ ] ArchLinux (chroot: `extra-{x86_64,i686}`)

# Android
TODO