#!/bin/bash

# Prepares files for mcmctree after the raxml tree has the outgroup removed 

maxBatch=20 # Should be 20
maxAli=30 # Should be ~30
maxRep=5 # Should be 5
maxSub=3 # Should be 3

# For each batch (this is naming for tree simulation)
for ((batch=1;batch<=maxBatch;batch++));
do
	# For each rep (this is naming for tree simulation)
	for ((rep=1;rep<=maxRep;rep++));
	do
		# For each subsampling of the tree
		for ((sub=1;sub<=maxSub;sub++));
		do

			# For each gene/parameters combination
			for gene in C1V2 nef p17 tat 
			do

				# For maxAli number of alignments
				for ((ali=1;ali<=maxAli;ali++));
				do
                                        name=b${batch}r${rep}a${ali}s${sub}

					cp mcmctree/b${batch}r${rep}a${ali}s${sub}${gene}_1.ctl mcmctree/b${batch}r${rep}a${ali}s${sub}${gene}prior_1.ctl 
					cp mcmctree/b${batch}r${rep}a${ali}s${sub}${gene}_2.ctl mcmctree/b${batch}r${rep}a${ali}s${sub}${gene}prior_2.ctl 

					sed -i "s/usedata = 1/usedata = 0/g" mcmctree/b${batch}r${rep}a${ali}s${sub}${gene}prior_1.ctl
					sed -i "s/usedata = 1/usedata = 0/g" mcmctree/b${batch}r${rep}a${ali}s${sub}${gene}prior_2.ctl
	
					sed -i "s/nsample = 30000/nsample = 100000/g" mcmctree/b${batch}r${rep}a${ali}s${sub}${gene}prior_1.ctl
					sed -i "s/nsample = 30000/nsample = 100000/g" mcmctree/b${batch}r${rep}a${ali}s${sub}${gene}prior_2.ctl

					# Makes a directory for each mcmc run 
					mkdir mcmctree/${name}${gene}prior_1
					mkdir mcmctree/${name}${gene}prior_2
				done
			done
		done
	done
done


