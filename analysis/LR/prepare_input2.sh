#!/bin/bash

maxBatch=20 # should be 20 
maxAli=30  #should be ~30
maxRep=5 #should be 5
maxSub=3 #should be 3

mkdir info 

# Makes a csv file need for the LR analysis for each dataset 
for ((batch=1;batch<=maxBatch;batch++));
  do
  for ((rep=1;rep<=maxRep;rep++));
    do
    for ((sub=1;sub<=maxSub;sub++));
      do
      for ((ali=1;ali<=maxAli;ali++));
    	do
        for gene in nef tat p17 C1V2
	do
          ./LR_csv.sh b${batch}r${rep}a${ali}s${sub}${gene} aligned/b${batch}r${rep}a${ali}s${sub}${gene}.fa b${batch}r${rep}a${ali}s${sub}${gene}&
   	  rm names_b${batch}r${rep}a${ali}s${sub}${gene}
    done
  done
done
done
done
wait 
