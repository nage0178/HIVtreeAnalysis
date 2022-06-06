#!/bin/bash

# For each batch (this is naming for tree simualation)
for name in p1 p2
do
	echo sequence,date,lowCI,highCI > resultsAllMethods/${name}_resultsBayes.csv

	# For each latent sequence in the alignment
	for line in $(cat mcmctree/${name}_seqsL)
	do
		run=1

		# Find the naming of the latent sequence in mcmctree
		outfile=mcmctree/${name}_${run}/output
	        nodeNum=$(grep -w ${line} ${outfile} | head -3 |tail -1 | awk '{print $2}')
	
		# Find the mean, and 95% HPD range
		mean=$(grep -w t_n${nodeNum} ${outfile} | sed 's/( /(/g' |  awk '{print $11}')
		lowHPD=$(grep -w t_n${nodeNum} ${outfile} | sed 's/( /(/g' | awk '{print $12}' | sed 's/,//g'| sed 's/(//g')
		highHPD=$(grep -w t_n${nodeNum} ${outfile} | sed 's/( /(/g' | awk '{print $13}' | sed 's/)//g')
	
		echo ${line},${mean},${lowHPD},${highHPD} >> resultsAllMethods/${name}_resultsBayes.csv
	done
done
