#!/bin/bash

# This prepares the files for the LS analysis and runs the analysis

mkdir runFiles
mkdir trees

maxBatch=20 # Should be 20
maxAli=30 # Should be ~30
maxRep=5 # Should be 5
maxSub=3 # Should be 3

# For each batch (this is naming for tree simulation)
for ((batch=1;batch<=maxBatch;batch++));
do

  # For maxAli number of alignments
  for ((ali=1;ali<=maxAli;ali++));
  do

    # For each subsampling of the sampled tree
    for ((sub=1;sub<=maxSub;sub++));
    do

      # For each rep (this is naming for tree simulation)
      for ((rep=1;rep<=maxRep;rep++));
      do

        # For each gene
        for gene in nef p17 tat C1V2
        do
		name=b${batch}r${rep}a${ali}s${sub}${gene}

		# Finds the name of all of the sequences
		grep ">" ~/HIVtreeAnalysis/dnaSimulations/alignments/${name}.fa | sed 's/>//g' | grep -v outgroup > runFiles/${name}_seqs
		echo -n > runFiles/${name}.datefile

		# For each latent sequences
		for line in $(cat runFiles/${name}_seqs)
		do
			pat='Node_([0-1])_([0-9]+)_([0-9]+)_([0-9]+)'
			[[ "$line" =~ $pat ]]

			latent=${BASH_REMATCH[1]}
			age=${BASH_REMATCH[4]}

			# Adds constraints to the datefile
			if [ $latent == 0 ]
			then
				# If sequence is not latent, constrained to equal sample time
				echo ${line} ${age} >> runFiles/${name}.datefile	
			else
				# If sequence is latent, sample time is an upper bound on age
				echo ${line} b\(-45, ${age}\) >> runFiles/${name}.datefile
			fi 
		done

		# Finds number of constraints
		constraints=110

		# Finds sequences length from files for mcmc tree
		seqLen=$(head -1 ../mcmctree/${name}_mcmc.fa | awk '{print $2}')
		
		# Adds number of constraints to top of file with constraints
		sed -i "1s/^/${constraints}\n/" runFiles/${name}.datefile

		# Copies the tree to this directory
		cp ../mcmctree/${name}_rmOG.txt trees/

		# Runs the analysis 
		~/lsd-0.3beta-0.3.3/src/./lsd -c -i trees/${name}_rmOG.txt -d runFiles/${name}.datefile -s ${seqLen} -f 100 &> runFiles/${name}LSDout &
        done
      done
    done
    wait $!
  done
done
wait
