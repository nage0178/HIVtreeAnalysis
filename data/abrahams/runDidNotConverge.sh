#!/bin/bash


#  For the runs that did not converge, increase the
# length mcmc and re-run

for name in 217_ENV2_d20_0.75 257_ENV3_d20_0.75
do

	cd ~/HIV_latency_general/data/abrahams
	mv mcmctree/${name}_1 mcmctree/${name}Old_1
	mv mcmctree/${name}_2 mcmctree/${name}Old_2

	cd mcmctree
	mkdir ${name}_1
	mkdir ${name}_2
	cd ~/HIV_latency_general/data/abrahams
	
	sed -i 's/nsample = 80000/nsample = 150000/g' mcmctree/${name}_1.ctl
	sed -i 's/nsample = 80000/nsample = 150000/g' mcmctree/${name}_2.ctl

	cd  ~/HIV_latency_general/data/abrahams/mcmctree/${name}_1
	~/mcmctl/./mcmctree ../${name}_1.ctl &> output &

	cd ~/HIV_latency_general/data/abrahams/mcmctree/${name}_2
	~/mcmctl/./mcmctree ../${name}_2.ctl &> output &

done

wait;
