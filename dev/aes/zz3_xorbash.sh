#! /usr/bin/env sh

key="10011001"
key_length=${#key}

# Read the input file
# input_file="output.txt"  # Change this to your input file
input_file="lorem-ipsum"  # Change this to your input file
output_file="decrypted.txt" # Change this to your desired output file

# Create an empty output file
> "$output_file"

# Read the input file byte by byte
while IFS= read -r -n 1 char; do
    # Get the ASCII value of the character
    ascii_value=$(printf "%d" "'$char")

    # Get the binary representation of the ASCII value
    binary_value=$(printf "%08d" "$(echo "obase=2; $ascii_value" | bc)")

    # Perform XOR with the key
    xor_result=""
    for (( i=0; i<8; i++ )); do
        key_bit=${key:$((i % key_length)):1}
        xor_bit=$(( ${binary_value:$i:1} ^ key_bit ))
        xor_result+="$xor_bit"
    done

    # Convert the XOR result back to ASCII
    xor_ascii=$(echo "$((2#$xor_result))")
    printf "\\$(printf '%03o' "$xor_ascii")" >> "$output_file"
done < "$input_file"
