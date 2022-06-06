#!/bin/bash

# Runs raxml for each unique alignment

mkdir raxml
seed=1 
# For each alignment
for file in 217_ENV2 217_ENV3 217_ENV4 257_ENV2 257_ENV3 257_ENV4 257_GAG1 257_NEF1
do
	# For each number of sequences sampled at each timepoint
	for numSub in 10 15 20
	do

		# Always run raxml for .75 level of gap stripping
		raxml-ng --msa alignmentsSub/${file}_d${numSub}_0.75.fa --prefix raxml/${file}_d${numSub}_0.75 --model HKY+G --tree pars{25},rand{25} --threads 1 --seed ${seed} &> raxml/${file}_d${numSub}_0.75_raxmlOut &
		((seed=seed+1))

		# If the .75 and .85 gap stripping alignmens are different, run raxml for .85
		diff alignmentsSub/${file}_d${numSub}_0.75.fa alignmentsSub/${file}_d${numSub}_0.85.fa > /dev/null
		if [ $? -ne 0 ]; then
			raxml-ng --msa alignmentsSub/${file}_d${numSub}_0.85.fa --prefix raxml/${file}_d${numSub}_0.85 --model HKY+G --tree pars{25},rand{25} --threads 1 --seed ${seed} &> raxml/${file}_d${numSub}_0.85_raxmlOut &
			((seed=seed+1))
		else
			# Print alignments that are identical
			echo alignmentsSub/${file}_d${numSub}_0.75.fa is the same as alignmentsSub/${file}_d${numSub}_0.85.fa
		fi

		# If the .85 and .95 gap stripping alignmens are different, run raxml for .95
		diff alignmentsSub/${file}_d${numSub}_0.85.fa alignmentsSub/${file}_d${numSub}_0.95.fa > /dev/null
		if [ $? -ne 0 ]; then
			raxml-ng --msa alignmentsSub/${file}_d${numSub}_0.95.fa --prefix raxml/${file}_d${numSub}_0.95 --model HKY+G --tree pars{25},rand{25} --thread 1 --seed ${seed} &> raxml/${file}_d${numSub}_0.95_raxmlOut &
			((seed=seed+1))
		else
			# Print alignments that are identical
			echo alignmentsSub/${file}_d${numSub}_0.85.fa is the same as alignmentsSub/${file}_d${numSub}_0.95.fa
		fi

	done
done
wait
