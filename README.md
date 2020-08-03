# MW

## mw == 'Mount Windows': a bash script to automate the process of decrypting and mounting a bitlocker-encrypted Windows partition while running Linux in a dual-boot environment

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

#### Upcoming development tasks:
- Full unit testing
- Support for AES-XTS encryption algorithm available with newer versions of Windows 10
