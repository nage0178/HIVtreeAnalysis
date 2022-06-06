#!/bin/bash

maxBatch=20 # Should be 20
maxRep=5 # Should be 5
maxSub=1 # Should be 1
mkdir combineGeneFiles/out

# Runs the analyses to combine the Bayesian estimates across genes for all 4 genes 
for ((rep=1;rep<=maxRep;rep++));
do
	for ((batch=1;batch<=maxBatch;batch++));
	do
		for ((sub=1;sub<=maxSub;sub++));
		do
			./combineGenes/summarizePosteriorRunR.sh $batch $rep $sub 4 &> combineGeneFiles/out/${batch}_${rep}_${sub}&
		done
	done
done
