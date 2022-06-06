#!/bin/bash

# Combines results from analyses on different alignments with the same tree 

maxBatch=20 # Should be 20
maxAli=30 # Should be ~30
maxRep=5 # Should be 5
maxSub=3 # Should be 3

mkdir resultsSS 
# For each batch (this is naming for tree simualation)
for ((batch=1;batch<=maxBatch;batch++));
do

  # For each gene
  for gene in nef p17 tat C1V2
  do

    # For each subsampling of the sampled tree
    for sampleSize in 10 15 20
    do

      # For each rep (this is naming for tree simualation)
      for ((rep=1;rep<=maxRep;rep++));
      do

	sub=1
	echo batch,rep,ali,sub,gene,sampleSize,nodeName,trueDate,nodeDate,lowCI,highCI > resultsSS/b${batch}r${rep}s${sub}${gene}S${sampleSize}_combine.csv
        # For maxAli number of alignments
        for ((ali=1;ali<=maxAli;ali++));
        do
	    name=b${batch}r${rep}a${ali}s${sub}${gene}S${sampleSize}

        	for line in $(tail -n +2 dataSS/${name}.txt)
		do
			pat='"(Node_1_[0-9]+_([0-9]+)_[0-9]+)",([0-9]+),[0-1],(-?[0-9]+.?[0-9]+),(-?[0-9]+.?[0-9]+),(-?[0-9]+.?[0-9]+)'
			if [[ "$line" =~ $pat ]]; then
			echo ${batch},${rep},${ali},${sub},${gene},${sampleSize},${BASH_REMATCH[1]},${BASH_REMATCH[2]},${BASH_REMATCH[4]},${BASH_REMATCH[5]},${BASH_REMATCH[6]}>> resultsSS/b${batch}r${rep}s${sub}${gene}S${sampleSize}_combine.csv 
			fi 
		done
        done
      done
    done
    wait $!
  done
done
wait
