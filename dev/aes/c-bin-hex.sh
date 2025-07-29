#! /usr/bin/env sh

## input: binary string
## output: hex string

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


#TODO remove padding if if exists (if after end of a 8 bit block there are only zeros, then remove these zeros becasue they are padding)


hex_encode ()
{
    # hex_cap=$(printf '%s' "${(U)input_hex}")  ## zsh
    # hex_cap=$(printf '%s' "${input_hex^^}")  ## bash
    ## NOTICE byte-wise conversion (input_hex must contain whole bytes)
    # input_dec=$(( 2#input_bin ))
    # output_hex="$(printf '%X' $input_dec)"
    # output_hex="$(echo "obase=16; ibase=02; $(echo ${(U)}hex})" | bc)"
    output_hex="$(printf 'obase=%s; ibase=%s; %s\n' 16 02 "${input_bin}" | bc)"
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
