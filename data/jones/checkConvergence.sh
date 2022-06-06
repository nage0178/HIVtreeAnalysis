#!/bin/bash

file=$1 

#echo batch,rep,ali,sub,gene,run,nodeName,trueDate,nodeDate,lowCI,highCI > resultsMCMC/b${batch}r${rep}s${sub}${gene}_combine.csv
name=${file}

outfile1=mcmctree/${name}_1/output
outfile2=mcmctree/${name}_2/output

# For all internal nodes, including the root
# Need to find the number of nodes

numSeq=$(head -1 mcmctree/${name}_mcmc.txt |awk '{print $1}')
start=$numSeq
end=$numSeq
((start=start+1))
((end=end*2-1))

for ((node=$start;node<=$end;node++));
do
	# Find the mean time
        mean1=$(grep -w t_n${node} ${outfile1} | sed 's/( /(/g' |  awk '{print $2}')
        mean2=$(grep -w t_n${node} ${outfile2} | sed 's/( /(/g' |  awk '{print $2}')

	# Record mean time in csv file
	echo t_n${node},${mean1},${mean2} >> convergence/${name}.csv
done
