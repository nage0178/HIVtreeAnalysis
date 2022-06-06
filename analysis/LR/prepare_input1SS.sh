#!/bin/bash

maxBatch=20 # should be 20 
maxAli=30 #should be ~30
maxRep=5 #should be 5
maxSub=3 #should be 3

mkdir alignedSS

# Removes the outgroup from the alignment
for ((batch=1;batch<=maxBatch;batch++));
  do
  for ((rep=1;rep<=maxRep;rep++));
    do
    for sampleSize in 15 20
      do
      for ((ali=1;ali<=maxAli;ali++));
    	do
        for gene in nef tat p17 C1V2
	do
		name=b${batch}r${rep}a${ali}s1${gene}S${sampleSize}
		grep ">" ~/HIVtreeAnalysis/dnaSimulations/sampleSize/${name}.fa | sed 's/>//g' | grep -v outgroup > names_${name}
		~/pullseq/src/./pullseq -i ~/HIVtreeAnalysis/dnaSimulations/sampleSize/${name}.fa -n names_${name} > ~/HIVtreeAnalysis/analysis/LR/alignedSS/${name}.fa &
    done
  done
done
done
done
wait
