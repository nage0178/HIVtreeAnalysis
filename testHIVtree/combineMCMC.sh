#!/bin/bash

maxReps=4000
cat dnaSim/1/run1/mcmc.txt > allMCMC.txt
Rscript checkConvergence.R > notConverged

for ((reps=2;reps<=${maxReps};reps++));
do 
	if  ! grep -q -w $reps notConverged 
	then
#		echo $reps
		tail -n+3 dnaSim/$reps/run1/mcmc.txt >> allMCMC.txt
	fi
done

awk '{$1=""; print NR "\t" $0}' allMCMC.txt  > outputFile
sed -i 's/ /\t/g' outputFile
sed -i 's/\t\t/\t/g' outputFile
