#!/bin/bash


mkdir convergenceSSRerun
for line in $(cat runNamesSS.txt |awk -F '_' '{print $1}' | sort |uniq )
do
	pat='b([0-9]+)r([0-9]+)a([0-9]+)s([0-9]+)(.+)S(.+)'
	[[ "$line" =~ $pat ]]
	batch=${BASH_REMATCH[1]}
	rep=${BASH_REMATCH[2]}
	ali=${BASH_REMATCH[3]}
	sub=${BASH_REMATCH[4]}
	gene=${BASH_REMATCH[5]}
	sampleSize=${BASH_REMATCH[6]}


	# Find the mean times of the internal nodes in the tree for each replicate mcmc run
	echo node,run1,run2 > convergenceSSRerun/${line}.csv
	./mcmcScripts/checkConvergenceSSRerun.sh ${batch} ${rep} ${sub} ${gene} ${ali} ${sampleSize}& 
done

for line in $(cat runNamesSS.txt |awk -F '_' '{print $1}' | sort |uniq )
do
	# Summarize difference between mcmc runs
       	Rscript mcmcScripts/checkConvergPercent.R  convergenceSSRerun/${line}.csv 
done
