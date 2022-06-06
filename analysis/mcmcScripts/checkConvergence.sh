#!/bin/bash

batch=$1 
rep=$2
sub=$3 
gene=$4
ali=$5

#echo batch,rep,ali,sub,gene,run,nodeName,trueDate,nodeDate,lowCI,highCI > resultsMCMC/b${batch}r${rep}s${sub}${gene}_combine.csv
name=b${batch}r${rep}a${ali}s${sub}${gene}

outfile1=mcmctree/${name}_1/output
outfile2=mcmctree/${name}_2/output

# For all internal nodes, including the root
for ((node=131;node<=259;node++));
do
	# Find the mean time
        mean1=$(grep -w t_n${node} ${outfile1} | sed 's/( /(/g' |  awk '{print $2}')
        mean2=$(grep -w t_n${node} ${outfile2} | sed 's/( /(/g' |  awk '{print $2}')

	# Record mean time in csv file
	echo t_n${node},${mean1},${mean2} >> convergence/${name}.csv
done
