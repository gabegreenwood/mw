#!/usr/bin/bash

function ask_yes_no {
    while true; do
    read -p "$1" yn
    case $yn in
        [Yy]* ) $2; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
}


echo '***************************************************************************' 
echo 'UNINSTALLING `mw` UTILITY'
echo '***************************************************************************' 

source ./config.sh
source ./private/_config.sh

echo "Removing runtime directory..."
sudo rm -rf $RUNTIME_ROOT_DIR

echo "Removing symlink to executable script..."
sudo rm -f $BIN_PATH/mw

if [ `df -Th | grep $TARGET_MOUNT` ]; then
    echo "Attempting to unmount $TARGET_MOUNT"
    sudo umount -l $TARGET_MOUNT
fi

if [ -f "$DISLOCKER_FILE" ]; then
    echo "Attempting unmount of dislocker file" 
    sudo umount -l $DISLOCKER_FILE
fi

if [ -d "$LOCKER_DIRECTORY" ]; then
    ask_yes_no "Remove entire directory $LOCKER_DIRECTORY including any \
    encrypted keyfiles? " "sudo rm -rf $LOCKER_DIRECTORY"
fi

echo "Uninstallation Complete"
exit 0


