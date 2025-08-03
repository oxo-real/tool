#! /usr/bin/env sh

## input: state_0 (bin)
## output: state_1 (bin)

## state_1 is state_0 after byte substitution

## usage: substitiute.sh state.bin
## or: echo $state | substitiute.sh


declare -A state_0_arr
declare -A state_1_hex_arr
declare -A state_1_bin_arr
state_length=128
sbox=/home/oxo/.local/share/c/git/code/tool/dev/aes/sbox.sh
col_l=8
rows=4
cols=4

source "$sbox"


args="$@"
getargs ()
{
    while :; do

	case "$1" in

	    '' )
		break
		;;

	    --state )
		shift

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
    state=$(tr -d '\n' <<< "${input_stdin}${input_arg}")
}


validate_input ()
{
    ## input must be 128 bits
    state_l=${#state}
    [[ "$state_l" -eq "$state_length" ]] || exit 70
}


create_state_array ()
{
    index=0

    ## array fills first columns then rows
    for (( col=0; col<"${cols}"; col++ )); do

	for (( row=0; row<"${rows}"; row++ )); do

            state_0_arr[$row,$col]="${state:$(( index * $col_l )):$col_l}"

	    ((index++))

	done

    done
}


substitute_bytes ()
{
    for (( col=0; col<"${cols}"; col++ )); do

	for (( row=0; row<"${rows}"; row++ )); do

	    ## get byte
	    cell_0_byte=${state_0_arr[$row,$col]}

	    ## convert bin to hex
	    ## print the hexadecimal representation (%02x)
	    ## of the decimal value of the binary (2#))
	    cell_0_hex=$(printf '%02x\n' "$(( 2#${cell_0_byte} ))")

	    ## retrieve hex value from substitution box
	    cell_1_hex=${s_box["${cell_0_hex}"]}

	    ## capitalize for bc ...
	    cell_1_hex=$(echo $cell_1_hex | tr a-z A-Z)

	    ## put replacement value in state_1_hex_arr
	    state_1_hex_arr[$row,$col]="${cell_1_hex}"

	    ## translate retrieved hex to binary
	    cell_1_bin=$(printf '%08d' $(echo "obase=02; ibase=16; $(printf '%s' "${cell_1_hex}")" | bc))

	    ## put replacement value in state_1_bin_arr
	    state_1_bin_arr[$row,$col]="${cell_1_bin}"

	done

    done
}


output ()
{
    ## matrix
    : '
    for (( row=0; row<"${rows}"; row++ )); do

	for (( col=0; col<"${cols}"; col++ )); do

	    ## binary
            printf '%s ' "${state_1_bin_arr[$row,$col]}"

	    ## hex
            # printf '%s ' "${state_1_hex_arr[$row,$col]}"

	done

	echo

    done
    # '

    ## string
    #: '
    for (( row=0; row<"${rows}"; row++ )); do

	for (( col=0; col<"${cols}"; col++ )); do

	    printf '%s' "${state_1_bin_arr[$row,$col]}"

	done

    done
    # '
}


main ()
{
    getstdin
    getargs $args
    synth_input
    validate_input
    create_state_array
    substitute_bytes
    output
}

main
