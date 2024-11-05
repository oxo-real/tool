#! /usr/bin/env sh

cgcsf='/home/oxo/.local/share/c/git/code/source/function'
source "$cgcsf/text_appearance"

panels_rows=8
panels_columns=8
times=3
refresh_rate=2

## define panel
panel_definition ()
{
    panel='███'
    #printf "${color}%s \n%s \n${st_def}%s" '███' '▀▀▀'
    #printf "${color}%s \n%s \n${st_def}%s" '███' '▀▀▀'
}

color_definition ()
{
    red='ff6c60'
    green='a8ff60'
    yellow='ffffb6'
    blue='96cbfe'
    magenta='ff73fd'
    cyan='c6c5fe'

    #color_arr=( "$cyan" )
    color_arr=( "$red" "$green" "$blue" "$cyan" )
}

## define panel color
panel_color ()
{
    #curr_panel=$i
    #declare color_$curr_panel=$(shuf -n 1 -e "${color_arr[@]}")
    #color=color_$curr_panel

    color=$(shuf -n 1 -e "${color_arr[@]}")

    #color=${color_arr[ $RANDOM % ${#color_arr[@]} ]}
    #color_hex=${color_arr[ $RANDOM % ${#color_arr[@]} ]}
    #color='${'"$color_hex"'}'
}

## print panel
print_panel ()
{
    printf "$(FGx $color)%s${st_def} " "$panel"
}

panel_loop ()
{
    ## panel row
    for (( i=1; i<=$times; i++ )); do

	## refresh panels $times times
	for (( j=1; j<=$panels_columns; j++ )); do

	    ## create row of $panels panels
	    panel_color
	    print_panel

	done

	printf '\r'
	sleep $refresh_rate

    done
}

main ()
{
    panel_definition
    color_definition
    panel_color
    #print_panel
    panel_loop
}

main
#for i in {1..3}; do printf "${fg_blue}%s \n%s \n${st_def}%s" '███' '▀▀▀'; done
