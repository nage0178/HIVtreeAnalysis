#!/bin/bash

# Runs the LR analysis
mkdir dataLR

# For each alignment
for file in 217_ENV2 217_ENV3 217_ENV4 257_ENV2 257_ENV3 257_ENV4 257_GAG1 257_NEF1
do
	# For each number of sequences subsampled
	for numSub in 10 15 20
	do
		# For each level of gap stripping
		for filter in 0.75 0.85 0.95
		do 
			# If the file exists (not all do because different levels of gap stripping may result in the same alignment. Then only one analysis was run)
			name=${file}_d${numSub}_${filter}
			if test -f "raxml/${name}.raxml.bestTree"; then

				# Run analysis
				Rscript ~/phylodating/scripts/root_and_regress.R --runid ${name} --tree trees/${name}.nwk --rootedtree trees.rooted.rtt/${name}.rooted.nwk --info infoLR/${name}.csv --stats dataLR/data${name}.csv --data dataLR/${name}.txt &> dataLR/${name}Out &

			fi 
		done
	done
done
wait
