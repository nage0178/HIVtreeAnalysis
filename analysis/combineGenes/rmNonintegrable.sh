#!/bin/bash

maxBatch=20 # Should be 20
maxRep=5 # Should be 5
maxSub=1 # Should be 1

mkdir rmNAcombineGeneFiles

# Removes analyses that did not produce a result due to numerical issues
# Usually, this is because a function was not integrable
for ((rep=1;rep<=maxRep;rep++));
do
	for ((batch=1;batch<=maxBatch;batch++));
	do
		for ((sub=1;sub<=maxSub;sub++));
		do
			grep -v 16,1,17,1,combine,1,Node_1_877_14_3650 combineGeneFiles/b${batch}r${rep}s${sub}combine.csv | grep -v ',$'  &> rmNAcombineGeneFiles/b${batch}r${rep}s${sub}combine.csv

		done
	done
	wait $!
done

