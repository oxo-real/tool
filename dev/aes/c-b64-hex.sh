#! /usr/bin/env sh

## input: base64 string
## output: ascii hex

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
		    input_b64_arg=$(cat "$1")
		    shift

		else

		    # input_b64_args+="$1"
		    input_b64_arg="$1"
		    shift

		fi
		;;

	esac

    done
}


getstdin ()
{
    if [[ -p /dev/stdin ]]; then

	input_b64_stdin=$(cat)

    fi
}


synth_input ()
{
    ## stdin and arg are synthesized
    input_b64="${input_b64_stdin}${input_b64_arg}"
}


hex_encode ()
{
    output_hex="$(printf '%s' "$input_b64" | xxd --plain)"
}


output ()
{
    ## stdout
    printf '%s' "$output_hex"
}


main ()
{
    getstdin
    getargs $args
    synth_input
    hex_encode
    output
}

main
