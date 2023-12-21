#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the dialog source directory which ls finds, e.g. 'exfatprogs-1.2.2'.
cd $(ls -d exfatprogs-*)

if [ -f Makefile ] ; then
  echo "Preparing 'exfatprogs' work area. This may take a while."
  make -j $NUM_JOBS clean
else
  echo "The clean phase for 'exfatprogs' has been skipped."
fi

rm -rf $DEST_DIR

echo "Configuring 'exfatprogs'."
./autogen.sh
CFLAGS="$CFLAGS" ./configure \
    --prefix=/usr

echo "Building 'exfatprogs'."
make -j $NUM_JOBS

echo "Installing 'exfatprogs'."
make -j $NUM_JOBS install DESTDIR=$DEST_DIR

# remove static lib .a file
#rm -rf $DEST_DIR/usr/lib 
rm -rf $DEST_DIR/usr/share

echo "Reducing 'exfatprogs' size."
set +e
strip -g $DEST_DIR/usr/bin/*
set -e

# With '--remove-destination' all possibly existing soft links in
# '$OVERLAY_ROOTFS' will be overwritten correctly.
cp -r --remove-destination $DEST_DIR/usr \
  $OVERLAY_ROOTFS

echo "Bundle 'exfatprogs' has been installed."

cd $SRC_DIR
