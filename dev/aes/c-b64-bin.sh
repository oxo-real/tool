#! /usr/bin/env sh

## input: base64 encoded string
## output: binary string with 128 bits default line length

## usage: b642str dGVzdAo=
## or: echo -n dGVzdAo= | sh b642str.sh


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

		## line_l in bytes (for xxd)
		line_l=$(( line_l_arg / 8 ))
		;;

	    * )
		## script handles only one arg (which can be a file)
		if [[ -f "$1" ]]; then

		    ## file content is read
		    input_b64_arg=$(cat "$1")
		    shift

		else

		    ## first argument is read
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


bin_encode ()
{
    # hex_cap=$(printf '%s' "${(U)input_hex}")  ## zsh
    # hex_cap=$(printf '%s' "${input_hex^^}")  ## bash
    ## NOTICE byte-wise conversion (input_hex must contain whole bytes)
    output_bin="$(printf '%s' "$input_b64" | \
    xxd --bits --cols "$line_l" --group "$line_l" | \
    awk '{for(i=2;i<=NF-1;i++) printf "%s", $i; print ""}' | \
    tr ' ' '\n' \
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
