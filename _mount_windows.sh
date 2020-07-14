#!/bin/bash
# Script to mount a Bitlocker encrypted Windows partition on a linux
# system by wrapping the dislocker utilitiy ( https://github.com/Aorimn/dislocker )

LOCKER_DIRECTORY="/home/$LOGNAME/.bitlocker"
FUSE_TARGET="$LOCKER_DIRECTORY/fusemount"
TARGET_MOUNT="/home/$LOGNAME/windows"
BITLOCKER_PARTITION='/dev/disk/by-partuuid/e28edf4e-f932-4f26-aa69-4e76e1cd4491'
BITLOCKER_KEYFILE="$LOCKER_DIRECTORY/salt.gpg"
DISLOCKER_FILE="$FUSE_TARGET/dislocker-file"

# This script should never be run as root.
# So, it's the first thing we check for:
if [ "$EUID" -eq 0 ]; then
  echo "Please do not invoke this script with root priviliges."
  echo "Halting execution early: no files have been changed"
  exit -1
fi

# Exit if the mount already exists
if [ "`df -Th | grep fuseblk | grep $TARGET_MOUNT`" ]; then
    echo "fuseblk partition is already mounted at $TARGET_MOUNT"
    echo "Aborting"
    exit -4
fi

echo '***************************************************************************'  
echo 'MOUNTING BITLOCKER ENCRYPTED WINDOWS PARTITION TO *NIX VIRTUAL FILESYSTEM'
echo '***************************************************************************'  


# Create directories if necessary
if [ ! -d $LOCKER_DIRECTORY ]; then
    echo "Creating directory $LOCKER_DIRECTORY"
    mkdir $LOCKER_DIRECTORY
    chown $LOGNAME:$LOGNAME $LOCKER_DIRECTORY
    chmod 750 $LOCKER_DIRECTORY
fi
if [ ! -d $FUSE_TARGET ]; then
    echo "Creating directory $FUSE_TARGET"
    mkdir $FUSE_TARGET
    chown $LOGNAME:$LOGNAME $FUSE_TARGET
    chmod 750 $FUSE_TARGET
fi
if [ ! -d $TARGET_MOUNT ]; then
    echo "Creating directory $TARGET_MOUNT"
    mkdir $TARGET_MOUNT
    chown $LOGNAME:$LOGNAME $TARGET_MOUNT
    chmod 750 $TARGET_MOUNT
fi

# Check if dislocker is installed
which dislocker > /dev/null 2>&1
dislocker_installed=$?
if [ $dislocker_installed -ne 0 ]; then
    echo "Please install dislocker utility and run this script again"
    exit -2
fi

# If we don't have an encrypted bitlocker keyfile to read from,
# create one now.
if [ ! -f $BITLOCKER_KEYFILE ]; then
    # Make sure gpg is installed
    which gpg > /dev/null 2>&1
    gpg_installed=$?
    if [ $gpg_installed -ne 0 ]; then
        echo "Please install gnupg utility and run this script again"
        exit -3
    fi
    
    # Make sure loopback pinentry is allowed by gnupg
    GPG_CONF="/home/$LOGNAME/.gnupg/gpg-agent.conf"
    if [ ! -f $GPG_CONF ]; then
	touch $GPG_CONF
        chmod 600 $GPG_CONF
    fi
    param='allow-loopback-pinentry'
    found=$(cat $GPG_CONF | grep $param)
    if [ ! $found ]; then
        echo $param >> $GPG_CONF
        echo "Reloading gpg agent..."
        gpg-connect-agent reloadagent /bye
    fi
    
    # Capture Bitlocker recovery keys
    echo "We will now create a password-encrypted file to securely store your bitlocker recovery key."
    echo "Please enter your BITLOCKER RECOVERY KEY now:"
    read BITLOCKER_KEY
    echo "Please enter the key again to confirm:"
    read BITLOCKER_KEY_2
    while [ $BITLOCKER_KEY != $BITLOCKER_KEY_2 ]; do
	echo "Keys do not match. Please enter key again:"
	read BITLOCKER_KEY
	echo "Please enter key again to confirm accuracy:"
	read BITLOCKER_KEY_2
    done
    unset BITLOCKER_KEY_2
    
    # Capture password to encrypt the keyfile
    echo "Now, please enter a secure passphrase to encrypt your bitlocker keys with:"
    read -s PW
    echo "Please enter password again to confirm:"
    read -s PW2
    while [ $PW != $PW2 ]; do
	    echo "Passwords do not match. Please enter a secure password:"
	    read -s PW
	    echo "Enter again to confirm:"
	    read -s PW
    done 
    unset PW2
    
    # Encrypt the keys using the password and store them in our ~/.bitlocker directory
    echo "Encrypting bitlocker keys using gpg. Please enter a secure password when prompted..."
    tmp_keyfile=$(mktemp)
    chmod 600 $tmp_keyfile
    echo $BITLOCKER_KEY > $tmp_keyfile
    echo "$PW" | gpg --yes --batch --output $tmp_keyfile.gpg --passphrase-fd 0 -c $tmp_keyfile
    gpg_ret_code=$?
    shred -n 7 -uz $tmp_keyfile
    unset BITLOCKER_KEY
    if [ $gpg_ret_code -ne 0 ]; then
        echo "gpg exited abnormally with error code $gpg_ret_code"
        echo "Aborting process"
        if [ -f $tmp_keyfile.gpg ]; then
            rm -f $tmp_keyfile.gpg
        fi
        exit -6
    fi        
    mv $tmp_keyfile.gpg $BITLOCKER_KEYFILE
fi

# Read in decryption password (if we didn't just do that a minute ago)
if [ ! $PW ]; then
    echo "Please enter passphrase to decrypt bitlocker keys:"
    read -s PW
fi

# Decrypt keyfile
echo "Decrypting bitlocker keyfile..."
KEY=$(echo $PW | gpg --yes --batch --passphrase-fd 0 --decrypt $BITLOCKER_KEYFILE)
gpg_ret_code=$?
unset PW
if [ $gpg_ret_code -ne 0  ]; then
	echo "Please check your password and try again."
	exit $gpg_ret_code
fi

echo "Flushing gpg agent cached passwords..."
gpg-connect-agent reloadagent /bye

# Create fuseblk entry point to provide decrypted access to bitlocker partition
echo "Decrypting bitlocker partition..."
sudo dislocker-fuse -v -V $BITLOCKER_PARTITION -p$KEY -- $FUSE_TARGET
DISLOCKER_EXIT_CODE=$?
unset KEY
if [ $DISLOCKER_EXIT_CODE -eq 0 ]; then
    # Mount the fuseblk object to a directory for easy access
    echo "Mounting decrypted bitlocker partition..."
    sudo mount $DISLOCKER_FILE $TARGET_MOUNT
    mount_ret_code=$?
    if [ $mount_ret_code -eq 0  ]; then
	    echo "Decrypted bitlocker partition is now available at the following path:"
	    echo $TARGET_MOUNT
    else
	    echo "Mount attempt failed with exit code $mount_ret_code"
	    exit -7
    fi
else
    echo "Bitlocker decryption failed. Aborting"
    exit -5
fi

exit 0

