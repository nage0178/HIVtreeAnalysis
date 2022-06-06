#!/bin/bash

maxBatch=20 # should be 20 
maxAli=30 #should be 30
maxRep=5 #should be 5
maxSub=3 #should be 3

mkdir dataSS
mkdir statsSS
mkdir outSS


# Runs the LR analysis for the datasets with varying number of sequences
for ((batch=1;batch<=maxBatch;batch++));
  do
  for ((ali=1;ali<=maxAli;ali++));
    do
    for gene in tat nef C1V2  p17
      do
      for ((rep=1;rep<=maxRep;rep++));
    	do
        for sampleSize in  10 15 20
 	 do
		dir=~/HIVtreeAnalysis/analysis/LR
		name=b${batch}r${rep}a${ali}s1${gene}S${sampleSize}

		if [ ! -f "${dir}/statsSS/${name}.csv" ]; 
		then
		#	echo  ${name}
		Rscript ~/phylodating/scripts/root_and_regress.R --runid ${name} --tree ${dir}/trees.rootedSS/${name}.rooted.nwk --rootedtree ${dir}/trees.rootedSS/${name}.rooted.nwk --info ${dir}/infoSS/${name}.csv --stats ${dir}/statsSS/${name}.csv --data ${dir}/dataSS/${name}.txt  &> outSS/${name}Out &
		fi
    done
  done
done
    wait $!
done
done
wait
