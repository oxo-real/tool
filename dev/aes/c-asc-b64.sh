#! /usr/bin/env sh

## input: ascii
## output: base64


## usage: sh c-asc-b64.sh test.file
## or: echo hello | sh c-asc-b64.sh


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
		## NOTICE script handles only one arg (which can be a file)
		if [[ -f "$1" ]]; then

		    ## file content is read
		    input_asc_arg=$(cat "$1")
		    shift

		else

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


base64_encode ()
{
    output_b64="$(printf '%s' "$input_asc" | base64 --wrap 0)"
}


output ()
{
    ## stdout
    printf '%s' "$output_b64"
}


main ()
{
    getstdin
    getargs $args
    synth_input
    base64_encode
    output
}

main
