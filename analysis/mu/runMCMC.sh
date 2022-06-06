#!/bin/bash

for file in C1V2 nef p17 tat
do
	mkdir ${file}_g15
	cd ${file}_g15

	for outgroup in 1006 1018 CS2 PIC55751
	do
		for rep in 1 2 3 4 5 
		do 
			mkdir ${outgroup}_${rep}
			cd ${outgroup}_${rep}

			seed=$(grep ${file},${outgroup},${rep} ../../seed.txt |awk -F , '{print $4}')

			sed "s/seed = -1/seed = ${seed}/g" ../../../../data/longitudinal_lanl/${file}_${outgroup}_G15.ctl > ${file}_${outgroup}_G15_${rep}.ctl

			mcmctree ${file}_${outgroup}_G15_${rep}.ctl &> screen &

			cd ../
		done

	done
	cd ../
done

