#! /usr/bin/env sh

## input: state, key
## output: xor-ed state

## where a state is a binary string folded to 128 bit long lines
## like the output of states.sh

## usage: sh xor.sh --key $key_128_bit_bin $state


## conversion order (up or down):
## str; i.e. '1A-☯'
## b64; i.e. 'MUEt4piv'
## hex; i.e. '4d55457434706976'
## bin; i.e. '0100110101010101010001010111010000110100011100000110100101110110'

## default values
## key length in bits
key_l=128


## check if an input string is provided
args="$@"
getargs ()
{
    while :; do

	case "$1" in

	    '' )
		break
		;;

	    --key | -k )
		## script handles only one arg (which can be a file)
		shift

		if [[ -f "$1" ]]; then

		    ## file content is read
		    key_bin=$(cat "$1")
		    shift

		else

		    ## argument is read
		    key_bin="$1"
		    shift

		fi
		;;

	    --length | -l )
		## key length in bits (default 128)
		shift
		key_l="${1:=128}"
		shift
		;;

	    * )
		## script handles only one arg (which can be a file)
		if [[ -f "$1" ]]; then

		    ## file content is read
		    input_states_arg=$(cat "$1")
		    shift

		else

		    ## argument is read
		    input_states_arg="$1"
		    shift

		fi
		;;

	esac

    done
}


getstdin ()
{
    if [[ -p /dev/stdin ]]; then

	input_states_stdin=$(cat)

    fi
}


synth_input ()
{
    ## stdin and arg are synthesized
    input_states_bin="${input_states_stdin}${input_states_arg}"
}


# perform xor operation between two strings
xor_lines ()
{
    # initialize xor_bin
    xor_bin=''

    ## number of lines in states_bin
    local input_states_bin_lines=$(wc -l <<< $input_states_bin)
    # local key_bin_l=${#key_bin}

    ## for every line in states
    for ((i=0; i<input_states_bin_lines; i++)); do

	## current line binary
	s=$((i+1))  ## for sed
	local input_states_bin_curr_line=$(sed -n "${s}p" <<< "$input_states_bin")
	# local input_states_bin_curr_line=$(sed "${i}q;d" <<< "$input_states_bin")

	## number of characters in current line
	local input_states_bin_curr_line_l=${#input_states_bin_curr_line}

	## all states (lines) must be key_l bits long (for xor to work)
	## last line can be shorter; then we add padding

	if [[ "$i" -eq "$input_states_bin_lines" ]]; then

	    ## last line
	    if (( input_state_bin_curr_line_l < key_l )); then

		## state is shorter than key length
		## printf pads with spaces until key length is met
		local input_states_bin_curr_line=$(printf "%-${key_l}s" "$input_states_bin_curr_line")
		## replace added spaces with 0's
		local input_states_bin_curr_line="${input_states_bin_curr_line// /0}"

	    fi

	fi

	## rename input_states_bin_curr_line to state_bin
	local state_bin="$input_states_bin_curr_line"

	# perform bit by bit xor operation
	for ((b=0; b<key_l; b++)); do
	    # for (( i=0; i<input_states_bin_l; i++ )); do

            # get individual bits
            local state_bit="${state_bin:$b:1}"
            local key_bit="${key_bin:$b:1}"

            # xor the bits
            local xor_bit=$((state_bit ^ key_bit))

            # append to result
            xor_bin+="$xor_bit"

	done

    done
}


output ()
{
    ## stdout
    printf '%s' "$xor_bin"
}


main ()
{
    getstdin
    getargs $args
    synth_input
    xor_lines
    output
}

main
