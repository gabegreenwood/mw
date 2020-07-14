    ### We have to create a new encrypted keyfile.
    
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
