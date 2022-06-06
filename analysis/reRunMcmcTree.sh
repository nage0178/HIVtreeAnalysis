#!/bin/bash


for line in $(cat runNames.txt)
do

	cd ~/HIVtreeAnalysis/analysis/mcmctree/${line}
	~/mcmctl/./mcmctree ../${line}.ctl &> output &

done
