#! /usr/bin/env sh

## input: string
## output: base64 of string

## usage: str2b64 test
## or: sh str2b64.sh filename
## or: echo -n test | sh str2b64.sh
## or even: echo -n test | sh str2b64.sh filename


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
		    input_str_arg=$(cat "$1")
		    shift

		else

		    # input_b64_args+="$1"
		    input_str_arg="$1"
		    shift

		fi
		;;

	esac

    done
}


getstdin ()
{
    if [[ -p /dev/stdin ]]; then

	input_str_stdin=$(cat)

    fi
}


synth_input ()
{
    ## stdin and arg are synthesized
    input_str="${input_str_stdin}${input_str_arg}"
}


# combine all arguments into a single base64 input string
base64_encode ()
{
    output_b64="$(printf '%s' "$input_str" | base64 --wrap 0)"
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
