#!/bin/bash

# Combines the results from every tree with a fixed topology for a given gene

mkdir resultsSS

maxBatch=20 # Should be 20
maxAli=30 # Should be 30
maxRep=5 # Should be 5
sub=1 # Should be 1

# For each batch (this is naming for tree simulation)
for ((batch=1;batch<=maxBatch;batch++));
do

  # For each gene
  for gene in nef p17 tat C1V2
  do

    # For each subsampling of the sampled tree
    for sampleSize in 10 15 20
    do

      # For each rep (this is naming for tree simulation)
      for ((rep=1;rep<=maxRep;rep++));
      do

	echo batch,rep,ali,sub,gene,sampleSize,nodeName,trueDate,nodeDate > resultsSS/b${batch}r${rep}s${sub}${gene}S${sampleSize}_combine.csv

        # For maxAli number of alignments
        for ((ali=1;ali<=maxAli;ali++));
        do
	    name=b${batch}r${rep}a${ali}s1${gene}S${sampleSize}

        	for line in $(tail -n +2 outfilesSS/${name}.data.csv)
		do
			pat='"(Node_1_[0-9]+_([0-9]+)_[0-9]+)",[0-1],[0-9]+,.*,1,(-?[0-9]+.?[0-9]+),.*'
			if [[ "$line" =~ $pat ]]; then
			echo ${batch},${rep},${ali},${sub},${gene},${sampleSize},${BASH_REMATCH[1]},${BASH_REMATCH[2]},${BASH_REMATCH[3]} >> resultsSS/b${batch}r${rep}s1${gene}S${sampleSize}_combine.csv 
			fi 
		done
        done
      done
    done
    wait $!
  done
done
wait
