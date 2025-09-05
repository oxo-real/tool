#! /usr/bin/env sh

# generate weekdays in an interval
# i.e. every monday and tuesday in August 2025

# usage:
# recurr-wkd $p0[$t0] $p1 $weekday [$weekday2]

# example:
# recurr-wkd 20250801 20250831 mo tu
# or
# recurr-wkd 20250801_1500 20250831 1 2


## getargs
p0="$1"
shift
p1="$1"
shift
weekdays_input=("$@")

if [[ "$p0" -gt "$p1" ]]; then

    printf 'set p1 > p0\n'
    exit 25

fi


# weekday abbreviations
declare -A weekday_abbr=(
    [mo]=1
    [tu]=2
    [we]=3
    [th]=4
    [fr]=5
    [sa]=6
    [su]=7
)

# Convert period start and end dates to epoch for comparison
start_date=$(date --date "${p0:0:4}-${p0:4:2}-${p0:6:2}" +%s)
start_time="${p0:8:5}"  ## i.e. _1200 (if given else empty)
end_date=$(date --date "${p1:0:4}-${p1:4:2}-${p1:6:2}" +%s)

## one day interval
interval=86400
#TODO double entry when switching to CEST to CET
## current date becomes 2300 hours


# loop through each day between start_date and end_date (period p0-p1)

## initialize loop_date
loop_date=$start_date

while [ "$loop_date" -le "$end_date" ]; do

    # get the current weekday number in the loop
    loop_weekday=$(date -d "@$loop_date" +%u)

    # check if the current weekday is in the list of specified weekdays
    for weekday_i in "${weekdays_input[@]}"; do

	## output format
        formatted_date=$(date -d "@$loop_date" +%Y%m%d%z_%Z)
        # formatted_date=$(date -d "@$loop_date" +%Y%m%d%z%Z)
        weeknum=$(date -d "@$loop_date" +%V)
        weekday=$(date -d "@$loop_date" +%u)

        # check if the input is a number or an abbreviation
        if [[ "$weekday_i" =~ ^[0-9]+$ ]]; then

            ## input is a number
            if [ "$weekday_i" -eq "$loop_weekday" ]; then

		## output is a number
		printf '%s%s_%s%s\n' "$formatted_date" "$start_time" "$weeknum" "$weekday"

                break
            fi

        else

            ## input is an abbreviation
            if [ "${weekday_abbr[$weekday_i]}" -eq "$loop_weekday" ]; then

		## output is an abbreviation
		printf '%s%s_%s%s\n' "$formatted_date" "$start_time" "$weeknum" "$weekday_i"
                break

            fi

        fi

    done

    # move to the next interval
    next_loop_date=$(( loop_date + interval ))

    ## daylight saving time correction
    ld_tz=$(date --date @"$loop_date" +%z)
    nld_tz=$(date --date @"$next_loop_date" +%z)

    if [[ "$ld_tz" != "$nld_tz" ]]; then

       ## time difference
       ld=$(date --date @"$loop_date" +%s)
       nld=$(date --date @"$next_loop_date" +%s)
       time_d=$(( ld_tz - nld_tz ))

       ## next_loop_date correction
       next_loop_date=$(( loop_date - time_d ))

       exit 255
    fi

    loop_date="$next_loop_date"

done
