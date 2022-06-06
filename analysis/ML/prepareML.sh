#!/bin/bash

# Makes a csv file for each alignment. 
# This is needed to run the method

mkdir screen 
mkdir info

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
		./mk_csv.sh ~/HIVtreeAnalysis/dnaSimulations/alignments/${name}.fa ${name} &> screen/${name}_mkcsv &
        done
      done
    done
    wait $!
  done
done
wait
