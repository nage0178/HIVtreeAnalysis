#!/bin/bash

# This prepares the input files for the LS analysis with different size trees
# and runs the analysis

maxBatch=20 # Should be 20
maxAli=30 #Should be ~30
maxRep=5 # Should be 5
maxSub=1 # Should be 1

mkdir alignmentsSS
mkdir runFilesSS


# For each batch (this is naming for tree simualation)
for ((batch=1;batch<=maxBatch;batch++));
do

  # For maxAli number of alignments
  for ((ali=1;ali<=maxAli;ali++));
  do

    # For each subsampling of the sampled tree
    for ((sub=1;sub<=maxSub;sub++));
    do

      # For each rep (this is naming for tree simualation)
      for ((rep=1;rep<=maxRep;rep++));
      do

	for sampleSize in 10 15 20
	do 
		# For each gene/parameters combination
    		for line1 in $(cat ~/HIV_dna_simulator/ref_seq/seq_len.csv)
    		do

	    		pat='(.*),([0-9]+),([0-9]+)'
      			[[ "$line1" =~ $pat ]]

      			gene=${BASH_REMATCH[1]}
      			seqLen=${BASH_REMATCH[3]}

			name=b${batch}r${rep}a${ali}s${sub}${gene}S${sampleSize}

			if [ $sampleSize == 10 ]
			then
				nameShort=b${batch}r${rep}a${ali}s${sub}${gene}
				cp trees/${nameShort}_rmOG.txt alignmentsSS/${name}_rmOG.txt
				cp runFiles/${nameShort}_seqs runFilesSS/${name}_seqs
				cp runFiles/${nameShort}.datefile runFilesSS/${name}.datefile
			else

			Rscript ~/HIVtreeAnalysis/data/longitudinal_lanl/scripts/rmOutgroup.R ../raxmlSS/${name}.raxml.bestTree alignmentsSS/${name}_rmOG.txt outgroup

			grep ">" ~/HIVtreeAnalysis/dnaSimulations/sampleSize/${name}.fa | sed 's/>//g' | grep -v outgroup > runFilesSS/${name}_seqs
			echo -n > runFilesSS/${name}.datefile

			for line in $(cat runFilesSS/${name}_seqs)
			do
				pat='Node_([0-1])_([0-9]+)_([0-9]+)_([0-9]+)'
				[[ "$line" =~ $pat ]]

				latent=${BASH_REMATCH[1]}
				age=${BASH_REMATCH[4]}

				if [ $latent == 0 ]
				then
					echo ${line} ${age} >> runFilesSS/${name}.datefile	
				else
					echo ${line} b\(-45, ${age}\) >> runFilesSS/${name}.datefile
				fi 
			done
			constraints=$(wc -l runFilesSS/${name}.datefile| awk '{ print $1}')
		
			sed -i "1s/^/${constraints}\n/" runFilesSS/${name}.datefile
			fi 
			~/lsd-0.3beta-0.3.3/src/./lsd -c -i alignmentsSS/${name}_rmOG.txt -d runFilesSS/${name}.datefile -s ${seqLen} -f 100 &> runFilesSS/${name}LSDout &
      	 	 done
	done 
      done
    done
    wait $!
  done
done
