#!/bin/bash

# Combines the results from each analysis into a csv file for each fixed tree for each gene

maxBatch=20 # Should be 20
maxAli=30 # Should be 30
maxRep=5 # Should be 5
maxSub=3 # Should be 3

# For each gene
for gene in nef p17 tat C1V2
do
  
  # For each batch (this is naming for tree simulation)
  for ((batch=1;batch<=maxBatch;batch++));
  do

    # For each subsampling of the sampled tree
    for ((sub=1;sub<=maxSub;sub++));
    do

      # For each rep (this is naming for tree simulation)
      for ((rep=1;rep<=maxRep;rep++));
      do

	echo batch,rep,ali,sub,gene,nodeName,trueDate,nodeDate,lowCI,highCI > results/b${batch}r${rep}s${sub}${gene}_combine.csv

  	# For maxAli number of alignments
        for ((ali=1;ali<=maxAli;ali++));
        do
          name=b${batch}r${rep}a${ali}s${sub}${gene}

	  for line in $(tail -n +2 results/${name}_results.csv)
          do

           echo ${batch},${rep},${ali},${sub},${gene},${line} >> results/b${batch}r${rep}s${sub}${gene}_combine.csv
          done

        done
      done
    done

  done
done
