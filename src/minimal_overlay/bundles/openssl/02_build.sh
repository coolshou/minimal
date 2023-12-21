#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the dialog source directory which ls finds, e.g. 'openssl-3.0.2'.
cd $(ls -d openssl-*)

if [ -f Makefile ] ; then
  echo "Preparing 'openssl' work area. This may take a while."
  make -j $NUM_JOBS clean
else
  echo "The clean phase for 'openssl' has been skipped."
fi

rm -rf $DEST_DIR

echo "Configuring 'openssl'."
CFLAGS="$CFLAGS" ./Configure \
    --prefix=/usr \
    zlib \
    linux-x86_64


echo "Building 'openssl'."
make -j $NUM_JOBS

echo "Installing 'openssl'."
make -j $NUM_JOBS install DESTDIR=$DEST_DIR

rm -rf  $DEST_DIR/usr/share

echo "Reducing 'openssl' size."
set +e
strip -g $DEST_DIR/usr/bin/openssl
set -e

# With '--remove-destination' all possibly existing soft links in
# '$OVERLAY_ROOTFS' will be overwritten correctly.
cp -r --remove-destination $DEST_DIR/usr \
  $OVERLAY_ROOTFS

echo "Bundle 'openssl' has been installed."

cd $SRC_DIR
