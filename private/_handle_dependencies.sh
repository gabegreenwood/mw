# First make sure we can check for other programs
check_for_program which
exitcode=$?
if [ $exitcode -ne 0 ]; then
    exit $exitcode
fi

# Check if dislocker is installed
check_for_program dislocker
if [ $? -ne 0]; then
    echo "Please install dislocker utility and try again."
    echo "Note: It is highly recommended you use the latest version of dislocker."
    echo "      Even if dislocker is available from your package manager, you"
    echo "      may want to consider building the latest version from source."
    echo "      For details and instructions, please visit https://github.com/Aorimn/dislocker"
    exit -1
fi

# Check for any other dependencies listed in config
validate_dependencies $DEPENDENCIES
missing=$?
if [ $missing -ne 0 ]; then
    echo "Error: $missing missing dependencies."
    echo 'Please make sure the above packages are installed and accessible on your $PATH.'
    error_code=( -1 * $missing )
    exit $error_code
fi
exit 0
