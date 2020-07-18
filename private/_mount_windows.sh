source $RUNTIME_ROOT_DIR/private/_functions.sh

echo '***************************************************************************'  
echo 'MOUNTING BITLOCKER ENCRYPTED WINDOWS PARTITION TO *NIX VIRTUAL FILESYSTEM'
echo '***************************************************************************'  

# Read in decryption password (if we didn't just do that a minute ago during keyfile init)
if [ ! $PW ]; then
    echo "Please enter passphrase to decrypt bitlocker keys:"
    read -s PW
fi

# Decrypt keyfile
echo "Decrypting bitlocker keyfile..."
bitlocker_key=$(echo $PW | gpg --yes --batch --passphrase-fd 0 --decrypt $BITLOCKER_KEYFILE)
exitcode=$?
unset PW
if [ $exitcode -ne 0  ]; then
	echo "Please check your password and try again."
	exit $exitcode
fi

echo "Flushing gpg cache..."
gpg-connect-agent reloadagent /bye

# Create fuseblk entry point to provide decrypted access to bitlocker partition
echo "Decrypting bitlocker partition..."
sudo dislocker-fuse -v -V $BITLOCKER_PARTITION -p$bitlocker_key -- $FUSE_TARGET
exitcode=$?
unset bitlocker_key
if [ $exitcode -eq 0 ]; then
    # Mount the fuseblk object to a directory for easy access
    echo "Mounting decrypted bitlocker partition:"
    cmd="sudo mount -t ntfs -o utf8 uid=$LOGNAME gid=$LOGNAME umask=000 $DISLOCKER_FILE $TARGET_MOUNT"
    echo $cmd
    $cmd
    exitcode=$?
    if [ $exitcode -eq 0  ]; then
	    echo "Decrypted bitlocker partition is now available at the following path:"
	    echo $TARGET_MOUNT
    else
	    echo "Mount attempt failed with exit code $exitcode"
        sudo umount -l $FUSE_TARGET
	    exit $exitcode
    fi
else
    sudo umount -l $FUSE_TARGET
    echo "Bitlocker decryption failed. Aborting"
    exit $exitcode
fi

exit 0

