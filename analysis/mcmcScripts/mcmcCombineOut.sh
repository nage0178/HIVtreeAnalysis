#!/bin/bash

maxBatch=20 # Should be 20
maxRep=5 # Should be 5
maxSub=3 # Should be 3

# For each subsampling of the sampled tree
for ((sub=1;sub<=maxSub;sub++));
do

	# For each gene
	for gene in nef p17 tat C1V2
	do

		# For each batch (this is naming for tree simulation)
		for ((batch=1;batch<=maxBatch;batch++));
		do

			# For each rep (this is naming for tree simulation)
			for ((rep=1;rep<=maxRep;rep++));
			do
				# Find the estimated integration dates for each latent sequence
				# Records in csv file
				./mcmcScripts/mcmcParse.sh ${batch} ${rep} ${sub} ${gene} & 

			done
		done
	done
	wait $!
done
