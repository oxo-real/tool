#! /usr/bin/env sh

# Define a 3x3 matrix using a single-dimensional array
matrixA=(1 2 3 4 5 6 7 8 9)  # Row-major order
matrixB=(9 8 7 6 5 4 3 2 1)  # Row-major order

# Initialize the result matrix
result=(0 0 0 0 0 0 0 0 0)

# Perform matrix multiplication
for ((i=0; i<3; i++)); do
    for ((j=0; j<3; j++)); do
        for ((k=0; k<3; k++)); do
            result[$((i * 3 + j))]=$((result[$((i * 3 + j))] + matrixA[$((i * 3 + k))] * matrixB[$((k * 3 + j))]))
        done
    done
done

# Print the result matrix
echo "Resultant Matrix:"
for ((i=0; i<3; i++)); do
    for ((j=0; j<3; j++)); do
        echo -n "${result[$((i * 3 + j))]} "
    done
    echo
done
