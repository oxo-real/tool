#!/bin/bash
spin() {

   local -a marks=( '/' '-' '\' '|' )
   while [[ 0 ]]; do
     printf '%s\r' "${marks[i++ % ${#marks[@]}]}"
     sleep 1
   done

}

spin
