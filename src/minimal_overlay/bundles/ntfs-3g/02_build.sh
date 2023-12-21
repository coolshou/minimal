#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the dialog source directory which ls finds, e.g. 'ntfs-3g-1.47.0'.
cd $(ls -d ntfs-3g-*)

if [ -f Makefile ] ; then
  echo "Preparing 'ntfs-3g' work area. This may take a while."
  make -j $NUM_JOBS clean
else
  echo "The clean phase for 'ntfs-3g' has been skipped."
fi

rm -rf $DEST_DIR

echo "Configuring 'ntfs-3g'."
./autogen.sh  --install
CFLAGS="$CFLAGS" ./configure \
    --prefix=/usr --exec-prefix=/usr \
    --enable-extras --enable-xattr-mappings \
    --enable-posix-acls \
    --enable-quarantined --disable-ldconfig \
    --enable-mount-helper

echo "Building 'ntfs-3g'."
make -j $NUM_JOBS

echo "Installing 'ntfs-3g'."
make -j $NUM_JOBS install DESTDIR=$DEST_DIR

rm -rf  $DEST_DIR/usr/share
#rm -rf $DEST_DIR/usr/lib $DEST_DIR/usr/share

echo "Reducing 'ntfs-3g' size."
set +e
strip -g $DEST_DIR/usr/bin/*
set -e

# With '--remove-destination' all possibly existing soft links in
# '$OVERLAY_ROOTFS' will be overwritten correctly.
cp -r --remove-destination $DEST_DIR/usr \
  $OVERLAY_ROOTFS

echo "Bundle 'ntfs-3g' has been installed."

cd $SRC_DIR
