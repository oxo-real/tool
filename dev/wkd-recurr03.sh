#! /usr/bin/env sh

# usage:
# recurr-wkd $p0 $p1 $interval $weekdays

# example:
# sh wkd-recurr03.sh 20250901 20250930 +2w mo tu

p0="$1"
p1="$2"
interval="$3"  # Get the interval as the third argument
weekdays_input=("${@:4}")  # Store all arguments after the first three

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

# Extract the number of weeks from the interval
if [[ "$interval" =~ ^\+([0-9]+)w$ ]]; then
    weeks="${BASH_REMATCH[1]}"
else
    echo "Invalid interval format. Use +<number>w (e.g., +2w)."
    exit 1
fi

# Convert period end date to epoch for comparison
end_date=$(date -d "${p1:0:4}-${p1:4:2}-${p1:6:2}" +%s)

# Initialize the current date to the start of the period
current_date="${p0:0:4}-${p0:4:2}-${p0:6:2}"

# Loop through each date in the specified period
while [ "$(date -d "$current_date" +%s)" -le "$end_date" ]; do
    # Get the current weekday number
    current_weekday=$(date -d "$current_date" +%u)

    # Check if the current weekday is in the list of specified weekdays
    for weekday in "${weekdays_input[@]}"; do
        # Check if the input is a number or an abbreviation
        if [[ "$weekday" =~ ^[0-9]+$ ]]; then
            # Input is a number
            if [ "$weekday" -eq "$current_weekday" ]; then
                iso_week_number=$(date -d "$current_date" +%V)
                echo "${current_date:0:4}${current_date:5:2}${current_date:8:2}_${iso_week_number}${current_weekday}"
                break
            fi
        else
            # Input is an abbreviation
            if [ "${weekday_abbr[$weekday]}" -eq "$current_weekday" ]; then
                iso_week_number=$(date -d "$current_date" +%V)
                echo "${current_date:0:4}${current_date:5:2}${current_date:8:2}_${iso_week_number}${weekday}"
                break
            fi
        fi
    done

    # Move to the next date based on the interval (in weeks)
    current_date=$(date -d "$current_date +${weeks} week" +%Y-%m-%d)
done

# Now, to ensure we also show the specified weekdays within the range
# Reset current_date to the start of the period
current_date="${p0:0:4}-${p0:4:2}-${p0:6:2}"

# Loop through each date in the specified period again to show all weekdays
while [ "$(date -d "$current_date" +%s)" -le "$end_date" ]; do
    current_weekday=$(date -d "$current_date" +%u)

    for weekday in "${weekdays_input[@]}"; do
        if [[ "$weekday" =~ ^[0-9]+$ ]]; then
            if [ "$weekday" -eq "$current_weekday" ]; then
                iso_week_number=$(date -d "$current_date" +%V)
                echo "${current_date:0:4}${current_date:5:2}${current_date:8:2}_${iso_week_number}${current_weekday}"
                break
            fi
        else
            if [ "${weekday_abbr[$weekday]}" -eq "$current_weekday" ]; then
                iso_week_number=$(date -d "$current_date" +%V)
                echo "${current_date:0:4}${current_date:5:2}${current_date:8:2}_${iso_week_number}${weekday}"
                break
            fi
        fi
    done

    # Move to the next day
    current_date=$(date -d "$current_date +1 day" +%Y-%m-%d)
done


# #! /usr/bin/env sh

# # usage:
# # recurr-wkd $p0 $p1 $interval $weekdays

# # example:
# # sh wkd-recurr03.sh 20250901 20250930 +1w mo tu
# # or
# # sh wkd-recurr03.sh 20250901 20250930 +2w 1 2

# p0="$1"
# p1="$2"
# interval="$3"  # Get the interval as the third argument
# weekdays_input=("${@:4}")  # Store all arguments after the first three

# # weekday abbreviations
# declare -A weekday_abbr=(
#     [mo]=1
#     [tu]=2
#     [we]=3
#     [th]=4
#     [fr]=5
#     [sa]=6
#     [su]=7
# )

# # Extract the number of weeks from the interval
# if [[ "$interval" =~ ^\+([0-9]+)w$ ]]; then
#     weeks="${BASH_REMATCH[1]}"
# else
#     echo "Invalid interval format. Use +<number>w (e.g., +2w)."
#     exit 1
# fi

# # convert period end date to epoch for comparison
# end_date=$(date -d "${p1:0:4}-${p1:4:2}-${p1:6:2}" +%s)

# # initialize the current date to the start of the period
# current_date="${p0:0:4}-${p0:4:2}-${p0:6:2}"

# # loop through each date in the specified period
# while [ "$(date -d "$current_date" +%s)" -le "$end_date" ]; do

#     # get the current weekday number
#     current_weekday=$(date -d "$current_date" +%u)

