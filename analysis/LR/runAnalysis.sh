#!/bin/bash

maxBatch=20 # should be 20 
maxAli=30 #should be 30
maxRep=5 #should be 5
maxSub=3 #should be 3

mkdir data
mkdir stats
mkdir out

# Runs the LR analysis for all of the datasets
for ((batch=1;batch<=maxBatch;batch++));
  do
  for ((ali=1;ali<=maxAli;ali++));
    do
    for gene in tat nef p17 C1V2
      do
      for ((rep=1;rep<=maxRep;rep++));
    	do
        for ((sub=1;sub<=maxSub;sub++));
 	 do
		dir=~/HIVtreeAnalysis/analysis/LR
		name=b${batch}r${rep}a${ali}s${sub}${gene}

		Rscript ~/phylodating/scripts/root_and_regress.R --runid ${name} --tree ${dir}/trees.rooted/${name}.rooted.nwk --rootedtree ${dir}/trees.rooted/${name}.rooted.nwk --info ${dir}/info/${name}.csv --stats ${dir}/stats/${name}.csv --data ${dir}/data/${name}.txt &> out/${name}Out &
    done
  done
done
    wait $!
done
done
wait
