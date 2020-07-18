# Check for program using `which` command.
missing_dependencies=0
check_for_program ()
{
    if [ $# -ne 1 ]; then
        echo "ERROR: $0 expects 1 and only 1 argument"
        exit -1
    fi
    prog=$1
    which $prog > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "ERROR: executable $prog not found"
        ((missing_dependencies++))
    fi
}

# First make sure we can check for other programs
check_for_program which
if [ $missing_dependencies -ne 0 ]; then
    echo "Error: please install the `which` program on your system and try again."
    exit -1
fi

# Check if dislocker is installed
check_for_program dislocker
if [ $missing_dependencies -ne 0 ]; then
    echo "Please install dislocker utility and try again."
    echo "Note: It is highly recommended you use the latest version of dislocker."
    echo "      Even if dislocker is available from your package manager, you"
    echo "      may want to consider building the latest version from source."
    echo "      For details and instructions, please visit https://github.com/Aorimn/dislocker"
    exit -1
fi

# Check for any other dependencies listed in config
for program in $DEPENDENCIES; do
    check_for_program $program
done
exit $missing_dependencies