#     # check if the current weekday is in the list of specified weekdays
#     for weekday in "${weekdays_input[@]}"; do

#         # check if the input is a number or an abbreviation
#         if [[ "$weekday" =~ ^[0-9]+$ ]]; then

#             # input is a number
#             if [ "$weekday" -eq "$current_weekday" ]; then

#                 iso_week_number=$(date -d "$current_date" +%V)
#                 echo "${current_date:0:4}${current_date:5:2}${current_date:8:2}_${iso_week_number}${current_weekday}"
#                 break

#             fi

#         else

#             # input is an abbreviation
#             if [ "${weekday_abbr[$weekday]}" -eq "$current_weekday" ]; then

#                 iso_week_number=$(date -d "$current_date" +%V)
#                 echo "${current_date:0:4}${current_date:5:2}${current_date:8:2}_${iso_week_number}${weekday}"
#                 break

#             fi

#         fi

#     done

#     # move to the next date based on the interval (in weeks)
#     current_date=$(date -d "$current_date +${weeks} week" +%Y-%m-%d)

# done

# # Now, to ensure we also show the specified weekdays within the range
# # Reset current_date to the start of the period
# current_date="${p0:0:4}-${p0:4:2}-${p0:6:2}"

# # Loop through each date in the specified period again to show all weekdays
# while [ "$(date -d "$current_date" +%s)" -le "$end_date" ]; do
#     current_weekday=$(date -d "$current_date" +%u)

#     for weekday in "${weekdays_input[@]}"; do
#         if [[ "$weekday" =~ ^[0-9]+$ ]]; then
#             if [ "$weekday" -eq "$current_weekday" ]; then
#                 iso_week_number=$(date -d "$current_date" +%V)
#                 echo "${current_date:0:4}${current_date:5:2}${current_date:8:2}_${iso_week_number}${current_weekday}"
#                 break
#             fi
#         else
#             if [ "${weekday_abbr[$weekday]}" -eq "$current_weekday" ]; then
#                 iso_week_number=$(date -d "$current_date" +%V)
#                 echo "${current_date:0:4}${current_date:5:2}${current_date:8:2}_${iso_week_number}${weekday}"
#                 break
#             fi
#         fi
#     done

#     # Move to the next day
#     current_date=$(date -d "$current_date +1 day" +%Y-%m-%d)

# done


# #! /usr/bin/env sh

# # usage:
# # recurr-wkd $p0 $p1 $interval $weekdays

# # example:
# # recurr-wkd 20250801 20250831 +2w mo tu
# # or
# # recurr-wkd 20250801 20250831 +3w 1 2

# p0="$1"
# p1="$2"
# interval="$3"  # Get the interval as the third argument
# weekdays_input=("${@:4}")  # Store all arguments after the first three

# # weekday abbreviations
# declare -A weekday_abbr=(
#     [mo]=1
#     [tu]=2
#     [we]=3
#     [th]=4
#     [fr]=5
#     [sa]=6
#     [su]=7
# )

# # Extract the number of weeks from the interval
# if [[ "$interval" =~ ^\+([0-9]+)w$ ]]; then
#     weeks="${BASH_REMATCH[1]}"
# else
#     echo "Invalid interval format. Use +<number>w (e.g., +2w)."
#     exit 1
# fi

# # convert period end date to epoch for comparison
# end_date=$(date -d "${p1:0:4}-${p1:4:2}-${p1:6:2}" +%s)

# # initialize the current date to the start of the period
# current_date="${p0:0:4}-${p0:4:2}-${p0:6:2}"

# # loop through each date in the specified period
# while [ "$(date -d "$current_date" +%s)" -le "$end_date" ]; do

#     # get the current weekday number
#     current_weekday=$(date -d "$current_date" +%u)

#     # check if the current weekday is in the list of specified weekdays
#     for weekday in "${weekdays_input[@]}"; do

#         # check if the input is a number or an abbreviation
#         if [[ "$weekday" =~ ^[0-9]+$ ]]; then

#             # input is a number
#             if [ "$weekday" -eq "$current_weekday" ]; then

#                 iso_week_number=$(date -d "$current_date" +%V)
#                 echo "${current_date:0:4}${current_date:5:2}${current_date:8:2}_${iso_week_number}${current_weekday}"
#                 break

#             fi

#         else

#             # input is an abbreviation
#             if [ "${weekday_abbr[$weekday]}" -eq "$current_weekday" ]; then

#                 iso_week_number=$(date -d "$current_date" +%V)
#                 echo "${current_date:0:4}${current_date:5:2}${current_date:8:2}_${iso_week_number}${weekday}"
#                 break

#             fi

#         fi

#     done

#     # move to the next date based on the interval (in weeks)
#     current_date=$(date -d "$current_date +${weeks} week" +%Y-%m-%d)

# done
