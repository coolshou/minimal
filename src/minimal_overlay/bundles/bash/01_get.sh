#!/bin/sh

set -e

. ../../common.sh

# Read the common configuration properties.
DOWNLOAD_URL=`read_property BASH_CLI_URL`
USE_LOCAL_SOURCE=`read_property USE_LOCAL_SOURCE`

ARCHIVE_FILE=${DOWNLOAD_URL##*/}

if [ "$USE_LOCAL_SOURCE" = "true" -a ! -f $MAIN_SRC_DIR/source/overlay/$ARCHIVE_FILE ] ; then
  echo "Shell script '$MAIN_SRC_DIR/source/overlay/$ARCHIVE_FILE' is missing and will be downloaded."
  USE_LOCAL_SOURCE="false"
fi

cd $MAIN_SRC_DIR/source/overlay

if [ ! "$USE_LOCAL_SOURCE" = "true" ] ; then
  # Downloading bash . The '-c' option allows the download to resume.
  echo "Downloading bash from $DOWNLOAD_URL"
  wget -c $DOWNLOAD_URL
else
  echo "Using local bash '$MAIN_SRC_DIR/source/overlay/$ARCHIVE_FILE'."
fi

# Delete folder with previously prepared bash.
echo "Removing bash work area. This may take a while."
rm -rf $WORK_DIR/overlay/$BUNDLE_NAME
mkdir $WORK_DIR/overlay/$BUNDLE_NAME

# Copy bosh-cli to folder 'work/overlay/$ARCHIVE_FILE'.
tar -xvf $ARCHIVE_FILE -C $WORK_DIR/overlay/$BUNDLE_NAME

cd $SRC_DIR
