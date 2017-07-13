#!/usr/bin/env bash

echo in build-pdfium ...

# set -x
set -e

PLATFORM=linux-x64
LIBNAME="libpdfium-dev"
VERSION_PDFIUM=master

git=$(which git)

BASE=$(pwd)
BUILD_DIR="${BASE}/build"
PATCH_DIR="${BASE}/patches"
BUILD_PKG="${BASE}/package"

BUILD_PDFIUM="${BUILD_DIR}/pdfium-${VERSION_PDFIUM}"
BUILD_RES="out/Release_${PLATFORM}"

TARGET_PDFIUM="${BASE}/target"

rm -rf ${BUILD_DIR}
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

DEPOT_TOOLS="${BUILD_DIR}/depot_tools"

if [ ! -d "${DEPOT_TOOLS}" ]; then
    ${git} clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
fi

export PATH="${DEPOT_TOOLS}":"$PATH"

gclient config --unmanaged https://pdfium.googlesource.com/pdfium.git
gclient sync

cd pdfium

gn gen "${BUILD_RES}" --args='pdf_bundle_freetype = true pdf_enable_v8 = false pdf_enable_xfa = false pdf_use_skia = false pdf_use_skia_paths = false is_component_build = true pdf_is_complete_lib = true use_sysroot = false'

ninja -C "${BUILD_RES}"

if [ -d ${BUILD_PDFIUM} ]; then
    rm -rf ${BUILD_PDFIUM}
fi

mkdir -p ${BUILD_PDFIUM}

if [ -d ${TARGET_PDFIUM} ]; then
    rm -rf ${TARGET_PDFIUM}
fi

mkdir -p ${TARGET_PDFIUM}
mkdir -p "${TARGET_PDFIUM}/lib"
mkdir -p "${TARGET_PDFIUM}/include"

find ${BUILD_RES} -name '*.a' -not -path "**/testing/*" -not -path "**/build/*" -not -name 'libtest_support.a' -exec cp {} ${TARGET_PDFIUM}/lib \;

cp public/*.h ${TARGET_PDFIUM}/include

if [ -d ${BUILD_PKG} ]; then
    rm -rf ${BUILD_PKG}
fi

mkdir -p ${BUILD_PKG}

cd ${TARGET_PDFIUM}

tar czf /${BUILD_PKG}/libpdfium-${VERSION_PDFIUM}-${PLATFORM}.tar.gz include lib
