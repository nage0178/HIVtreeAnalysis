#!/bin/bash

seed=1

maxBatch=20 # Should be 20
maxAli=30 # Should be ~30
maxRep=5 # Should be 5
maxSub=1 # Should be 3
treeDir=~/HIVtreeAnalysis/treeSimulation/checkpoint/

for gene in C1V2 nef p17 tat
do

# For each batch (this is naming for tree simualation)
for ((batch=1;batch<=maxBatch;batch++));
do

  # For each rep (this is naming for tree simualation)
  for ((rep=1;rep<=maxRep;rep++));
  do

    # Subsample the tree maxSub number of times
    # Each gene has the same true tree, thus outside of the gene loop
    for ((sub=1;sub<=maxSub; sub++));
    do
	    for size in 10 15 20
	    do 
      # This script does the subsampling
      Rscript ../subsample.R ../alignments/b${batch}r${rep}a1${gene}TreeOG.txt ${treeDir}../runFiles/samples.csv ../subsample${size}.csv b${batch}r${rep}s${sub}S${size} ${seed}

      # Strip branch lengths
      sed -E 's/:[0-9.Ee-]+//g' b${batch}r${rep}s${sub}S${size}_dropTipsTree.txt > b${batch}r${rep}s${sub}S${size}_strip.txt

      ((seed=seed+1))
      # Make new fasta file with only the sequences from the subsampled tree
      for ((ali=1;ali<=maxAli;ali++));
      do
        ~/pullseq/src/./pullseq -i ../alignments/b${batch}r${rep}a${ali}${gene}.fa -n b${batch}r${rep}s${sub}S${size}_keepTips.txt > b${batch}r${rep}a${ali}s${sub}${gene}S${size}.fa
      done
    done
  done
done
done
done
