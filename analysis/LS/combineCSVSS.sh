#!/bin/bash

maxBatch=20 # Should be 20
maxAli=30 # Should be ~30
maxRep=5 # Should be 5
maxSub=1 # Should be 3

for gene in nef p17 tat C1V2
do
  
  # For each batch (this is naming for tree simualation)
  for ((batch=1;batch<=maxBatch;batch++));
  do

    # For each subsampling of the sampled tree
    for ((sub=1;sub<=maxSub;sub++));
    do

      # For each rep (this is naming for tree simualation)
      for ((rep=1;rep<=maxRep;rep++));
      do

	for sampleSize in 10 15 20
	do
		echo batch,rep,ali,sub,gene,sampleSize,nodeName,trueDate,nodeDate,lowCI,highCI > resultsSS/b${batch}r${rep}s${sub}${gene}S${sampleSize}_combine.csv

  		# For maxAli number of alignments
        	for ((ali=1;ali<=maxAli;ali++));
        	do
          		name=b${batch}r${rep}a${ali}s${sub}${gene}S${sampleSize}

	  		for line in $(tail -n +2 resultsSS/${name}_results.csv)
          		do

           			echo ${batch},${rep},${ali},${sub},${gene},${sampleSize},${line} >> resultsSS/b${batch}r${rep}s${sub}${gene}S${sampleSize}_combine.csv
          		done
	  	done
        done
      done
    done
  done
done
