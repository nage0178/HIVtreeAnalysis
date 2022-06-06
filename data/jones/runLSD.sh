mkdir runFiles
# For each patient
for pt in p1 p2
do
	# For each substitution model
	for analysis in HKY GTR
	do
		name=${pt}_${analysis}

	# Finds the names of the sequences
	grep ">" ${pt}_alignment_date.fa | sed 's/>//g' > runFiles/${name}Seqs

	# Finds the number of constraints
	wc runFiles/${name}Seqs | awk '{print $1}' > runFiles/${name}.datefile

	# For each sequence
	for line in $(cat runFiles/${name}Seqs)
	do
		latent=$(grep ${line} info/${name}.csv | awk -F , '{print $3}')
		date=$(grep ${line} info/${name}.csv | awk -F , '{print $2}')

		# Adds the constraints to the datefile
		if [ $latent == 1 ]
		then
			if [ $pt == p1 ]
			then
				# 10 years prior to diagnosis. First sample is same time as diagnosis, which is day 1
				echo ${line} b\(-3649, ${date}\) >> runFiles/${name}.datefile
			else
				# 10 years prior to diagnosis (diagnosed 1.83 years prior to first sample, first sample is at day 1)
				echo ${line} b\(-4316, ${date}\) >> runFiles/${name}.datefile
			fi
			#echo ${line} u\(${date}\) >> runFiles/${name}.datefile
		else
			echo ${line} ${date} >> runFiles/${name}.datefile
		fi
	done

	# Finds the sequence length (needed for confidence intervals)
	if [ $pt == p1 ]
	then
		seqLen=621
	else
		seqLen=618
	fi
	# Runs the LSD analysis, using same tree as rooted with Jones method (uses root to tip regression)
		~/lsd-0.3beta-0.3.3/src/./lsd -c -i trees.rooted.rtt/${name}.rooted -d runFiles/${name}.datefile -s ${seqLen} -f 100 &> runFiles/${name}LSDout & 
	done
done
wait
