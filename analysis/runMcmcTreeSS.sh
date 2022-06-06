#!/bin/bash


maxBatch=20 # Should be 20
maxAli=30 # Should be ~30
maxRep=5 # Should be 5
maxSub=1 # Should be 3


# For each batch (this is naming for tree simualation)
for ((batch=1;batch<=maxBatch;batch++));
do
  # For each rep (this is naming for tree simualation)
  for ((rep=1;rep<=maxRep;rep++));
  do
	  sub=1
    for size in 15 20
    do

    # For each gene/parameters combination
    for gene in p17
    do

      # For maxAli number of alignments
      for ((ali=1;ali<=maxAli;ali++));
      do
	name=b${batch}r${rep}a${ali}s${sub}${gene}S${size}

	cd ~/HIVtreeAnalysis/analysis/mcmctreeSS/${name}_1
	~/mcmctl/./mcmctree ../b${batch}r${rep}a${ali}s${sub}${gene}_1.ctl &> output &

        cd ../${name}_2
	~/mcmctl/./mcmctree ../b${batch}r${rep}a${ali}s${sub}${gene}_2.ctl &> output & 


      done
    done
      wait $!
  done
done
done


