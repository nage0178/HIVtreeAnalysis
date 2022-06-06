#!/bin/bash

maxBatch=20  # Should be 20
maxAli=30  # Should be 30
maxRep=5 # Should be 5
maxSub=3 # Should be 3
mkdir convergence

# For each alignment 
for ((ali=1;ali<=maxAli;ali++));
do
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
					# Find the mean times of the internal nodes in the tree for each replicate mcmc run
					echo node,run1,run2 > convergence/b${batch}r${rep}a${ali}s${sub}${gene}.csv
					./mcmcScripts/checkConvergence.sh ${batch} ${rep} ${sub} ${gene} ${ali}& 

				done
			done
		done
	wait $!
	done
done

# For each alignment 
for ((ali=1;ali<=maxAli;ali++));
do
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
					# Summarize difference between mcmc runs
                                        Rscript mcmcScripts/checkConverg.R  convergence/b${batch}r${rep}a${ali}s${sub}${gene}.csv 

                                done
                        done
                done
        wait $!
        done
done
