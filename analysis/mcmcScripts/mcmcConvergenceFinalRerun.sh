#!/bin/bash

mkdir convergenceRerunFinal
for line in $(cat runNames2.txt)
do
	pat='b([0-9]+)r([0-9]+)a([0-9]+)s([0-9]+)(.+)_([1-2])'
	[[ "$line" =~ $pat ]]
	batch=${BASH_REMATCH[1]}
	rep=${BASH_REMATCH[2]}
	ali=${BASH_REMATCH[3]}
	sub=${BASH_REMATCH[4]}
	gene=${BASH_REMATCH[5]}
	run=${BASH_REMATCH[6]}

	if [[ $run == 1 ]]
	then
		# Find the mean times of the internal nodes in the tree for each replicate mcmc run
		echo node,run1,run2 > convergenceRerunFinal/b${batch}r${rep}a${ali}s${sub}${gene}.csv
		./mcmcScripts/checkConvergenceRerunFinal.sh ${batch} ${rep} ${sub} ${gene} ${ali}
	fi

done

for line in $(cat runNames2.txt)
do
	
	pat='b([0-9]+)r([0-9]+)a([0-9]+)s([0-9]+)(.+)_([1-2])'
	[[ "$line" =~ $pat ]]
	batch=${BASH_REMATCH[1]}
	rep=${BASH_REMATCH[2]}
	ali=${BASH_REMATCH[3]}
	sub=${BASH_REMATCH[4]}
	gene=${BASH_REMATCH[5]}
	run=${BASH_REMATCH[6]}

	if [[ $run == 1 ]]
	then

		# Summarize difference between mcmc runs
		Rscript mcmcScripts/checkConverg.R convergenceRerunFinal/b${batch}r${rep}a${ali}s${sub}${gene}.csv 
	fi

done
