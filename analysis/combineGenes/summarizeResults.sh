#!/bin/bash

maxBatch=20 # Should be 20
maxRep=5 # Should be 5
maxSub=1 # Should be 1
maxAli=30 # Should be 30 

mkdir combineGeneFiles

# Creates a file for each latent integration time with the 
# samples from the MCMC for each of the 4 genes under the prior
# and running the MCMC with data
for ((rep=1;rep<=maxRep;rep++));
do
	for ((batch=1;batch<=maxBatch;batch++));
	do
		for ((sub=1;sub<=maxSub;sub++));
		do
			for ((ali=1;ali<=maxAli;ali++));
			do
				name=b${batch}r${rep}a${ali}s${sub}
				./combineGenes/summarizeResultsInnerLoop.sh $name &
			done
		done
		wait $!
	done
done
