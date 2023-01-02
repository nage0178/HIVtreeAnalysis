#!/bin/bash

maxBatch=20 # Should be 20
maxRep=5 # Should be 5
maxSub=1 # Should be 3

# Calculates some summary statistics for each set of analyses using an R script
  for gene in nef tat p17 C1V2
  do
      for ((rep=1;rep<=maxRep;rep++));
      do
        for ((sub=1;sub<=maxSub;sub++));
        do
          for ((batch=1;batch<=maxBatch;batch++));
          do
		  for sampleSize in 10 15 20
		  do
		name=b${batch}r${rep}s${sub}${gene}S${sampleSize}
		Rscript summaryStats.R LS/resultsSS/${name}_combine.csv summarySS/${name}_summaryLS.csv 1 &> summarySS/${name}summaryLS &
		Rscript summaryStats.R LR/resultsSS/${name}_combine.csv summarySS/${name}_summaryLR.csv 1 &> summarySS/${name}summaryLR &
		Rscript summaryStats.R ML/resultsSS/${name}_combine.csv summarySS/${name}_summaryML.csv 0 &> summarySS/${name}summaryML &
		if [ $gene == p17 ] && [ $sub == 1 ] && [ $sampleSize != 10 ];
		then

		Rscript summaryStats.R resultsMCMCSS/${name}_combine.csv summarySS/${name}_summaryBayes.csv 1 &> summarySS/${name}summaryBayes &
		fi
	done
       	done
      done
      wait $!
    done
  done
