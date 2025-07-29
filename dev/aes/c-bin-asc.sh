#! /usr/bin/env sh

## input: binary string
## output: ascii string

## usage: b642str dGVzdAo=
## or: echo -n dGVzdAo= | sh b642str.sh

## default chunk size is 8 bits (1 byte or 2 nibbles)
chunk_l=8

## check if an input string is provided
args="$@"
getargs ()
{
    while :; do

	case "$1" in

	    '' )
		break
		;;

	    * )
		## script handles only one arg (which can be a file)
		if [[ -f "$1" ]]; then

		    ## file content is read
		    input_bin_arg=$(cat "$1")
		    shift

		else

		    ## first argument is read
		    input_bin_arg="$1"
		    shift

		fi
		;;

	esac

    done
}


getstdin ()
{
    if [[ -p /dev/stdin ]]; then

	input_bin_stdin=$(cat)

    fi
}


synth_input ()
{
    ## stdin and arg are synthesized
    input_bin="${input_bin_stdin}${input_bin_arg}"
}


bin_decode ()
{
    output_asc="$(printf '%s' "$input_bin" | \
        awk -v slice="$chunk_l"	'{
    	    binary = $0
    	    bin_l = length(binary)

	    	for (i = 1; i <= bin_l; i += slice) {

	      	    byte = substr(binary, i, slice)
		    decimal = 0

		    for (j = 1; j <= length(byte); j++) {

		    	decimal = decimal * 2 + (substr(byte, j, 1) == "1")
			}

			printf "%c", decimal
	    		}

    	    print ""
    	}'
    )"
}


output ()
{
    ## stdout
    printf '%s' "$output_asc"
}


main ()
{
    getstdin
    getargs $args
    synth_input
    bin_decode
    output
}

main
