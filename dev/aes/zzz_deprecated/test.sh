# Define the string
string="abcdefghijklm"

# Initialize a 4x4 matrix
declare -A matrix

# Fill the matrix
index=0
for ((col=0; col<4; col++)); do
    for ((row=0; row<4; row++)); do
        matrix[$row,$col]=${string:$index:1}
        ((index++))
    done
done

# Print the matrix
for ((row=0; row<4; row++)); do
    for ((col=0; col<4; col++)); do
        printf "%s " "${matrix[$row,$col]}"
    done
    echo
done