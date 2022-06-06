#!/bin/bash


maxBatch=20 # Should be 20
maxAli=30 # Should be ~30
maxRep=5 # Should be 5
maxSub=3 # Should be 3

# This runs the MCMC run the prior for each of that data sets

# For each batch (this is naming for tree simualation)
for ((batch=1;batch<=maxBatch;batch++));
do
  # For each rep (this is naming for tree simualation)
  for ((rep=1;rep<=maxRep;rep++));
  do
    for ((sub=1;sub<=maxSub;sub++));
    do

    # For each gene/parameters combination
    for gene in tat nef C1V2 p17
    do

      # For maxAli number of alignments
      for ((ali=1;ali<=maxAli;ali++));
      do
	name=b${batch}r${rep}a${ali}s${sub}${gene}

	cd ~/HIVtreeAnalysis/analysis/mcmctree/${name}prior_1
	~/mcmctl/./mcmctree ../b${batch}r${rep}a${ali}s${sub}${gene}prior_1.ctl &> output &

#        cd ../${name}_2
#	~/mcmctl/./mcmctree ../b${batch}r${rep}a${ali}s${sub}${gene}_2.ctl &> output & 


      done
      #wait $!
    done
      wait $!
  done
done
done


