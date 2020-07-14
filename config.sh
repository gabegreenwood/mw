###########################################################################
# IMPORTANT: EDIT THE FIELDS BELOW TO MATCH YOUR SYSTEM
###########################################################################

# A device path pointing to the bitlocker-encrypted partition
# Replace <PARTUUID> with the UUID of the PARTITION (NOT the disk)
# that you are trying to decrypt, or another unique device identifier
# for that same partition
BITLOCKER_PARTITION='/dev/disk/by-partuuid/<PARTUUID>'

# Set this value to the path of your actual bash shell with -c flag
# An easy way to figure this path out is by running `which bash`
EXEC_SHELL='/usr/bin/bash -c'

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