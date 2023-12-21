#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the dialog source directory which ls finds, e.g. 'reiser4progs-1.3-20170509'.
cd $(ls -d reiser4progs-*)

if [ -f Makefile ] ; then
  echo "Preparing 'partclone' work area. This may take a while."
  make -j $NUM_JOBS clean
else
  echo "The clean phase for 'reiser4progs' has been skipped."
fi

rm -rf $DEST_DIR

echo "Configuring 'reiser4progs'."
CFLAGS="$CFLAGS" ./configure \
    --prefix=/usr \


echo "Building 'reiser4progs'."
make -j $NUM_JOBS

echo "Installing 'reiser4progs'."
make -j $NUM_JOBS install DESTDIR=$DEST_DIR

rm -rf $DEST_DIR/usr/lib $DEST_DIR/usr/share

echo "Reducing 'reiser4progs' size."
set +e
strip -g $DEST_DIR/usr/sbin/*
set -e

# With '--remove-destination' all possibly existing soft links in
# '$OVERLAY_ROOTFS' will be overwritten correctly.
cp -r --remove-destination $DEST_DIR/usr \
  $OVERLAY_ROOTFS

echo "Bundle 'partclone' has been installed."

cd $SRC_DIR
