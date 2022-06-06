#!/bin/bash

# Parses the output of the MCMCs and puts the results in a csv file
for file in 217_ENV2 217_ENV3 217_ENV4 257_ENV2 257_ENV3 257_ENV4 257_GAG1 257_NEF1
do
	# For each number of sequences subsampled
	for numSub in 10 15 20
	do
		# For each level of gap stripping
		for filter in 0.75 0.85 0.95
		do
			name=${file}_d${numSub}_${filter}
                        if test -f "raxml/${name}.raxml.bestTree"; then
				
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
			fi
		done
	done
done
