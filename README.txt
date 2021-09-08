# AzireVPN Client Debian Source Package

This is a Debian Source Package for [AzireVPN](https://azirevpn.com)'s [AZCLIENT](https://github.com/azirevpn/azclient) GUI VPN Client.

Using a source package, you can easily compile the client from source into a `.deb` package, regardless of
what debian-based distro you're running, or what architecture your system runs (amd64/i386/armhf/arm64/etc.).

This source package was created by [Chris (Someguy123)](https://github.com/Someguy123) at [Privex Inc.](https://www.privex.io),
without any funding or guidance from AzireVPN - it was simply created to allow Privex to easily build DEB packages for their
VPN client to place on https://apt.privex.io (Privex's APT Repo).

License: X11 / MIT


To build it:

    # Install the dev tools required to build a DEB from the source package
    sudo apt update
    sudo apt install -y build-essential devscripts equivs dpkg-dev
    
    # Clone the repo
    git clone --recursive https://github.com/Privex/azirevpn-sourcepkg.git azirevpn-0.5.0

    # If you aren't already in the folder containing the AzireVPN source package files,
    # then enter it now.
    cd azirevpn-0.5.0
    
    # View the help for the custom MAKE subcommands available for this source package
    make help

    # Now you can use the 'deb' Makefile alias, which will attempt to install the build
    # deps using 'mk-build-deps -i', followed by compiling the source code, and building
    # the DEB using 'dpkg-buildpackage -uc -us -b'
    make deb

    # Alternatively, you can use 'make debinstall' to build the DEB, and then install it
    # as soon as it's built.
    make debinstall
    
You can find the built DEB file in the directory above the project:

    ls -lah ..
    ls -lah ../azirevpn_0.5.0_amd64.deb


