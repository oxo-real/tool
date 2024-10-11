#! /usr/bin/env sh

cgcsf='/home/oxo/.local/share/c/git/code/source/function'
source "$cgcsf/text_appearance"

rows=3
columns=3
times=3000
refresh_rate=4
column_width=38
row_height=40

separate_container ()
{
    ## set floating container
    sway floating enable

    ## container opacity
    alacritty msg config window.opacity='0.0'

    ## container dimensions
    sway resize set width $(( columns * column_width ))
    sway resize set height $(( rows * row_height ))

    ## clear screen
    clear
}

## define panel
panel_definition ()
{
    panel='███'

    if [[ "$color" == 'none' ]]; then

	## no color panel
	panel='   '

    fi
}

color_definition ()
{
    red='ff6c60'
    green='a8ff60'
    yellow='ffffb6'
    blue='96cbfe'
    magenta='ff73fd'
    cyan='c6c5fe'
    black='000000'
    none='none'

    ## used colors
    color_arr=( "$red" "$green" "$blue" "$none" )
}

## define panel color
panel_color ()
{
    color=$(shuf -n 1 -e "${color_arr[@]}")
}

## print panel
print_panel ()
{
    panel_definition

    printf "$(FGx $color)%s${st_def} " "$panel"
}

panel_loop ()
{
    ## hide cursor
    tput civis

    ## resfresh times
    for (( t=1; t<=$times; t++ )); do

	## panel row
	for (( r=1; r<=$rows; r++ )); do

	    ## panel column
	    for (( c=1; c<=$columns; c++ )); do

		panel_color
		print_panel
		sleep 0.5

	    done

	    if [[ $r == $rows ]]; then

		continue

	    else

		## add eol and new line
		echo && echo

	    fi

	done

	## cursor to bol
	printf '\r'

	## cursor to first row
	for (( u=1; u<=$((columns*2)); u++ )); do

	    tput cuu1

	done

	sleep $refresh_rate

    done

    ## show cursor again
    tput cnorm
}

main ()
{
    separate_container
    color_definition
    #panel_definition
    panel_loop
}

main
#for i in {1..3}; do printf "${fg_blue}%s \n%s \n${st_def}%s" '███' '▀▀▀'; done
