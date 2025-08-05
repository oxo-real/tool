#!/bin/zsh

# Define the irreducible polynomial for GF(2^8)
# Polynomial: x^8 + x^4 + x^3 + x + 1 = 0x11B in hex
IRREDUCIBLE_POLY=0x11b

# Function to perform multiplication in GF(2^8)
gf_multiply() {
    local a=$1
    local b=$2

    # Convert hex inputs to decimal
    local a_dec=$((16#$a))
    local b_dec=$((16#$b))

    # Initialize result
    local result=0

    # Perform multiplication bit by bit
    for ((i=0; i<8; i++)); do
        if (( b_dec & 1 )); then
            result=$((result ^ a_dec))
        fi
        a_dec=$((a_dec << 1))
        b_dec=$((b_dec >> 1))
    done

    # Reduce result modulo the irreducible polynomial
    while (( result >= IRREDUCIBLE_POLY )); do
        result=$(( (result ^ IRREDUCIBLE_POLY) & 0xff ))
    done

    # Output result in hex
    printf "%x\n" "$result"
}

# Example usage
a="06"
b="35"
result=$(gf_multiply "$a" "$b")
echo "Multiplication of $a and $b in GF(2^8) is: $result"#
