#!/bin/bash

maxBatch=20 # Should be 20
maxAli=30 # Should be 30
maxRep=5 # Should be 5
maxSub=3 # Should be 3

mkdir trees.rooted

# Removes the outgroup from the trees inferred by RAxML
# For each batch (this is naming for tree simulation)
for ((batch=1;batch<=maxBatch;batch++));
do
  # For each rep (this is naming for tree simulation)
  for ((rep=1;rep<=maxRep;rep++));
  do
    for ((sub=1;sub<=maxSub;sub++));
    do

    # For each gene/parameters combination
    for gene in C1V2 tat nef p17
    do

      # For maxAli number of alignments
      for ((ali=1;ali<=maxAli;ali++));
      do
	# Removes the outgroup and reroots the tree 
	name=b${batch}r${rep}a${ali}s${sub}${gene}
	Rscript ../root.R ../raxml/${name}.raxml.bestTree trees.rooted/${name}.rooted.nwk &

      done
    done
    wait $!
  done
done
done
wait


