#!/bin/bash

# Removes outgroup from the raxml tree to use in mcmctree 

maxBatch=20 # Should be 20
maxAli=30 # Should be ~30
maxRep=5 # Should be 5
maxSub=3 # Should be 3

mkdir mcmctree
# For each batch (this is naming for tree simulation)
for ((batch=1;batch<=maxBatch;batch++));
do
	# For each rep (this is naming for tree simulation)
	for ((rep=1;rep<=maxRep;rep++));
	do
		for ((sub=1;sub<=maxSub;sub++));
		do

			# For each gene
			for gene in C1V2 nef tat p17
			do

				# For maxAli number of alignments
				for ((ali=1;ali<=maxAli;ali++));
				do
					# Removes outgroup from raxml tree
					Rscript ../data/longitudinal_lanl/scripts/rmOutgroup.R raxml/b${batch}r${rep}a${ali}s${sub}${gene}.raxml.bestTree mcmctree/b${batch}r${rep}a${ali}s${sub}${gene}_rmOG.txt outgroup &

				done
			done
			wait $!
		done
	done
done


