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
    key_input=$(tr -d '\n' <<< "${input_stdin}${input_arg}")
}


key_analysis ()
{
    ## key format
    ## make hexadecimal or ascii keys binary
    case "$key_format" in

	asc )
	    key_bin=$(printf '%s' "$key_input" | sh c-asc-bin.sh)
	    ;;

	hex )
	    key_bin=$(printf '%s' "$key_input" | sh c-hex-bin.sh)
	    ;;

	* )
	    key_bin="$key_input"

    esac

    # key length
    key_bin_l=${#key_bin}

    case $key_bin_l in

	128 )
	    cols=4
	    rounds=11
	    ;;

	192 )
	    cols=6
	    rounds=13
	    ;;

	256 )
	    cols=8
	    rounds=15
	    ;;

    esac
}


create_words_arr ()
{
    words_arr=()

    # fill array with 8-bit binary values from key_bin
    for (( row=0; row<4; row++ )); do

	for (( col=0; col<"${cols}"; col++ )); do

            index=$(( row * "${cols}" + col ))

            current_byte="${key_bin:$(( index * 8 )):8}"

            words_arr[$index]=$current_byte

	done

    done
}


get_word ()
{
    local row=$1
    local col=$2

    echo ${words_arr[$(( row * "${cols}" + col))]}

    # printf '%s ' "${words_arr[$row,$col]}"
}


output_matrix ()
{
    ## print the entire array
    for (( row=0; row<4; row++ )); do

	for (( col=0; col<"${cols}"; col++ )); do

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
    key_analysis
    create_words_arr
    output_matrix
}

main
