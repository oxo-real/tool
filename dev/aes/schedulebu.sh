#! /usr/bin/env sh

## input: key (bin)
## output: key-schedule (bin)
## 128 bits key > 11 round keys
## 192 bits key > 13 round keys
## 256 bits key > 15 round keys

## usage: key-schedule key.bin
## or: echo $key | key-schedule


## check if an input string is provided
args="$@"
getargs ()
{
    while :; do

	case "$1" in

	    '' )
		break
		;;

	    --hex-key )
		key_format=hex
		shift
		:
		;;

	    --asc-key )
		key_format=asc
		shift
		:
		;;

#TODO if key is ascii or hex convert to bin
	    --bin-key )
		key_format=bin
		shift
		:
		;;

	    * )
		## default key_format if not specified
		[[ -n "key_format" ]] || key_format=bin

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
    key_bin=$(tr -d '\n' <<< "${input_stdin}${input_arg}")
}


key_analysis ()
{
    ## key format
    case "$key_format" in
	-ne 'bin' ]]; then

	case
    # key length
}
create_words_arr ()
{
    ## create a 4x4 array (2D array) to hold 8-bit values from the 128 bit key
    words_arr=()

    # Fill the 4x4 array with 8-bit binary values
    for (( row=0; row<4; row++ )); do

	for (( col=0; col<4; col++ )); do

            index=$(( row * 4 + col ))

            current_byte="${key_bin:$(( index * 8 )):8}"

            ## assign the current byte to the 4x4 array
            words_arr[$index]=$current_byte
            # words_arr[$row,$col]=$current_byte

	done

    done
}


get_word ()
{
    local row=$1
    local col=$2

    echo ${words_arr[$(( row * 4 + col))]}

    # printf '%s ' "${words_arr[$row,$col]}"
}


output_matrix ()
{
    # Print the 4x4 array
    for (( row=0; row<4; row++ )); do

	for (( col=0; col<4; col++ )); do

	    # echo $row,$col,$current_byte,${words_arr[$row,$col]}
            printf '%s ' "$(get_word $row $col)"

	done

	echo

    done
}


main ()
{
    getstdin
    getargs $args
    synth_input
    create_words_arr
    output_matrix
}

main
