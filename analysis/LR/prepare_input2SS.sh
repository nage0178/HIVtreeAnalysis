#!/bin/bash

maxBatch=20 # should be 20 
maxAli=30  #should be 30
maxRep=5 #should be 5
maxSub=3 #should be 3

mkdir infoSS

# Makes a csv for each dataset that is needed to run the LR method
for ((batch=1;batch<=maxBatch;batch++));
  do
  for ((rep=1;rep<=maxRep;rep++));
    do
    for sampleSize in 10 15 20
      do
      for ((ali=1;ali<=maxAli;ali++));
    	do
        for gene in nef tat p17 C1V2
	do
	  	name=b${batch}r${rep}a${ali}s1${gene}S${sampleSize}
		if [ ${sampleSize} == 10 ]
		then
			shortName=b${batch}r${rep}a${ali}s1${gene}

			cp info/${shortName}.csv infoSS/${name}.csv
		else

          		./LR_csvSS.sh ${name} alignedSS/${name}.fa ${name}&
   	  		rm names_${name}
		fi
    done
  done
  wait $!
done
done
done
wait 
