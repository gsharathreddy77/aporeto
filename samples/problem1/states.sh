#!/bin/bash

# shows the usage of this script on the screen
function show_help 
{
	echo "Usage:"
	echo "./test.sh --create-file=<filename> [--no-prompt] [--verbose]"
	echo "./test.sh [--help|-h]"
	echo "where:"
    echo "--help|-h			prints the help message"
    echo "--create-file=			is the output file location"
    echo "--no-prompt			No prompt if the given file exists"
	echo "--verbose			Verbose"
}

#checks the exit code and prints appropriate messages when we overwrite a new file
function success_func 
{
	if [ $? -eq 0 ]
	then
		if [ $verbose -gt 0 ]; then
			echo "Removed the file"
			echo "Successfully created file"
		fi  
	else
		if [ $verbose -gt 0 ]; then
			echo "Error occured in overwriting the file" >&2
		fi
	fi
}

#checks the exit code and prints appropriate messages when we create a new file
function success_func 
{
	if [ $? -eq 0 ]
	then
		if [ $verbose -gt 0 ]; then
			echo "Successfully created file"
		fi  
	else
		if [ $verbose -gt 0 ]; then
			echo "Error occured in writing to file" >&2
		fi
	fi
}
# Reset all variables that might be set
file=
verbose=0
noPrompt=0

# Parse all the command line arguments
while :; do
    case $1 in
		
        -h|--help)   # Call a "show_help" function to display a synopsis, then exit.
            show_help
            exit
            ;;
        --no-prompt)
			noPrompt=$((noPrompt + 1))
			;;
        --create-file=?*)
            file=${1#*=} # Delete everything up to "=" and assign the remainder.
            ;;
        --create-file=)         # Handle the case of an empty --create-file=
            printf 'ERROR: "--create-file" requires a non-empty filename argument.\n' >&2
            exit 1
            ;;
        --verbose)
            verbose=$((verbose + 1)) # Each -v argument adds 1 to verbosity.
            ;;
        --)              # End of all options.
            shift
            break
            ;;
        ?*)
            printf 'ERROR: Unknown option given: %s\n' "$1" >&2
            show_help
            exit
            ;;
        *)               # Default case: If no more options then break out of the loop.
            break
    esac

    shift
done


declare -a states=('Alabama' 'Alaska' 'Arizona' 'Arkansas' 'California' 'Colorado' 'Connecticut' 'Delaware' 'Florida' 'Georgia' 'Hawaii' 'Idaho' 'Illinois' 'Indiana' 'Iowa' 'Kansas' 'Kentucky' 'Louisiana' 'Maine' 'Maryland' 'Massachusetts' 'Michigan' 'Minnesota' 'Mississippi' 'Missouri' 'Montana' 'Nebraska' 'Nevada' 'New Hampshire' 'New Jersey' 'New Mexico' 'New York' 'North Carolina' 'North Dakota' 'Ohio' 'Oklahoma' 'Oregon' 'Pennsylvania' 'Rhode Island' 'South Carolina' 'South Dakota' 'Tennessee' 'Texas' 'Utah' 'Vermont' 'Virginia' 'Washington' 'West Virginia' 'Wisconsin' 'Wyoming');

#if the file name is not empty
if [ -n "$file" ]; then
	if [ -f "$file" -a -w "$file" ]; then	#file is a regular file and is writable
		if [ $noPrompt -lt 1 ]; then
			option="e"
			until [ $option = "y" -o $option = "n" ]
			do
				echo -n "File already exists. Overwrite(y/n)?"
				read option
			done
			if [ $option = "y" ]; then
				printf "%s\n" "${states[@]}" > $file
				success_overwrite
			fi
		else
			if [ $verbose -gt 0 ]; then
				echo "File Already Exists."
			fi
		fi
	else
		if [ -f "$file" ]; then			#file is a regular file and it is not writbale
			if [ $verbose -gt 0 ]; then
				echo "File already exists but it is not writable"
			fi
		else
			printf "%s\n" "${states[@]}" > $file
			success_func
		fi
	fi
else
	echo "--create-file option is missing"
	show_help
fi

