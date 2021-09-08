BINDIR := /usr/bin

all:
	bash -c "cd src && qtchooser -run-tool=qmake -qt=5 && make -j$(nproc)"

install:
	mkdir -p ${DESTDIR}${BINDIR}
	install -v src/azclient ${DESTDIR}${BINDIR}
	ln -s ${DESTDIR}${BINDIR}/azclient ${DESTDIR}${BINDIR}/azirevpn 
	mkdir -p ${DESTDIR}/usr/share/applications
	mkdir -p ${DESTDIR}/usr/share/pixmaps
	cp -v src/dist/linux/azirevpn.desktop ${DESTDIR}/usr/share/applications/
	cp -v src/resources/icons/app.svg ${DESTDIR}/usr/share/pixmaps/azirevpn.svg
	make clean-src

clean:
	make clean-root
	make clean-src

clean-root:
	echo " >> Removing fakeroot at DEBIAN/azirevpn"
	bash -c '[[ -d DEBIAN/azirevpn ]] && rm -rf DEBIAN/azirevpn || true'

clean-src:
	echo " >> Running 'make clean' in src/"
	bash -c "cd src && make -f Makefile clean && cd .."
	echo " >> Removing 'azclient' in src/"
	bash -c '[[ -f src/azclient ]] && rm src/azclient || true'

compile:
	echo -e "\n >>> Compiling AzireVPN client in src/ using qtchooser + make ...\n"
	make all
	echo -e "\n +++ FINISHED COMPILING AzireVPN Client in src/ +++ \n"

install-deps:
	echo " >> Installing build deps via mk-build-deps"
	bash -c '(( EUID == 0 )) && mk-build-deps -t "apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends -y" -i || sudo mk-build-deps -t "apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends -y" -i'

build-deb:
	echo " >> Building the package using dpkg-buildpackage"
	dpkg-buildpackage -uc -us -b

deb:
	echo " [!!!] WARNING: If you get errors about missing tools,"
	echo "       please install the required packages for building:"
	echo
	echo "           apt install -y devscripts equivs dpkg-dev"
	echo
	make install-deps
	make build-deb
	echo -e "\n +++ FINISHED. You should find the DEB file in the folder above this: ls -lha ..\n"

install-deb:
	echo -e "\n\n >>> Installing AzireVPN DEB package using dpkg ...\n"
	bash -c "[[ -f ../azirevpn_0.5.0_amd64.deb ]] && { (( EUID == 0 )) && dpkg -i ../azirevpn_0.5.0_amd64.deb || sudo dpkg -i ../azirevpn_0.5.0_amd64.deb; } || true"
	bash -c "[[ -f ../azirevpn_0.5.0_arm64.deb ]] && { (( EUID == 0 )) && dpkg -i ../azirevpn_0.5.0_arm64.deb || sudo dpkg -i ../azirevpn_0.5.0_arm64.deb; } || true"
	bash -c "[[ -f ../azirevpn_0.5.0_i686.deb ]] && { (( EUID == 0 )) && dpkg -i ../azirevpn_0.5.0_i686.deb || sudo dpkg -i ../azirevpn_0.5.0_i686.deb; } || true"
	bash -c "[[ -f ../azirevpn_0.5.0_i386.deb ]] && { (( EUID == 0 )) && dpkg -i ../azirevpn_0.5.0_i386.deb || sudo dpkg -i ../azirevpn_0.5.0_i386.deb; } || true"
	bash -c "[[ -f ../azirevpn_0.5.0_armhf.deb ]] && { (( EUID == 0 )) && dpkg -i ../azirevpn_0.5.0_armhf.deb || sudo dpkg -i ../azirevpn_0.5.0_armhf.deb; } || true"
	bash -c "[[ -f ../azirevpn_0.5.0_armel.deb ]] && { (( EUID == 0 )) && dpkg -i ../azirevpn_0.5.0_armel.deb || sudo dpkg -i ../azirevpn_0.5.0_armel.deb; } || true"
	bash -c "[[ -f ../azirevpn_0.5.0_mips.deb ]] && { (( EUID == 0 )) && dpkg -i ../azirevpn_0.5.0_mips.deb || sudo dpkg -i ../azirevpn_0.5.0_mips.deb; } || true"
	bash -c "[[ -f ../azirevpn_0.5.0_mips64el.deb ]] && { (( EUID == 0 )) && dpkg -i ../azirevpn_0.5.0_mips64el.deb || sudo dpkg -i ../azirevpn_0.5.0_mips64el.deb; } || true"
	bash -c "[[ -f ../azirevpn_0.5.0_mipsel.deb ]] && { (( EUID == 0 )) && dpkg -i ../azirevpn_0.5.0_mipsel.deb || sudo dpkg -i ../azirevpn_0.5.0_mipsel.deb; } || true"
	bash -c "[[ -f ../azirevpn_0.5.0_ppc64el.deb ]] && { (( EUID == 0 )) && dpkg -i ../azirevpn_0.5.0_ppc64el.deb || sudo dpkg -i ../azirevpn_0.5.0_ppc64el.deb; } || true"
	bash -c "[[ -f ../azirevpn_0.5.0_s390x.deb ]] && { (( EUID == 0 )) && dpkg -i ../azirevpn_0.5.0_s390x.deb || sudo dpkg -i ../azirevpn_0.5.0_s390x.deb; } || true"
	echo -e "\n\n +++ FINISHED installing AzireVPN DEB package using dpkg +++ \n"

debinstall:
	make deb
	make install-deb

help:
	cat HELP_MAKE.txt

otherhelp:
	echo -e "\n ===================================================== \n"
	echo -e "Makefile for AzireVPN source package\n"
	echo -e "Sub-commands:\n"
	echo -e "\t debinstall      - Runs 'deb' followed by 'install-deb'\n"
	echo -e "\t install-deb     - Searches parent directory for azirevpn_0.5.0_ARCH.deb (where arch = amd64/armhf/arm64 etc.),"
	echo -e "\t                   and installs it using 'dpkg -i' if found.\n"
	echo -e "\t build-deb       - Compiles the source and builds the DEB package using 'dpkg-buildpackage -uc -us -b'\n"
	echo -e "\t install-deps    - Generates a DEB containing the build dependencies in it's metadata, and then"
	echo -e "\t                   installs the DEB using dpkg  to install the build deps. - uses: 'mk-build-deps -i' \n"
	echo -e "\t deb             - Runs 'install-deps' followed by 'build-deb'\n"
	echo -e "\t compile         - Only compiles the AzireVPN client in 'src/' by calling the 'all' subcommand, while printing a message before and after.\n"
	echo -e "\n ------------ \n"
	echo -e "Internal Sub-commands - used by dpkg-buildpackage / debuild:\n"
	echo -e "\t clean-src       - Runs 'make clean' inside of 'src/' and deletes 'src/azclient' if found\n"
	echo -e "\t clean-root      - Deletes the fakeroot build env at 'DEBIAN/azirevpn' if found\n"
	echo -e "\t clean           - Runs 'clean-root' followed by 'clean-src'\n"
	echo -e "\t install         - Creates any needed dest folders, copies the compiled executable + resources to the dest folder, and finally runs 'clean-src'\n"
	echo -e "\t all             - Compiles the app in 'src/' using qtchooser + make\n"
	echo -e "\n ===================================================== \n"
	



