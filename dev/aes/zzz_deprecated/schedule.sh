#! /usr/bin/env sh

## input: key (bin)
## output: key-schedule (bin)

## usage: key-schedule key.bin
## or: echo $key | key-schedule

# words_arr=()
# declare -A words_arr
# typeset -A words_arr
## TODO DEV why does this not work?
## LEARN always initalize array in global scope (main body)
## (not inside functions)

typeset -A words_arr

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
	    rows=4
	    cols=4
	    col_l=8
	    subkeys=11
	    ;;

	192 )
	    rows=4
	    cols=6
	    col_l=8
	    subkeys=13
	    ;;

	256 )
	    rows=4
	    cols=8
	    col_l=8
	    subkeys=15
	    ;;

    esac
}


create_words_arr ()
{
    subkey="$1"
    index=0

    ## array fills first columns then rows
    for (( col=0; col<"${cols}"; col++ )); do

	for (( row=0; row<"${rows}"; row++ )); do

            words_arr[$subkey,$row,$col]="${key_bin:$(( index * $col_l )):$col_l}"

	    ((index++))

	done

    done
}


generate_subkeys ()
{
    for (( subkey=0; subkey<"${subkeys}"; subkey++ )); do

	create_words_arr $subkey
	output_matrix

    done
}


output_matrix ()
{
    ## print all the subkey keys
    printf 'key %s\n' "$subkey"

    for (( row=0; row<"${rows}"; row++ )); do

	for (( col=0; col<"${cols}"; col++ )); do

            printf '%s ' "${words_arr[$subkey,$row,$col]}"

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
    generate_subkeys
    output_matrix
}

main
