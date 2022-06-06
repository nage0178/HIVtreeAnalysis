#!/bin/bash

# Runs the LS analysis
mkdir runFiles

# For each alignment
for file in 217_ENV2 217_ENV3 217_ENV4 257_ENV2 257_ENV3 257_ENV4 257_GAG1 257_NEF1
do
	# For each number of sequences subsampled for each sample time
	for numSub in 10 15 20
	do
		# For each level of gap stripping
		for filter in 0.75 0.85 0.95
		do 
			# If the file exists (may not because some levels of gap stripping result in the same alignment. Then raxml was only run once)
			name=${file}_d${numSub}_${filter}
			if test -f "raxml/${name}.raxml.bestTree"; then

				# Find all the sequence names
				grep ">" alignmentsSub/${name}.fa | sed 's/>//g' > runFiles/${name}Seqs

				# Number of sequences
				wc runFiles/${name}Seqs | awk '{print $1}' > runFiles/${name}.datefile

				# For each sequence, finds the bounds
				for line in $(cat runFiles/${name}Seqs)
				do
					latent=$(grep ${line} infoML/${name}.csv | awk -F , '{print $3}')
					date=$(grep ${line} infoML/${name}.csv | awk -F , '{print $2}')
					if [ $latent == 1 ]
					then
						# Add lower bound based on infection date
						# Upper bound if latent

						# If 
						echo ${line} b\(0,${date}\) >> runFiles/${name}.datefile
						#echo ${line} u\(${date}\) >> runFiles/${name}.datefile
					else
						# Constraint if not latent
						echo ${line} ${date} >> runFiles/${name}.datefile
					fi

				done

    				# Finds the name of the first sequence in the sequence file
    				# Then finds the length of the sequence (must subtract number of lines
    				# because of newline character)

    				firstSeq=$(grep ">" alignmentsSub/${name}.fa | sed 's/>//g' |head -1)
    				line=$(~/pullseq/src/./pullseq -i alignmentsSub/${name}.fa -g ${firstSeq} |tail -n +2 |wc -l)
    				char=$(~/pullseq/src/./pullseq -i alignmentsSub/${name}.fa -g ${firstSeq} |tail -n +2 |wc -c)
    				seqLen=$((char-line))

				# Runs the analysis
				~/lsd-0.3beta-0.3.3/src/./lsd -c -i trees.rooted.rtt/${name}.rooted -d runFiles/${name}.datefile -s ${seqLen} -f 100 &> runFiles/${name}LSDout & 
				rm runFiles/${name}Seqs
			fi 
		done
	done
done
