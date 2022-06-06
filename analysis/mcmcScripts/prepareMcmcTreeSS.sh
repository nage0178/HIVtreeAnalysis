#!/bin/bash

# Prepares files for mcmctree after the raxml tree has the outgroup removed 

maxBatch=30 # Should be 20
maxAli=20 # Should be ~30
maxRep=5 # Should be 5
maxSub=1 # Should be 1
seed=1
mkdir mcmctreeSS
mkdir mcmctreeSS/alignmentsSS
cp -R LS/alignmentsSS/*p17S15*txt mcmctreeSS/alignmentsSS
cp -R LS/alignmentsSS/*p17S20*txt mcmctreeSS/alignmentsSS

# For each batch (this is naming for tree simulation)
for ((batch=1;batch<=maxBatch;batch++));
do
	# For each rep (this is naming for tree simulation)
	for ((rep=1;rep<=maxRep;rep++));
	do
		# For each subsampling of the tree
		for ((sub=1;sub<=maxSub;sub++));
		do
			for sampleSize in 15 20 # 10
			do

				# For each gene/parameters combination
				for line in $(cat ~/HIVtreeAnalysis/dnaSimulations/ref_seq/seq_len.csv|head -3 |tail -n 1)
				do

					# Finds the gene, number of sequences, and sequence length
					pat='(.*),([0-9]+),([0-9]+)'
					[[ "$line" =~ $pat ]]

					# NEED TO FIX THIS PART
					gene=${BASH_REMATCH[1]}
					#numSeq=${BASH_REMATCH[2]}
					seqLen=${BASH_REMATCH[3]}

					# For maxAli number of alignments
					for ((ali=1;ali<=maxAli;ali++));
					do
						name=b${batch}r${rep}a${ali}s${sub}${gene}S${sampleSize}
						nameShort=b${batch}r${rep}a${ali}s${sub}

						numSeq=$(grep ">" ~/HIVtreeAnalysis/dnaSimulations/sampleSize/${name}.fa |grep -v outgroup |wc -l)

						# Strip branch lengths
						sed -E 's/:[0-9.Ee-]+//g' mcmctreeSS/alignmentsSS/${name}_rmOG.txt > mcmctreeSS/${name}_mcmc.txt

						# Adds the number of sequences and sequence length to the top of the fasta file
						sed "1s/^/${numSeq} ${seqLen} \n/" ~/HIVtreeAnalysis/dnaSimulations/sampleSize/${name}.fa > mcmctreeSS/${name}_mcmc.fa

						# Adds the number of sequences and number of treees to the tree file
						sed -i "1s/^/${numSeq} 1\n/" mcmctreeSS/${name}_mcmc.txt

						# Makes a control file for each analysis
						cp genericSS.ctl mcmctreeSS/${name}_1.ctl
						sed -i "s/seqfile = generic.fa/seqfile = ..\/${name}_mcmc.fa/g" mcmctreeSS/${name}_1.ctl
						sed -i "s/treefile = genericTree.txt/treefile = ..\/${name}_mcmc.txt/g" mcmctreeSS/${name}_1.ctl
						sed -i "s/latentFile = genericLatent.txt/latentFile = ..\/${nameShort}S${sampleSize}_seqsL/g" mcmctreeSS/${name}_1.ctl
						
						cp mcmctreeSS/${name}_1.ctl mcmctreeSS/${name}_2.ctl

						sed -i "s/seed = -1/seed = ${seed}/g" mcmctreeSS/${name}_1.ctl
						((seed=seed+1))
						sed -i "s/seed = -1/seed = ${seed}/g" mcmctreeSS/${name}_2.ctl
						((seed=seed+1))

						# Makes a file with the names of the latent sequences for each analysis
						grep Node_*_1_*_* mcmctreeSS/${nameShort}p17S${sampleSize}_mcmc.fa > mcmctreeSS/${nameShort}S${sampleSize}_seqsL
						sed -i 's/>//g' mcmctreeSS/${nameShort}S${sampleSize}_seqsL 

						# Makes a directory for each mcmc run 
						mkdir mcmctreeSS/${name}_1
						mkdir mcmctreeSS/${name}_2
					done
				done
			done
		done
	done
done


