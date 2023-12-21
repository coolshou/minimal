#!/bin/sh

set -e

. ../../common.sh

# Read the common configuration properties.
DOWNLOAD_URL=`read_property E2FSPROGS_SOURCE_URL`
USE_LOCAL_SOURCE=`read_property USE_LOCAL_SOURCE`

# Grab everything after the last '/' character.
ARCHIVE_FILE=${DOWNLOAD_URL##*/}

if [ "$USE_LOCAL_SOURCE" = "true" -a ! -f $MAIN_SRC_DIR/source/overlay/$ARCHIVE_FILE ] ; then
  echo "Shell script '$MAIN_SRC_DIR/source/overlay/$ARCHIVE_FILE' is missing and will be downloaded."
  USE_LOCAL_SOURCE="false"
fi

cd $MAIN_SRC_DIR/source/overlay

if [ ! "$USE_LOCAL_SOURCE" = "true" -a ! -f $MAIN_SRC_DIR/source/overlay/$ARCHIVE_FILE ] ; then
  # Downloading e2fsprogs source. The '-c' option allows the download to resume.
  echo "Downloading e2fsprogs source from $DOWNLOAD_URL"
  wget -c $DOWNLOAD_URL
else
  echo "Using local e2fsprogs source bundle '$MAIN_SRC_DIR/source/overlay/$ARCHIVE_FILE'."
fi

# Delete folder with previously prepared e2fsprogs.
echo "Removing e2fsprogs work area. This may take a while."
rm -rf $WORK_DIR/overlay/$BUNDLE_NAME
mkdir $WORK_DIR/overlay/$BUNDLE_NAME

# Extract e2fsprogs to folder 'work/overlay/e2fsprogs'.
# Full path will be something like 'work/overlay/e2fsprogs-1.47.0'.
tar -xvf $ARCHIVE_FILE -C $WORK_DIR/overlay/$BUNDLE_NAME

cd $SRC_DIR
