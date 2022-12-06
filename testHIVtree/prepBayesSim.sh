#!/bin/bash

mkdir dnaSim
./simulateParameters > parameters.txt
awk '{print "(1:1825.0,(3:"  $4 ",(5:"  $3 ",6:" $3 ")4:" $6 ")2:" $5 ")0:0.0" }' parameters.txt > trees.txt

seed=1
maxReps=4000
for ((reps=1;reps<=${maxReps};reps++));
do 
	
	mkdir dnaSim/$reps
	head -n $reps trees.txt |tail -n 1 > dnaSim/${reps}/simTree.txt
	truncate -s -1 dnaSim/${reps}/simTree.txt #> dnaSim/${reps}/simTree.txt

	tLatent=$(head -n $reps parameters.txt |tail -n 1 |awk '{print $2}')
	mu=$(head -n $reps parameters.txt |tail -n 1 |awk '{print $1}')
	sed "s/L6/${tLatent}/g" latentGeneric.txt > dnaSim/${reps}/latent.txt

	cd dnaSim/$reps
	~/HIVtreeSimulations/dnaSim/./dna_sim -l latent.txt -t simTree.txt -o ${reps} -b 1000 -s ${seed} -u ${mu}

	sed -E 's/:[0-9.Ee-]+//g' ${reps}Tree.txt > mcmcTree.txt

	# Adds the number of sequences and number of treees to the tree file
	sed -i "1s/^/4 1\n/" mcmcTree.txt

	# Adds the number of sequences and the sequence length to the sequence file
	sed -i "1s/^/4 1000\n/" ${reps}.fa

	grep Node_*_1_*_* ${reps}.fa |sed 's/>//g'> seqsL.txt

	cd ../../

	sed "s/generic.fa/${reps}.fa/g" generic.ctl > dnaSim/${reps}/run1.ctl
	((seed=seed+1))

done

seed=1
for ((reps=1;reps<=${maxReps};reps++));
do 
	cd dnaSim/$reps
	mkdir run1 run2

	cp run1.ctl run2.ctl

	sed -i "s/-1/${seed}/g" run1.ctl
	((seed=seed+1))

	sed -i "s/-1/${seed}/g" run2.ctl
	((seed=seed+1))

	cd ../../
done
