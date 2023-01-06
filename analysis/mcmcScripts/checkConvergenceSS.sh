#!/bin/bash

batch=$1 
rep=$2
sub=$3 
gene=$4
ali=$5
sampleSize=$6

#echo batch,rep,ali,sub,gene,sampleSize,run,nodeName,trueDate,nodeDate,lowCI,highCI > resultsMCMC/b${batch}r${rep}s${sub}${gene}_combine.csv
name=b${batch}r${rep}a${ali}s${sub}${gene}S${sampleSize}

outfile1=mcmctreeSS/${name}_1/output
outfile2=mcmctreeSS/${name}_2/output

if [ $sampleSize == 15 ]
then
	nodestart=156
	nodeend=309
# For all internal nodes, including the root
else 
	nodestart=201
	nodeend=399

fi

for ((node=$nodestart;node<=$nodeend;node++));
do
	# Find the mean time
        mean1=$(grep -w t_n${node} ${outfile1} | sed 's/( /(/g' |  awk '{print $2}')
        mean2=$(grep -w t_n${node} ${outfile2} | sed 's/( /(/g' |  awk '{print $2}')

	# Record mean time in csv file
	echo t_n${node},${mean1},${mean2} >> convergenceSS/${name}.csv
done
