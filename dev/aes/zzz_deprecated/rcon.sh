#! /usr/bin/env sh

arg="$1"

getargs()
{
    ## random input value i
    input=$arg
    constant=1
}


validate ()
{
    if [[ "$input" -eq 0 ]]; then

	echo 0
	return

    fi
}


process ()
{
    local i=$input
    local rcon=1
        for ((i=1; i<round; i++)); do
        rcon=$((rcon * 2))
        if (( rcon >= 256 )); then
            rcon=$((rcon ^ 0x11B))  # Reduce modulo x^8 + x^4 + x^3 + x + 1
        fi
    done
}
old_process ()
{
    i="$input"
    c="$constant"

    while [[ "$i" -ne 1 ]]; do

	local b=$((c & 0x80))
	c=$((c << 1))

	if [[ "$b" -eq 0x80 ]]; then

            c=$((c ^ 0x1b))

	fi

	(( i-- ))

    done
}


output ()
{
    # echo $c
    echo $rcon
}


main ()
{
    getargs $arg
    validate
    process
    output
}

main
