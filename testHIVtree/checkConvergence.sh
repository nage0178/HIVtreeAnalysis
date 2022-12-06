#!/bin/bash

maxReps=4000
rm -f run1 run2
for ((reps=1;reps<=${maxReps};reps++));
do 
	tail -n 12 dnaSim/${reps}/run1/output | head -n 5 | awk -v r=${reps} '{print r "\t"  $2 "\t" $4  "\t" $5}' | sed 's/,//g' |sed 's/)//g' >> run1

	tail -n 12 dnaSim/${reps}/run2/output | head -n 5 | awk -v r=${reps} '{print r "\t"  $2 "\t" $4  "\t" $5}' | sed 's/,//g' |sed 's/)//g' >> run2
done


