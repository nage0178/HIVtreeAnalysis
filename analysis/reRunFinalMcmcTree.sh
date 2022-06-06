#!/bin/bash


for line in $(cat runNames2.txt)
do
	name=b${batch}r${rep}a${ali}s${sub}${gene}

	cd ~/HIVtreeAnalysis/analysis/mcmctree/${line}
	~/mcmctl/./mcmctree ../${line}.ctl &> output &

done
