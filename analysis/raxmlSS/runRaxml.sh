#!/bin/bash

seed=1

maxBatch=20 # Should be 20
maxAli=30 # Should be ~30
maxRep=5 # Should be 5


# Runs Raxml for each of the simulated data sets 
# First check to see if there is an existing raxml tree before running raxml
# This is because the script did not finish running and had to be restarted 

# trees in number of starting trees, parsimony + random
# msa is alignment
# model is substition model, could do Gn{a} where a is the number of rate categories
for ((ali=1;ali<=maxAli;ali++));
do
  for gene in nef tat p17 C1V2
  do
      for ((rep=1;rep<=maxRep;rep++));
      do
        for size in 15 20 
        do
		sub=1
          for ((batch=1;batch<=maxBatch;batch++));
          do
             raxml-ng --msa ~/HIVtreeAnalysis/dnaSimulations/sampleSize/b${batch}r${rep}a${ali}s${sub}${gene}S${size}.fa --model HKY+G --prefix b${batch}r${rep}a${ali}s${sub}${gene}S${size} --threads 1 --seed ${seed} --tree pars{25},rand{25} --outgroup outgroup &> b${batch}r${rep}a${ali}s${sub}${gene}S${size}raxmlOut &

        done
      done
      wait $!
    done
  done
done
