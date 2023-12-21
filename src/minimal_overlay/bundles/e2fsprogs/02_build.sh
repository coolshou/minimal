#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the dialog source directory which ls finds, e.g. 'e2fsprogs-1.47.0'.
cd $(ls -d e2fsprogs-*)

if [ -f Makefile ] ; then
  echo "Preparing 'e2fsprogs' work area. This may take a while."
  make -j $NUM_JOBS clean
else
  echo "The clean phase for 'e2fsprogs' has been skipped."
fi

rm -rf $DEST_DIR

echo "Configuring 'e2fsprogs'."
CFLAGS="$CFLAGS" ./configure \
    --prefix=/usr

echo "Building 'e2fsprogs'."
make -j $NUM_JOBS

echo "Installing 'e2fsprogs'."
make -j $NUM_JOBS install DESTDIR=$DEST_DIR

# remove static lib .a file
rm -rf $DEST_DIR/usr/lib 
rm -rf $DEST_DIR/usr/share

echo "Reducing 'e2fsprogs' size."
set +e
strip -g $DEST_DIR/usr/bin/*
set -e

# With '--remove-destination' all possibly existing soft links in
# '$OVERLAY_ROOTFS' will be overwritten correctly.
cp -r --remove-destination $DEST_DIR/usr \
  $OVERLAY_ROOTFS

echo "Bundle 'e2fsprogs' has been installed."

cd $SRC_DIR
