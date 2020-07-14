# Private directory in user's home folder to hold back end files
LOCKER_DIRECTORY="/home/$LOGNAME/.bitlocker"

# The directory passed to dislocker which will serve as a mountpoint
# for the mapped decryption target dislocker will create when called
FUSE_TARGET="$LOCKER_DIRECTORY/fusemount"

# The directory to which your decrypted system will ultimately be mounted
TARGET_MOUNT="/home/$LOGNAME/windows"

# A device path pointing to the bitlocker-encrypted partition (note: PARTITION, not disk)
BITLOCKER_PARTITION='/dev/disk/by-partuuid/e28edf4e-f932-4f26-aa69-4e76e1cd4491'

# The encrypted file we will use to store your bitlocker recovery key
BITLOCKER_KEYFILE="$LOCKER_DIRECTORY/salt.gpg"

# The filepath of the mountable decryption object to be created by dislocker
DISLOCKER_FILE="$FUSE_TARGET/dislocker-file