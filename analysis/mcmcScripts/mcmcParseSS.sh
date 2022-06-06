#!/bin/bash

batch=$1
rep=$2 
sub=$3 
gene=$4
maxAli=30
sampleSize=$5

echo batch,rep,ali,sub,gene,sampleSize,run,nodeName,trueDate,nodeDate,lowCI,highCI > resultsMCMCSS/b${batch}r${rep}s${sub}${gene}S${sampleSize}_combine.csv

# For maxAli number of alignments
for ((ali=1;ali<=maxAli;ali++));
do
	name=b${batch}r${rep}a${ali}s${sub}${gene}S${sampleSize}

	# For each latent sequence in the alignment
	for line in $(cat mcmctreeSS/b${batch}r${rep}a${ali}s${sub}S${sampleSize}_seqsL)
	do
		# For each replicate mcmc run
       		for run in 1 # 2
       		do
			# Find the naming of the latent sequence in mcmctree
			outfile=mcmctreeSS/${name}_${run}/output
		        nodeNum=$(grep -w ${line} ${outfile} | head -3 |tail -1 | awk '{print $2}')

			# Finds the true integration time
			pat='(Node_1_[0-9]+_([0-9]+)_[0-9]+)'
			[[ "$line" =~ $pat ]]
			trueDate=${BASH_REMATCH[2]}

			# Find the mean, and 95% HPD range
			mean=$(grep -w t_n${nodeNum} ${outfile} | sed 's/( /(/g' |  awk '{print $11}')
			lowHPD=$(grep -w t_n${nodeNum} ${outfile} | sed 's/( /(/g' | awk '{print $12}' | sed 's/,//g'| sed 's/(//g')
			highHPD=$(grep -w t_n${nodeNum} ${outfile} | sed 's/( /(/g' | awk '{print $13}' | sed 's/)//g')

			echo ${batch},${rep},${ali},${sub},${gene},${sampleSize},${run},${line},${trueDate},${mean},${lowHPD},${highHPD} >> mcmctreeSS/b${batch}r${rep}s${sub}${gene}S${sampleSize}_combine.csv
		done
	done
done
