#!/bin/bash


# For each batch (this is naming for tree simualation)
for pt in p1 p2 
do

	cd ~/HIVtreeAnalysis/data/jones/mcmctree/${pt}_1
	~/mcmctl/./mcmctree ../${pt}_1.ctl &> output &

	cd ~/HIVtreeAnalysis/data/jones/mcmctree/${pt}_2
	~/mcmctl/./mcmctree ../${pt}_2.ctl &> output &



done


