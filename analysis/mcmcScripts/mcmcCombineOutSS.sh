#!/bin/bash

maxBatch=20 # Should be 20
maxRep=5 # Should be 5
maxSub=1 # Should be 3

mkdir resultsMCMCSS
# For each subsampling of the sampled tree
for ((sub=1;sub<=maxSub;sub++));
do

	# For each gene
	for gene in p17 # nef tat C1V2
	do

		# For each batch (this is naming for tree simulation)
		for ((batch=1;batch<=maxBatch;batch++));
		do

			# For each rep (this is naming for tree simulation)
			for ((rep=1;rep<=maxRep;rep++));
			do
				for sampleSize in 15 20 #10
				do
					# Find the estimated integration dates for each latent sequence
					# Records in csv file
					./mcmcScripts/mcmcParseSS.sh ${batch} ${rep} ${sub} ${gene} ${sampleSize}& 
				done
			done
		done
		wait $!
	done
done
