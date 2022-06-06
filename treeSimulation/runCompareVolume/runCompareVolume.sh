#!/bin/bash
for vol in 2.5 5 10 20 30 40 50 60 70 80 90 100
do
	mkdir vol_${vol}
	cd vol_${vol}	
	
	for rep in 1 2 3 4 5 6 7 8 9 10
	do

		mkdir run$rep
		cd run${rep}
		cp ../../pt7.ctrl .
		seed=$(grep ${vol},${rep}, ../../seeds.txt | awk -F , '{print $3}') 
		echo seed = ${seed} >> pt7.ctrl
		cd ../
	done
	cd ../
done

for rep in 1 2 3 4 5 6 7 8 9 10
do
	
	for vol in 2.5 5 10 20 30 40 50 60 70 80 90 100
	do
		cd vol_${vol}/run${rep}
                ~/HIVtreeSimulations/treeSim/./HIV_treeSim -c pt7.ctrl -v ${vol} &> screen &
		cd ../../

	done
	wait 
done
