#! /usr/bin/env sh

args=$@
tmp="$XDG_CACHE_HOME/temp"


grid_rows=3
grid_columns=3
times=3
refresh_period=5
column_width=38
row_height=40


function get_time_fold ()
{
    time_curr=$(date +'%H%M%S')
    [[ -n $args ]] && time_curr=$args

    time_fold=$(printf '%s' "$time_curr" | fold -w 1)

    decimals=$(printf '%s' "$time_fold" | wc -l)
    #DEV
    #printf 'DEV time: %s\n' "$time_fold"
}


function light_unit_definition ()
{
    ## light status
    case $lu_bit in

	1)
	    ## light on
	    lu='x'
	    #lu='◼'
	    #lu='█'
	    #lu='◼'
	    ;;

	0)
	    ## light off
	    lu='.'
	    ;;

    esac

    ## light color
    case $decimal_no in

	1)
	    color=31
	    ;;

	2)
	    color=32
	    ;;

	3)
	    color=33
	    ;;

	4)
	    color=34
	    ;;

	5)
	    color=35
	    ;;

	6)
	    color=36
	    ;;

    esac
    #color='96cbfe'  ## blue

    # DEV
    #printf 'DEV lu_bit: %s\n' "$lu_bit"
    #printf 'DEV lu: %s\n' "$lu"
}


function create_3x3 ()
{
    ## reset decimal number
    decimal_no=1

    ## create variable decimal and create 3x3 grid
    while IFS= read -r decimal; do

	grid_data
	grid_print
	grid_color

	## next decimal
	((decimal_no+=1))
	#printf 'DEV decimal_no: %s' "$decimal_no"

    done <<< "$time_fold"
}


function grid_data ()
{
    # create a binary string based on decimal to fill grid

    ## number of light units on and off
    no_lu_on=$decimal
    no_lu_off=$(( 9 - $decimal ))

    ## deduct onoff string
    on_string=$(printf '%0.s1' $(seq 1 $no_lu_on))
    off_string=$(printf '%0.s0' $(seq 1 $no_lu_off))

    ## alter onoff string
    [[ $no_lu_on == 0 ]] && on_string=''  ## and not 1; #TODO
    [[ $no_lu_off == 0 ]] && off_string=''  ## and not 1; #TODO

    ## define onoff string
    on_off_string=$(printf '%s%s' "$on_string" "$off_string")

    ## shuffle onoff string
    onf_shuf=$(printf '%s' "$on_off_string" | fold -w 1 | shuf)

    #DEV
    #printf 'DEV onstring: %s\n' "$on_string"
    #printf 'DEV offstring: %s\n' "$off_string"
    #printf 'DEV onoffstring: %s\n' "$on_off_string"
    #printf 'DEV onoffshuf: %s\n' "$onf_shuf"
}


## print light unit
function grid_print ()
{
    # grid three by three (represents one decimal)

    ## initialize light number (in grid)
    lu_no=1
    lu_curr=''

    while IFS= read -r lu_bit; do

	#printf 'DEV row: %s\n' "$row"

	## define lu variable from lu_bit out of onf_shuf
	light_unit_definition

	## print light unit
	## 31 red, 32 green, 34 blue, 36 cyan
	#grid_curr=grid${decimal_no}
	#grid${decimal_no}+="$(printf '\033[32m%s \033[0m' "$lu")"
	#grid_curr="$(printf '\033[32m%s \033[0m' "$lu")"
	#blue=$(tput setaf 4)
	#normal=$(tput sgr0)

	#tput setaf 4
	lu_curr+=$(printf '%s\n' "$lu")
	#lu_curr+=$(printf '%s\n' "$lu")
	#tput sgr0
	#lu_curr+=$(printf '%s\n' "${blue}$lu${normal}")
	#lu_curr+=$(printf "${blue}%s${normal}\n" "$lu")
	#lu_curr+="$(printf '%s' "$lu")"
	#lu_curr+="$(printf '\033[32m%s \033[0m' "$lu")"
	#lu_curr+="$(printf "\033[32m%s \033[0m" "$lu")"
	#printf '\e[32m%s \e[0m' "$lu"
	#lu_curr+="$(printf "\033[${color}m%s \033[0m" "$lu")"

	#echo -e "$lu_curr" | fold -w $grid_columns | paste -s -d '\n' - > "$tmp"/grid"$decimal_no"
	#sed -e "s/.\{20\}/&\n/g" < t
	printf '%s' "$lu_curr" | fold -w "$grid_columns" > "$tmp"/grid"$decimal_no"
	#printf '%s' "$lu_curr" > "$tmp"/grid"$decimal_no"
	#paste -s -d '\n' "$tmp"/grid"$decimal_no" > "$tmp"/grid"$decimal_no"
	#printf '%s' "$lu_curr" | fold -w $grid_columns | paste -s -d '\n' - > "$tmp"/grid"$decimal_no"

	#printf 'dev 130 %s\n' "$lu_curr"
	#printf '%s' "$grid_curr" > "$tmp"/grid"$decimal_no"
	#suffix=$decimal_no
	#declare grid_$suffix="$grid_curr"
	#grid${decimal_no}="$grid_curr"
	((lu_no+=1))

	#printf 'DEV %s' "$grid${decimal_no}"
	#printf 'DEV %s' "$grid_1"

	## onf_shuf is 9 bits binary string
    done <<< "$onf_shuf"

    #printf '%s' "$grid_curr" > "$tmp"/grid"$decimal_no"
}


function grid_color ()
{
    ## coloring gridfiles
    sed -i ''/x/s//$(printf "\033[${color}mx\033[0m")/g'' $tmp/grid$decimal_no
}


function print_tix ()
{
    printf "$(paste -d '|' $tmp/grid1 $tmp/grid2 $tmp/grid3 $tmp/grid4 $tmp/grid5 $tmp/grid6)" #| \
	#sed -e 's/|/ /g' -e 's/x/◾/g'
	#sed -e 's/|/  /g'
    #paste -d ' ' $tmp/grid1 $tmp/grid2 $tmp/grid3 $tmp/grid4 $tmp/grid5 $tmp/grid6
    #cat $tmp/grid1 $tmp/grid2 $tmp/grid3 $tmp/grid4 $tmp/grid5 $tmp/grid6
    #printf "$(paste -d ' ' $tmp/grid1 $tmp/grid2 $tmp/grid3 $tmp/grid4 $tmp/grid5 $tmp/grid6)"
    ##printf "$(paste -d '|' $tmp/grid1 $tmp/grid2 $tmp/grid3 $tmp/grid4 $tmp/grid5 $tmp/grid6)" | sed -e 's/|/  /g' -e 's/x/◾/g'
    #printf "$(paste -d '|' $tmp/grid1 $tmp/grid2 $tmp/grid3 $tmp/grid4 $tmp/grid5 $tmp/grid6)" | sed -e 's/|/  /g' -e 's/x/■/g'
}


function clean_lines ()
{
    for (( i=1; i<$grid_rows; i++ )); do

	printf '\r'
	tput el
	tput cuu1

    done
}


while true; do

    get_time_fold
    create_3x3
    print_tix
    sleep $refresh_period
    clean_lines

done



function separate_container ()
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
		#sleep 0.5

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

#main
#for i in {1..3}; do printf "${fg_blue}%s \n%s \n${st_def}%s" '███' '▀▀▀'; done
