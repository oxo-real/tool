#!/usr/bin/python3
##            __       
## __      __/ _| __ _ 
## \ \ /\ / / |_ / _` |
##  \ V  V /|  _| (_| |
##   \_/\_/ |_|  \__,_|
##  _ _|_ _ ._    _  _  
## (_\/|_(_)|_)\/(_|(/_ 
##   /      |  /  _|    
## 
## wfa
## word frequency analysis 
## with top x frequencies
## version 20170217_121704
## (c) 2017 by cytopyge
##

import re
import string

frequency = {}
results = []


document_text = open('/home/cytopyge/tmp/test.txt', 'r')
text_string = document_text.read().lower()
match_pattern = re.findall(r'\b[a-z]{3,15}\b', text_string)
document_text.close()


for word in match_pattern:
  count = frequency.get(word,0)
  frequency[word] = count + 1


frequency_list = frequency.keys()


for word in frequency_list:
  tuple = (word, frequency[word])
  results.append(tuple)


byFreq=sorted(results, key=lambda word: word[1], reverse=True)


for (word, freq) in byFreq[:20]:
  print (word, freq)
