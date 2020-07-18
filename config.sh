###########################################################################
# IMPORTANT: EDIT THE FIELDS BELOW TO MATCH YOUR SYSTEM
###########################################################################

# A device path pointing to the bitlocker-encrypted partition
# Replace <PARTUUID> with the UUID of the PARTITION (NOT the disk)
# that you are trying to decrypt, or another unique device identifier
# for that same partition
export BITLOCKER_PARTITION='/dev/disk/by-partuuid/<PARTUUID>'

# Set this value to the path of your actual bash shell with -c flag
# An easy way to figure this path out is by running `which bash`
export EXEC_SHELL='/usr/bin/bash -c'

# Make sure this is the directory where you want to store the link
# to the executable
export BIN_PATH='/usr/local/bin'

# Runtime root directory. This should be someplace accessible
# by the user who will be running the program, and it should
# be located on a filesystem mounted with execute permission.
export RUNTIME_ROOT_DIR="/opt/$USER/src/mw"
