#!/bin/sh

set -e

. ../../common.sh

# Read the common configuration properties.
DOWNLOAD_URL=`read_property REISER4PROGS_SOURCE_URL`
USE_LOCAL_SOURCE=`read_property USE_LOCAL_SOURCE`

# Grab everything after the last '/' character.
ARCHIVE_FILE=${DOWNLOAD_URL##*/}

if [ "$USE_LOCAL_SOURCE" = "true" -a ! -f $MAIN_SRC_DIR/source/overlay/$ARCHIVE_FILE ] ; then
  echo "Shell script '$MAIN_SRC_DIR/source/overlay/$ARCHIVE_FILE' is missing and will be downloaded."
  USE_LOCAL_SOURCE="false"
fi

cd $MAIN_SRC_DIR/source/overlay

if [ ! "$USE_LOCAL_SOURCE" = "true" -a ! -f $MAIN_SRC_DIR/source/overlay/$ARCHIVE_FILE ] ; then
  # Downloading reiser4progs source. The '-c' option allows the download to resume.
  echo "Downloading reiser4progs source from $DOWNLOAD_URL"
  wget -c $DOWNLOAD_URL
else
  echo "Using local reiser4progs source bundle '$MAIN_SRC_DIR/source/overlay/$ARCHIVE_FILE'."
fi

# Delete folder with previously prepared reiser4progs.
echo "Removing reiser4progs work area. This may take a while."
rm -rf $WORK_DIR/overlay/$BUNDLE_NAME
mkdir $WORK_DIR/overlay/$BUNDLE_NAME

# Extract reiser4progs to folder 'work/overlay/reiser4progs'.
# Full path will be something like 'work/overlay/reiser4progs-0.3.27'.
tar -xvf $ARCHIVE_FILE -C $WORK_DIR/overlay/$BUNDLE_NAME

cd $SRC_DIR
