#!/bin/bash

# Runs the ML analysis
mkdir trees
mkdir trees.rooted.rtt

mkdir outfileML
mkdir infoML

# For each alignment
for file in 217_ENV2 217_ENV3 217_ENV4 257_ENV2 257_ENV3 257_ENV4 257_GAG1 257_NEF1
do
	# For each number of sequences subsampled
	for numSub in 10 15 20
	do
		# For each level of gap stripping
		for filter in 0.75 0.85 0.95
		do
			# If the file exists
			name=${file}_d${numSub}_${filter}
			if test -f "raxml/${name}.raxml.bestTree"; then

				grep ">" alignmentsSub/${name}.fa |sed 's/>//g'> ${name}_seqs

				# Creates csv file in correct format for analysis
				echo "FULLSEQID","COLDATE","CENSORED" > infoML/${name}.csv

				for seq in $(cat ${name}_seqs)
				do

					pat='(.*)_DPI(.*)'

					if [[ "$seq" =~ $pat ]]; then
						date=${BASH_REMATCH[2]}

						echo ${seq},${date},0>>infoML/${name}.csv

					else
						pat2='(.*)_QVOA_(.*)_(.*)'
						if [[ "$seq" =~ $pat2 ]]; then

							date=${BASH_REMATCH[3]}
							echo ${seq},${date},1>>infoML/${name}.csv

						else
							echo No match for ${seq}
						fi
					fi

    
				done
				rm ${name}_seqs

				# Copies tree file to correct location
                                cp raxml/${name}.raxml.bestTree trees/${name}.nwk

                                # Roots the tree with root to tip regression
                                Rscript root.R trees/${name}.nwk trees.rooted.rtt/${name}.rooted infoML/${name}.csv

				# Runs the analysis
				Rscript ~/HIV_latency_general/analysis/ML/new.dating.R --tree trees.rooted.rtt/${name}.rooted --info infoML/${name}.csv --timetree outfileML/${name}.timetree --data outfileML/${name}.data.csv --stats outfileML/${name}.stats.csv --patid ${name} &> outfileML/${name}Out &
			fi
		done
	done
done
wait
