#!/bin/bash

# Runs the node dating analysis for every tree/alignment

mkdir outfiles

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
    for ((sub=1;sub<=maxSub;sub++));
    do

      # For each rep (this is naming for tree simulation)
      for ((rep=1;rep<=maxRep;rep++));
      do

        # For each gene
        for gene in nef p17 tat C1V2
        do
		name=b${batch}r${rep}a${ali}s${sub}${gene}
		Rscript new.dating.R --tree trees/${name}.rooted --info info/${name}.csv --timetree outfiles/${name}.timetree --data outfiles/${name}.data.csv --stats outfiles/${name}.stats.csv --patid ${name} &> outfiles/${name}out &
        done
      done
    done
    wait $!
  done
done
wait
