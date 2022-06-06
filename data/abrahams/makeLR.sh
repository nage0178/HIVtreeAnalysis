#!/bin/bash

# Makes a csv file needed for the LR analysis

mkdir infoLR

# For each alignment
for file in 217_ENV2 217_ENV3 217_ENV4 257_ENV2 257_ENV3 257_ENV4 257_GAG1 257_NEF1
do
	# For each number of non-latent sequences sampled at each sample time
	for numSub in 10 15 20
	do
		# For each filter level of gap removal
		for filter in 0.75 0.85 0.95
		do

			name=${file}_d${numSub}_${filter}
			
			# Find the names of all the sequences
			grep ">" alignmentsSub/${name}.fa |sed 's/>//g'> ${name}_seqs
			echo "ID","Date","Query" > infoLR/${name}.csv

			# For each sequence
			for seq in $(cat ${name}_seqs)
			do

				# If the sequence is not latent
				pat='(.*)_DPI(.*)'

				if [[ "$seq" =~ $pat ]]; then
					
					date=${BASH_REMATCH[2]}
					echo ${seq},${date},0>>infoLR/${name}.csv

				else
					# If the sequence is latent
					pat2='(.*)_QVOA_(.*)_(.*)'
					if [[ "$seq" =~ $pat2 ]]; then
						
						date=${BASH_REMATCH[3]}
						echo ${seq},${date},1>>infoLR/${name}.csv

					# Sequence name is in the wrong format
					else
						echo No match for ${seq}
					fi
				fi

    
			done
		rm ${name}_seqs
		done
	done
done
