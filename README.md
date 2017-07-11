# Build PDFium

See

https://github.com/jcupitt/libvips/issues/689

# Native build

### Install depot tools

	cd GIT
	git clone
	https://chromium.googlesource.com/chromium/tools/depot_tools.git
	export PATH=`pwd`/depot_tools:"$PATH"

### Fetch PDFium

	gclient config --unmanaged
	https://pdfium.googlesource.com/pdfium.git
	gclient sync

### Pull in other deps

	cd pdfium
	./build/install-build-deps.sh

Fails saying Ubuntu 17.04 is not a supported build platform.

# Docker build

Enter:

	sudo ./build.sh

Should generate:

	total 28296
	-rw-r--r-- 1 john lxd 28973765 Jul 11 13:17 libpdfium-master-linux-x64.tar.gz

