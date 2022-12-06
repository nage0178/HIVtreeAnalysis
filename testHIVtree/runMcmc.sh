#!/bin/bash

maxReps=4000
for ((reps=1;reps<=${maxReps};reps++));
do 
	cd dnaSim/$reps/run1
	~/HIVtree/./HIVtree ../run1.ctl &> output & 

	cd ../run2
	~/HIVtree/./HIVtree ../run2.ctl &> output & 

	cd ../../../
done
wait 
