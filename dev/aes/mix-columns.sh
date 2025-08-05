#! /usr/bin/env sh

## input: state_in (bin)
## output: state_out (bin)

## state_out is state_in after mix columns transformation

## usage: mix-columns.sh state.bin
## or: echo $state | sh mix-columns.sh


declare -A state_in_bin_arr
declare -A state_in_hex_arr
declare -A state_out_arr
declare -A state_out_hex_arr
declare -A state_out_bin_arr

source /home/oxo/.local/share/c/git/code/tool/dev/aes/mp-matrix.sh


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

            state_in_bin_arr[$row,$col]="${state_in:$(( index * $col_l )):$col_l}"

	    ((index++))

	done

    done
}


convert_bin_cells_to_hex ()
{
    for cell in "${!state_in_bin_arr[@]}"; do
	## for every cell (key) in the associative array

	## get the binary value
	cell_value_bin=${state_in_bin_arr[$cell]}

	## convert bin to hex value
	cell_value_hex=$(echo "obase=16; ibase=2; $cell_value_bin" | bc)

	## populate state_in_arr_hex
	state_in_hex_arr[$cell]=0x$cell_value_hex

    done
}


gf_28_mp ()
{
    ## GF(2^8) multiplication with polynomial reduction

    ## the state matrix value
    local a=$1
    ## the multiplication matrix value
    local b=$2

    ## irreducible polynomial
    ## if multiplication result exceeds GF(2^8)
    ## then reduce it using the irreducible polynomial
    ## to get a result that fits within the field
    ## x^8 + x^4 + x^3 + x + 1 or 100011011 or 0x11B

    ## p holds product ab
    local p=0


    ## loop over every bit in the byte
    for ((i=0; i<8; i++)); do

	if ((b & 1)); then
	    ## least significant bit (LSB) of b is set (1 = 00000001)
	    ## current bit contributes to the final product

	    ## adding a to the result p in GF(2^8) (xor p and a)
	    p=$((p ^ a))

	fi

	## check if the value of a exceeds GF(2^8)
	local hi_bit_set=$((a & 0x80))

	a=$((a << 1))

	if ((hi_bit_set)); then

	    ## polynomial reduction to keep the result within GF(2^8)
	    a=$((a ^ 0x11b))

	fi

	b=$((b >> 1))

    done

    echo $p
}


matrix_multiplication ()
{
    # Multiply the matrix

    for ((i=0; i<4; i++)); do
	## iterate over the 4 row indices of state_out_hex_arr

	for ((j=0; j<4; j++)); do
	    ## iterate over the 4 column indices of state_out_hex_arr

	    ## reset the sum for each new cell (i,j)
            sum=0

            for ((k=0; k<4; k++)); do
		## iterate over the row index of the state_in_hex_arr and
		## iterate over the column index of the mp_arr

		## get the cell values for multiplication from
		## the state matrix
		a=${state_in_hex_arr[$i,$k]}
		## the multiplication matrix
		b=${mp_arr[$k,$j]}

		## multiply a and b by running mp_gf_28
		## convert to decimal $(()) for multiplication
		product=$(gf_28_mp $(( a )) $(( b )))

		## xor the result
		sum=$((sum ^ product))

            done

	    ## populate state_out with results in hex format
            state_out_hex_arr["$i,$j"]=0x$(printf '%02X' $sum)

	    ## populate state_out with results in hex format
            state_out_bin_arr["$i,$j"]=$(printf '%08d' "$(echo "obase=02; ibase=10; $sum" | bc)")

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
            # printf '%s ' "${state_out_bin_arr[$row,$col]}"

	    ## hex
            printf '%s ' "${state_out_hex_arr[$row,$col]#0x}"
	    ## hex with leading 0x
            # printf '%s ' "${state_out_hex_arr[$row,$col]}"

	done

	echo

    done
    # '

    ## string
    # : '
    for (( row=0; row<"${rows}"; row++ )); do

	for (( col=0; col<"${cols}"; col++ )); do

	    ## binary
	    printf '%s' "${state_out_bin_arr[$row,$col]}"

	    ## hex
	    # printf '%s' "${state_out_hex_arr[$row,$col]#0x}"
	    ## hex with leading 0x
	    # printf '%s' "${state_out_hex_arr[$row,$col]}"

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
    convert_bin_cells_to_hex
    matrix_multiplication
    output
}

main
