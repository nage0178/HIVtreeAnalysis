#!/bin/bash


seed=1
mkdir mcmctree

for pt in p1 p2
do

	# Finds the sequence length 
        if [ $pt == p1 ]
        then
                seqLen=621
        else
                seqLen=618
        fi
	numSeq=$(wc runFiles/${pt}_HKYSeqs | awk '{print $1}')

	for line in $(cat runFiles/${pt}_HKYSeqs)
        do
                latent=$(grep ${line} info/${pt}_HKY.csv | awk -F , '{print $3}')

                # Adds the constraints to the datefile
                if [ $latent == 1 ]
                then
			echo ${line}>> mcmctree/${pt}_seqsL
                fi
        done

	# Strip branch lengths
	sed -E 's/:[0-9.Ee-]+//g' trees.rooted.rtt/${pt}_HKY.rooted > mcmctree/${pt}_mcmc.txt

	# Adds the number of sequences and sequence length to the top of the fasta file
	sed "1s/^/${numSeq} ${seqLen} \n/" ${pt}_alignment_date.fa > mcmctree/${pt}_mcmc.fa

	# Adds the number of sequences and number of treees to the tree file
	sed -i "1s/^/${numSeq} 1\n/" mcmctree/${pt}_mcmc.txt

	# Makes a control file for each analysis
	cp generic.ctl mcmctree/${pt}_1.ctl
	sed -i "s/seqfile = generic.fa/seqfile = ..\/${pt}_mcmc.fa/g" mcmctree/${pt}_1.ctl
	sed -i "s/treefile = genericTree.txt/treefile = ..\/${pt}_mcmc.txt/g" mcmctree/${pt}_1.ctl
	sed -i "s/latentFile = genericLatent.txt/latentFile = ..\/${pt}_seqsL/g" mcmctree/${pt}_1.ctl

	# Root age, maybe three years prior to infections time?
	if [ $pt == p1 ]
	then
		# 10 years prior to diagnosis. First sample is same time as diagnosis, which is day 1
		# Last sample is day 7262
		# (7.262 -.001 )  + 3.650 = 10.911 
		sed -i 's/latentBound = 0/latentBound = 10.911/g' mcmctree/${pt}_1.ctl

		# The mean is three years before first sample which is also the diagnosis date
		# (7.262 - .001) + 3 * .365 = 8.356 = mean INCORRECT
		# The root age is relative to first sample time, so mean = 3*.365 = 1.095
		sed -i 's/RootAge = G(365,100)/RootAge = G(8,60)/g' mcmctree/${pt}_1.ctl
	else
		# Last sample is day 7126
		# 10 years prior to diagnosis (diagnosed 1.83 years prior to first sample, first sample is at day 1)
		# (7.126 -.001) +1.83 + 3.65 = 12.605
		sed -i 's/latentBound = 0/latentBound = 12.605/g' mcmctree/${pt}_1.ctl
		# Mean is 3 years prior to diagnosis. Variance is 3 years
		# (7.126 - .001) + 3 * .365 = 8.22 = mean
		# 3 * .365  + 1.83 *365/ 1000 = 1.76 = mean

		sed -i 's/RootAge = G(365,100)/RootAge = G(15,50)/g' mcmctree/${pt}_1.ctl
	fi
					
	cp mcmctree/${pt}_1.ctl mcmctree/${pt}_2.ctl

	sed -i "s/seed = -1/seed = ${seed}/g" mcmctree/${pt}_1.ctl
	((seed=seed+1))
	sed -i "s/seed = -1/seed = ${seed}/g" mcmctree/${pt}_2.ctl
	((seed=seed+1))

	# Makes a file with the names of the latent sequences for each analysis
	#sed -i 's/>//g' mcmctree/${name}_seqsL 

	# Makes a directory for each mcmc run 
	mkdir mcmctree/${pt}_1
	mkdir mcmctree/${pt}_2



done


