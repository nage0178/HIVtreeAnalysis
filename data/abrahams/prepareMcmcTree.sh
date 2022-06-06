#!/bin/bash

seed=1
mkdir mcmctree

# Creates the control files for all of the MCMCs 
for file in 217_ENV2 217_ENV3 217_ENV4 257_ENV2 257_ENV3 257_ENV4 257_GAG1 257_NEF1
do
	# For each number of sequences subsampled
	for numSub in 10 15 20
	do
		# For each level of gap stripping
		for filter in 0.75 0.85 0.95
		do 
			name=${file}_d${numSub}_${filter}
                        if test -f "raxml/${name}.raxml.bestTree"; then

			grep ">" alignmentsSub/${name}.fa | sed 's/>//g' > runFiles/${name}Seqs
			
			# Finds the sequence length 
			numSeq=$(wc runFiles/${name}Seqs | awk '{print $1}')

			for line in $(cat runFiles/${name}Seqs)
        		do
				latent=$(grep ${line} infoML/${name}.csv | awk -F , '{print $3}')

                		# Adds the constraints to the datefile
                		if [ $latent == 1 ]
               			then
					echo ${line}>> mcmctree/${name}_seqsL
                		fi
        		done

			# This is the earliest sample date. This is because the bound is relative to the first sample time
			lastSample=$(grep QVOA alignmentsSub/${name}.fa |head -1 | awk -F _ '{print $NF}')
			firstSample=$(grep DPI alignmentsSub/${name}.fa | sed 's/DPI//g' |awk -F _ '{print $8}' |sort -n |head -1)

			var=.00365
			timeScale=1000
			alphaBeta=$(Rscript findAlphaBeta.R $firstSample $var $timeScale $lastSample| awk '{print $2}') 

			lastSampleScale=$(echo $alphaBeta | awk '{print $3}')

			# Finds the name of the first sequence in the sequence file
		        # Then finds the length of the sequence (must subtract number of lines
		        # because of newline character)

			firstSeq=$(grep ">" alignmentsSub/${name}.fa | sed 's/>//g' |head -1)
			line=$(~/pullseq/src/./pullseq -i alignmentsSub/${name}.fa -g ${firstSeq} |tail -n +2 |wc -l)
			char=$(~/pullseq/src/./pullseq -i alignmentsSub/${name}.fa -g ${firstSeq} |tail -n +2 |wc -c)
			seqLen=$((char-line))


			# Strip branch lengths
			sed -E 's/:[0-9.Ee-]+//g' trees.rooted.rtt/${name}.rooted > mcmctree/${name}_mcmc.txt

			# Adds the number of sequences and sequence length to the top of the fasta file
			sed "1s/^/${numSeq} ${seqLen} \n/" alignmentsSub/${name}.fa > mcmctree/${name}_mcmc.fa

			# Adds the number of sequences and number of treees to the tree file
			sed -i "1s/^/${numSeq} 1\n/" mcmctree/${name}_mcmc.txt

			# Makes a control file for each analysis
			cp generic.ctl mcmctree/${name}_1.ctl
			sed -i "s/seqfile = generic.fa/seqfile = ..\/${name}_mcmc.fa/g" mcmctree/${name}_1.ctl
			sed -i "s/treefile = genericTree.txt/treefile = ..\/${name}_mcmc.txt/g" mcmctree/${name}_1.ctl
			sed -i "s/latentFile = genericLatent.txt/latentFile = ..\/${name}_seqsL/g" mcmctree/${name}_1.ctl

			sed -i "s/latentBound = 0/latentBound = ${lastSampleScale}/g" mcmctree/${name}_1.ctl

			cp mcmctree/${name}_1.ctl mcmctree/${name}_2.ctl

			sed -i "s/seed = -1/seed = ${seed}/g" mcmctree/${name}_1.ctl
			((seed=seed+1))
			sed -i "s/seed = -1/seed = ${seed}/g" mcmctree/${name}_2.ctl
			((seed=seed+1))


			# Makes a directory for each mcmc run 
			mkdir mcmctree/${name}_1 
			mkdir mcmctree/${name}_2 

			fi
		done
	done 
done


