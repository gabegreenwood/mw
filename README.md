# mw

## mw == 'Mount Windows'

#### This is a wrapper for [dislocker] (https://github.com/Aorimn/dislocker), written in Bash, that securely automates the process of decrypting and mounting a bitlocker-encrypted Windows partition on Linux. In a dual-boot environment, it conveniently allows you to access files from your Windows filesystm while running Linux, even if your Windows partition is encrypted using Bitlocker. The core decryption functionality is handled by dislocker. This utility simply automates the task of securely storing your bitlocker keys in a password protected, gnupg-encrypted file, and decrypting them on demand in order to mount the Bitlocker partition with minimal user effort.

### INSTALLATION
`cd /opt/build` [ optional: can be any directory you have rwx permissions for, e.g. /home/$USER ]  
`git clone https://github.com/gabegreenwood/mw && cd mw`
`./install.sh`

### USAGE
`mw`

### UNINSTALLATION
`mw --uninstall`

### DISCLAIMER
This is a new project that is not yet code-complete, and has only been tested using Bitlocker "backwards compatibility" encryption on Windows 10, with decryption on Ubuntu Desktop 20.04 LTS. 

### TODO
- Implement code-complete unit testing
- Support for AES-XTS encryption algorithm available with newer versions of Windows 10
