#! /usr/bin/env sh

## input: binary string
## output: 16 byte binary blocks (state)
## each line represents a block (128 bits or 32 hex chars)

## default length of each state in bits
state_l=128

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
		## state length in bits (default 128)
		shift
		state_l="${1:=128}"
		shift
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


fold_states ()
{
    output_states=$(echo -n "$input_bin" | fold --width "$state_l" --bytes)
    # output_states=$(echo -n "$input_bin" | fold --width "$state_l" --bytes)
}


output ()
{
    ## stdout
    printf '%s' "$output_states"
}


main ()
{
    getstdin
    getargs $args
    synth_input
    fold_states
    output
}

main
