#! /usr/bin/env sh

## input: state_in (bin)
## output: state_out (bin)

## state_out is state_in after shift rows transformation

## usage: shift-rows.sh state.bin
## or: echo $state | sh shift-rows.sh


declare -A state_in_arr
declare -A state_out_hex_arr
declare -A state_out_bin_arr
state_length=128
col_l=8
rows=4
cols=4


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
    state_in=$(tr -d '\n' <<< "${input_stdin}${input_arg}")
}


validate_input ()
{
    ## input must be 128 bits
    state_in_l=${#state_in}
    [[ "$state_in_l" -eq "$state_length" ]] || exit 97
}


create_state_array ()
{
    index=0

    ## array fills first columns then rows
    for (( col=0; col<"${cols}"; col++ )); do

	for (( row=0; row<"${rows}"; row++ )); do

            state_in_arr[$row,$col]="${state_in:$(( index * $col_l )):$col_l}"

	    ((index++))

	done

    done
}


shift_rows ()
{
    ## split 128 bit state into imaginary grid;
    ## 4 128 / 4 = 32 bit rows
    ## 4  32 / 4 = 8  bit columns
    state_row_l=$(( state_length / 4 ))

    state_in_row_0=${state_in:$(( 0 * state_row_l )):$state_row_l}
    state_in_row_1=${state_in:$(( 1 * state_row_l )):$state_row_l}
    state_in_row_2=${state_in:$(( 2 * state_row_l )):$state_row_l}
    state_in_row_3=${state_in:$(( 3 * state_row_l )):$state_row_l}

    ## byte shift rows
    byte_shift=$(( state_row_l / 4 ))

    # state_out_row_0="${state_in_row_0}"
    state_out_row_0=${state_in_row_0:$(( 0 * byte_shift )):$(( 4 * byte_shift ))}${state_in_row_0:0:$(( 0 * byte_shift ))}
    state_out_row_1=${state_in_row_1:$(( 1 * byte_shift )):$(( 3 * byte_shift ))}${state_in_row_1:0:$(( 1 * byte_shift ))}
    state_out_row_2=${state_in_row_2:$(( 2 * byte_shift )):$(( 2 * byte_shift ))}${state_in_row_2:0:$(( 2 * byte_shift ))}
    state_out_row_3=${state_in_row_3:$(( 3 * byte_shift )):$(( 1 * byte_shift ))}${state_in_row_3:0:$(( 3 * byte_shift ))}

    state_out=$state_out_row_0$state_out_row_1$state_out_row_2$state_out_row_3
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
    : '
    for (( row=0; row<"${rows}"; row++ )); do

	for (( col=0; col<"${cols}"; col++ )); do

	    printf '%s' "${state_1_bin_arr[$row,$col]}"

	done

    done
    # '

    printf '%s' "$state_out"
}


main ()
{
    getstdin
    getargs $args
    synth_input
    validate_input
    # create_state_array
    shift_rows
    output
}

main
