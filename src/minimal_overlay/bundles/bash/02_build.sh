#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the dialog source directory which ls finds, e.g. 'bash-5.2'.
cd $(ls -d bash-*)

if [ -f Makefile ] ; then
  echo "Preparing 'bash' work area. This may take a while."
  make -j $NUM_JOBS clean
else
  echo "The clean phase for 'bash' has been skipped."
fi

rm -rf $DEST_DIR

echo "Configuring 'bash'."
CFLAGS="$CFLAGS" ./configure \
    --prefix=/usr

echo "Building 'bash'."
make -j $NUM_JOBS

echo "Installing 'bash'."
make -j $NUM_JOBS install DESTDIR=$DEST_DIR

rm -rf $DEST_DIR/usr/share $DEST_DIR/usr/include
rm -rf $DEST_DIR/usr/lib/pkgconfig
rm -rf $DEST_DIR/usr/bin/bashbug

echo "Reducing 'bash' size."
set +e
strip -g $DEST_DIR/usr/bin/bash
set -e

# With '--remove-destination' all possibly existing soft links in
# '$OVERLAY_ROOTFS' will be overwritten correctly.
cp -r --remove-destination $DEST_DIR/usr \
  $OVERLAY_ROOTFS

echo "Bundle 'bash' has been installed."

cd $SRC_DIR
