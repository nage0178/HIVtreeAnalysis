#!/bin/bash

# Roots every tree from raxml using root to tip regression

mkdir treesSS

maxBatch=20 # Should be 20
maxAli=30 # Should be 30
maxRep=5 # Should be 5
maxSub=3 # Should be 3

# For each batch (this is naming for tree simulation)
for ((batch=1;batch<=maxBatch;batch++));
do

  # For maxAli number of alignments
  for ((ali=1;ali<=maxAli;ali++));
  do

    # For each subsampling of the sampled tree
    for sampleSize in 10 15 20  
    do

      # For each rep (this is naming for tree simulation)
      for ((rep=1;rep<=maxRep;rep++));
      do

        # For each gene
        for gene in nef p17 tat C1V2
        do
		name=b${batch}r${rep}a${ali}s1${gene}S${sampleSize}

		if [ $sampleSize == 10 ]
		then
			cp trees/b${batch}r${rep}a${ali}s1${gene}.rooted treesSS/${name}.rooted
		else

			Rscript ../root.R ../raxmlSS/${name}.raxml.bestTree treesSS/${name}.rooted &
		fi
        done
      done
    done
    wait $!
  done
done
wait
