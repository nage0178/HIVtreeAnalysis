#!/bin/bash

mkdir convergence

for name in p1 p2
do
	# Find the mean times of the internal nodes in the tree for each replicate mcmc run
	echo node,run1,run2 > convergence/${name}.csv
	./checkConvergence.sh ${name} & 

done

for name in p1 p2
do

	# Summarize difference between mcmc runs
        Rscript checkConverg.R  convergence/${name}.csv 

done
