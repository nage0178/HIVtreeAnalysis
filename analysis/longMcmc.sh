#!/bin/bash

mkdir longMcmcPlots

# For each gene/parameters combination
for gene in tat nef C1V2 p17
do

	name=b1r1a1s1${gene}

	cp -r ~/HIVtreeAnalysis/analysis/mcmctree/${name}* longMcmcPlots
	cp ~/HIVtreeAnalysis/analysis/mcmctree/b1r1a1s1_seqsL longMcmcPlots/.
	rm -r longMcmcPlots/${name}*_2*
	sed -i 's/nsample = 100000/nsample = 500000/g' longMcmcPlots/${name}prior_1.ctl 
	sed -i 's/nsample = 30000/nsample = 500000/g' longMcmcPlots/${name}_1.ctl 

	cd ~/HIVtreeAnalysis/analysis/longMcmcPlots/${name}_1
	~/mcmctl/./mcmctree ../${name}_1.ctl &> output &


	cd ~/HIVtreeAnalysis/analysis/longMcmcPlots/${name}prior_1
	~/mcmctl/./mcmctree ../${name}prior_1.ctl &> output & 

	cd ../../

done


