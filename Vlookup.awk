#!/bin/awk


NR==FNR {
  a[$1]=$1 "," $5 "," $6  # Set a value in array a of file1 field 1 to fields 1,5 and 6 as index of the same file1
  next}    # Stop processing this line, do not check other rules
{ if ($1 in a)  # if column1 of file 2 matches any index in array a
  {print a[$1]}} # the columns you want