#!/bin/bash

maxBatch=20 # Should be 20
maxRep=5 # Should be 5
maxSub=1 # Should be 3

# Runs the analysis to estimate the posterior distribution using 2 genes
for ((rep=1;rep<=maxRep;rep++));
do
	for ((batch=1;batch<=maxBatch;batch++));
	do
		for ((sub=1;sub<=maxSub;sub++));
		do
			./combineGenes/summarizePosteriorRunR.sh $batch $rep $sub 2 &> combineGeneFiles/out/${batch}_${rep}_${sub}_2gene&
		done
	done
done
wait
