#! /usr/bin/env sh

## input: input (bin), key (bin)
## output: key xor-ed input (bin)

## usage: echo 1100 | sh xor.sh --key 1100
## example: sh iv.sh -k 1111 1000


args="$@"
getargs ()
{
    while :; do

	case "$1" in

	    '' )
		break
		;;

	    --key | -k )
		## NOTICE arg can be a file
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

	    * )
		## NOTICE arg can be a file
		if [[ -f "$1" ]]; then

		    ## file content is read
		    input_arg=$(cat "$1")
		    shift

		else

		    ## argument is read
		    input_arg="$1"
		    shift

		fi
		;;

	esac

    done
}


getstdin ()
{
    if [[ -p /dev/stdin ]]; then

	input_stdin=$(cat)

    fi
}


synth_input ()
{
    ## stdin and arg are synthesized
    input_bin=$(tr -d '\n' <<< "${input_stdin}${input_arg}")
}


# perform xor operation between two strings
xor_chars ()
{
    # initialize xor_bin
    xor_bin=''

    ## number of characters in states_bin
    local input_l=${#input_bin}
    local key_l=${#key_bin}

    ## for every key_l characters in input_bin, ...
    for (( i=0; i<input_l; i+=key_l )); do

	## take a key_l chunk of input_bin
	local chunk=${input_bin:i:key_l}
	local chunk_l=${#chunk}

	## all chunks must be key_l bits long (for xor to work)
	## if last chunk is shorter than key_l;
	## delete least significant bits from key_bin
	if (( chunk_l < key_l )); then

	    ## number of redundant bits in (last) key_bin
	    key_bin_red_l=$(( key_l - chunk_l ))
	    ## correct (last) key_bin
	    key_bin="${key_bin:0:${#key_bin}-${key_bin_red_l}}"
	    ## correct (last) key length
	    key_l=${#key_bin}

	fi

	## ... perform bit by bit xor operation on chunk
	for (( b=0; b<key_l; b++ )); do

            # get individual bits
            local input_bit="${chunk:$b:1}"
            local key_bit="${key_bin:$b:1}"

            # xor the bits
            local xor_bit=$((input_bit ^ key_bit))

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
    xor_chars
    output
}

main
