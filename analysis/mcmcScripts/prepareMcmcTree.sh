#!/bin/bash

# Prepares files for mcmctree after the raxml tree has the outgroup removed 

maxBatch=20 # Should be 20
maxAli=30 # Should be ~30
maxRep=5 # Should be 5
maxSub=3 # Should be 3
seed=1

# For each batch (this is naming for tree simulation)
for ((batch=1;batch<=maxBatch;batch++));
do
	# For each rep (this is naming for tree simulation)
	for ((rep=1;rep<=maxRep;rep++));
	do
		# For each subsampling of the tree
		for ((sub=1;sub<=maxSub;sub++));
		do

			# For each gene/parameters combination
			for line in $(cat ~/HIVtreeAnalysis/dnaSimulations/ref_seq/seq_len.csv)
			do

				# Finds the gene, number of sequences, and sequence length
				pat='(.*),([0-9]+),([0-9]+)'
				[[ "$line" =~ $pat ]]

				gene=${BASH_REMATCH[1]}
				numSeq=${BASH_REMATCH[2]}
				seqLen=${BASH_REMATCH[3]}

				# For maxAli number of alignments
				for ((ali=1;ali<=maxAli;ali++));
				do
					# Strip branch lengths
					sed -E 's/:[0-9.Ee-]+//g' mcmctree/b${batch}r${rep}a${ali}s${sub}${gene}_rmOG.txt > mcmctree/b${batch}r${rep}a${ali}s${sub}${gene}_mcmc.txt
	
					# Adds the number of sequences and sequence length to the top of the fasta file
					sed "1s/^/${numSeq} ${seqLen} \n/" ~/HIVtreeAnalysis/dnaSimulations/alignments/b${batch}r${rep}a${ali}s${sub}${gene}.fa > mcmctree/b${batch}r${rep}a${ali}s${sub}${gene}_mcmc.fa
	
					# Adds the number of sequences and number of treees to the tree file
					sed -i "1s/^/${numSeq} 1\n/" mcmctree/b${batch}r${rep}a${ali}s${sub}${gene}_mcmc.txt
	
					# Makes a control file for each analysis
					cp generic.ctl mcmctree/b${batch}r${rep}a${ali}s${sub}${gene}_1.ctl
					sed -i "s/seqfile = generic.fa/seqfile = ..\/b${batch}r${rep}a${ali}s${sub}${gene}_mcmc.fa/g" mcmctree/b${batch}r${rep}a${ali}s${sub}${gene}_1.ctl
					sed -i "s/treefile = genericTree.txt/treefile = ..\/b${batch}r${rep}a${ali}s${sub}${gene}_mcmc.txt/g" mcmctree/b${batch}r${rep}a${ali}s${sub}${gene}_1.ctl
					sed -i "s/latentFile = genericLatent.txt/latentFile = ..\/b${batch}r${rep}a${ali}s${sub}_seqsL/g" mcmctree/b${batch}r${rep}a${ali}s${sub}${gene}_1.ctl
					
					cp mcmctree/b${batch}r${rep}a${ali}s${sub}${gene}_1.ctl mcmctree/b${batch}r${rep}a${ali}s${sub}${gene}_2.ctl

					sed -i "s/seed = -1/seed = ${seed}/g" mcmctree/b${batch}r${rep}a${ali}s${sub}${gene}_1.ctl
					((seed=seed+1))
					sed -i "s/seed = -1/seed = ${seed}/g" mcmctree/b${batch}r${rep}a${ali}s${sub}${gene}_2.ctl
					((seed=seed+1))

					# Makes a file with the names of the latent sequences for each analysis
					name=b${batch}r${rep}a${ali}s${sub}
					grep Node_*_1_*_* mcmctree/${name}C1V2_mcmc.fa > mcmctree/${name}_seqsL
					sed -i 's/>//g' mcmctree/${name}_seqsL 
	
					# Makes a directory for each mcmc run 
					mkdir mcmctree/${name}${gene}_1
					mkdir mcmctree/${name}${gene}_2
				done
			done
		done
	done
done


