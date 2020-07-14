###########################################################################
# Only edit the following entries if you have a very good reason
###########################################################################

# Private directory in user's home folder to hold back end files
LOCKER_DIRECTORY="/home/$LOGNAME/.bitlocker"

# The directory passed to dislocker which will serve as a mountpoint
# for the mapped decryption target dislocker will create when called
FUSE_TARGET="$LOCKER_DIRECTORY/fusemount"

# The directory to which your decrypted system will ultimately be mounted
TARGET_MOUNT="/home/$LOGNAME/windows"

# The encrypted file we will use to store your bitlocker recovery key
BITLOCKER_KEYFILE="$LOCKER_DIRECTORY/salt.gpg"

# The filepath of the mountable decryption object to be created by dislocker
DISLOCKER_FILE="$FUSE_TARGET/dislocker-file"

DEPENDENCIES="ntfs-3g gdisk gnupg bash shred"

RUNTIME_ROOT_DIR=/home/g/code/mw
RUNTIME_ROOT_DIR=/home/g/code/mw
RUNTIME_ROOT_DIR=/home/g/code/mw
