#! /usr/bin/env sh

## input: ascii
## output: binary

## usage
## sh c-asc-bin.sh [--length 128] $file
## echo -n "$ascii" | sh c-asc-bin.sh

## NOTICE length in bits
##        when given; length must be multiple of 8 (8 bit = 1 byte)

## examples:
## sh c-asc-bin.sh --length 128 $file  ## default 128 bit line length
## echo -n dGVzdAo= | sh c-asc-bin.sh --length 8  ## custom 8 bit length


## default line length (16 bytes = 128 bit)
line_l=16


## check if an input string is provided
args="$@"
getargs ()
{
    while :; do

	case "$1" in

	    '' )
		break
		;;

	    --length | -l )
		## line length in bits (default 128 bit)
		shift
		line_l_arg="${1:=128}"
		shift

		## line_l in bytes (for xxd) (default is 16 bytes)
		line_l=$(( line_l_arg / 8 ))
		;;

	    * )
		## script handles only one arg (which can be a file)
		if [[ -f "$1" ]]; then

		    ## file content is read
		    input_asc_arg=$(cat "$1")
		    shift

		else

		    ## first argument is read
		    input_asc_arg="$1"
		    shift

		fi
		;;

	esac

    done
}


getstdin ()
{
    if [[ -p /dev/stdin ]]; then

	input_asc_stdin=$(cat)

    fi
}


synth_input ()
{
    ## stdin and arg are synthesized
    input_asc="${input_asc_stdin}${input_asc_arg}"
}


bin_encode ()
{
    output_bin="$(printf '%s' "$input_asc" | \
    xxd --bits --cols "$line_l" --groupsize "$line_l" | \
    ## CAUTION awk prints second column only
    ## therefore no spaces in the xxd bitgroups
    ## and always have xxd columns = xxd groupsize (1 bitstring)
    awk '{print $2}'
    ## this awk prints column 2 until second to last column
    ## by skipping first (i=2) and last (i<=NF-1)
    # awk '{

    # 	for ( i=2; i<=NF-1; i++ ) {

    # 	    printf "%s", $i
    # 	    }

    # 	print ""
    # }'
    )"
}


output ()
{
    ## stdout
    printf '%s' "$output_bin"
}


main ()
{
    getstdin
    getargs $args
    synth_input
    bin_encode
    output
}

main
