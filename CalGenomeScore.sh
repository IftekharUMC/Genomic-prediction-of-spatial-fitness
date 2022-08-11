#!/bin/bash

# prepare input file with no header, no snp column
# sort as per p_lrt value (smallest to largest)
# keep only position, beta and p_lrt field
# place gentoype matrix beside (vlookup)
# convert to .csv file
# make all value to scientific

#score each snp
DoGS1(){
for FILE in $(ls *.csv)
do
 awk -F "," '{ 
  for (i=4; i<=33; i++)
     printf "%e,",
       ($i==1 ? $2 : $2*(-1));
     printf "\n"
 }' ${FILE} > out_${FILE}
COUNTER=$((COUNTER+=1))
echo $COUNTER
done
}
DoGS1

#sum score of individual strain
DoGS2(){
for FILE in $(ls out_*)
do
 awk -F "," '{
  for (i=1; i<=30; i++) x[i]+=$i }
  END {
  for(i=1; i<=30; i++) printf "%e,", x[i]
 }' ${FILE} > final_${FILE}
COUNTER=$((COUNTER+=1))
echo $COUNTER
done
}
DoGS2