#!/usr/bin/bash

# Don't allow superuser to run this script
if [ "$EUID" -eq 0 ]; then
  echo "Please do not invoke this script with root priviliges."
  exit -1
fi

# load configuration
source config.sh
# load functions
source _functions.sh

# Exit if the decrypted filesystem is already mounted to our taret directory
if [ "`df -Th | grep fuseblk | grep $TARGET_MOUNT`" ]; then
    echo "fuseblk partition is already mounted at $TARGET_MOUNT"
    echo "Please check the contents of $TARGET_MOUNT; it should contain your data..."
    exit -2
fi

# Check for missing dependencies
$EXEC_SHELL _handle_dependencies.sh
ret=$?
if [ $ret < 0 ]; then
    echo "Aborting process early due to missing dependencies."
    exit $ret
fi

# Identify the bitlocker partition
$EXEC_SHELL _identify_partition.sh
exit_code=$?
if [ $exit_code -ne 0 ]; then
    exit $exit_code
fi

# execute the main program
$EXEC_SHELL _mount_windows.sh
exit_code=$?
    if [ $exit_code -ne 0 ]; then
        exit $exit_code
    fi
fi

# return successfully if no errors were encountered
exit 0
