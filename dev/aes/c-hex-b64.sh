#! /usr/bin/env sh

## input: ascii hex string
## output: base64 code

## usage: b642str dGVzdAo=
## or: echo -n dGVzdAo= | sh b642str.sh


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
		    input_hex_arg=$(cat "$1")
		    shift

		else

		    # input_b64_args+="$1"
		    input_hex_arg="$1"
		    shift

		fi
		;;

	esac

    done
}


getstdin ()
{
    if [[ -p /dev/stdin ]]; then

	input_hex_stdin=$(cat)

    fi
}


synth_input ()
{
    ## stdin and arg are synthesized
    input_hex="${input_hex_stdin}${input_hex_arg}"
}


b64_encode ()
{
    output_b64="$(printf '%s' "$input_hex" | xxd --plain --revert)"
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
    b64_encode
    output
}

main
