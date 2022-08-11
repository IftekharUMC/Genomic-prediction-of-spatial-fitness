#!/bin/bash

# prepare file as text to column, then rename strain id field as only ID names (no batch or replicates name) and fitness data in second column
# save as CSV

awk -F ',' '{ print >> ("file_" $1 ); close("file_" $1 ) }' Cal_SD2.csv # >> because of  multiple lines per file


DoStdDev(){

for FILE in $(ls file_*)
do
Stdev=$(awk -F ',' '{sum+=$2;a[NR]=$2}END{for(i in a)y+=(a[i]-(sum/NR))^2;print sqrt(y/(NR-1))}' $FILE )
Avg=$(awk -F ',' '{sum+=$2;a[NR]=$2}END{avg=(sum/NR);print avg}' $FILE )
DSD=$(echo "scale=7; 2*$Stdev" | bc)
AvgPlusDSD=$(echo "scale=7; ($Avg+$DSD)" | bc)
AvgMinusDSD=$(echo "scale=7; ($Avg-$DSD)" | bc)
echo $FILE $Stdev $Avg $DSD $AvgPlusDSD $AvgMinusDSD

done >> SD2

}

DoStdDev



