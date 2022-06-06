#!/bin/bash


for line in $(cat runNamesSS.txt)
do

	cd ~/HIVtreeAnalysis/analysis/mcmctreeSS/${line}
	~/mcmctl/./mcmctree ../${line}.ctl &> output &

done
