#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

#E2FSLIB_DIR=$WORK_DIR/overlay/e2fsprogs/e2fsprogs_installed/usr/
# Change to the dialog source directory which ls finds, e.g. 'partclone-1.3-20170509'.
cd $(ls -d partclone-*)

if [ -f Makefile ] ; then
  echo "Preparing 'partclone' work area. This may take a while."
  make -j $NUM_JOBS clean
else
  echo "The clean phase for 'partclone' has been skipped."
fi

rm -rf $DEST_DIR

echo "Configuring 'partclone'."
./autogen
CFLAGS="$CFLAGS" ./configure \
    --prefix=/usr \
    --enable-fuse \
    --enable-extfs \
    --enable-xfs \
    --enable-fat --enable-exfat --enable-ntfs \
    --enable-btrfs \
    --enable-minix \
    --enable-ncursesw \
    --enable-static 
    
    #--enable-all
    #--enable-reiserfs
    #--enable-reiser4
#    --enable-nilfs2 \ # nilfs-tools
#    --enable-ufs \ # ufsutilies
# --enable-f2fs \  # f2fs-tools
#     --enable-vmfs \  # vmfstools
#     --enable-jfs \ # jfsutils
#  --enable-hfsp --enable-apfs 

echo "Building 'partclone'."
make -j $NUM_JOBS

echo "Installing 'partclone'."
make -j $NUM_JOBS install DESTDIR=$DEST_DIR

#rm -rf $DEST_DIR/usr/lib $DEST_DIR/usr/share

echo "Reducing 'partclone' size."
set +e
strip -g $DEST_DIR/usr/sbin/*
set -e

# With '--remove-destination' all possibly existing soft links in
# '$OVERLAY_ROOTFS' will be overwritten correctly.
cp -r --remove-destination $DEST_DIR/usr \
  $OVERLAY_ROOTFS

echo "Bundle 'partclone' has been installed."

cd $SRC_DIR
