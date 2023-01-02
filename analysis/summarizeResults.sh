#!/bin/bash

maxBatch=20 # Should be 20
maxRep=5 # Should be 5
maxSub=3 # Should be 3

# Calculates some summary statistics for each set of analyses on a fixed tree using an R script
  for gene in nef tat p17 C1V2
  do
      for ((rep=1;rep<=maxRep;rep++));
      do
        for ((sub=1;sub<=maxSub;sub++));
        do
          for ((batch=1;batch<=maxBatch;batch++));
          do
		name=b${batch}r${rep}s${sub}${gene}
		Rscript summaryStats.R LS/results/${name}_combine.csv summary/${name}_summaryLS.csv 1 &> summary/${name}summaryLS &
		Rscript summaryStats.R ML/results/${name}_combine.csv summary/${name}_summaryML.csv 0 &> summary/${name}summaryML &
		Rscript summaryStats.R LR/results/${name}_combine.csv summary/${name}_summaryLR.csv 1 &> summary/${name}summaryLR &
		Rscript summaryStats.R resultsBound/${name}_combine.csv summary/${name}_summaryBayes.csv 1 &> summary/${name}summaryBayes &
       	done
      done
      wait $!
    done
  done


for ((rep=1;rep<=maxRep;rep++));
do
	for ((batch=1;batch<=maxBatch;batch++));
	do
		sub=1
		name=b${batch}r${rep}s${sub}combine
	
		Rscript summaryStats.R rmNAcombineGeneFiles/${name}.csv summary/${name}_summaryBayesCombine.csv 1 &> summary/${name}summaryBayesCombine &
		Rscript summaryStats.R rmNAcombineGeneFiles/${name}2.csv summary/${name}_summaryBayesCombine2.csv 1 &> summary/${name}summaryBayesCombine2 &
	done
done
