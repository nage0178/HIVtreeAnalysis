mkdir infoML
mkdir trees
mkdir trees.rooted.rtt
mkdir outfileML

# For each patient
for pt in p1 p2
do
	# For each substitution model
	for analysis in HKY GTR
	do
		# Copies the tree into the appropriate directory
                cp raxml/${pt}_${analysis}.raxml.bestTree trees/${pt}_${analysis}.nwk

		name=${pt}_${analysis}
		
		# Creates the csv file needed for the analysis
		echo "FULLSEQID","COLDATE","CENSORED" > infoML/${name}.csv

		# For each sequence
		for line in $(cat ${pt}_dates.csv)
		do
			seqName=$(echo ${line} | awk -F "," '{print $2}')
			date=$(echo ${line} | awk -F "," '{print $4}')
			latent=$(echo ${line} | awk -F "," '{print $6}')

			echo ${seqName},${date},${latent} >> infoML/${name}.csv
		done

		# Root the tree using root to tip regression
		Rscript root.R trees/${name}.nwk trees.rooted.rtt/${name}.rooted infoML/${name}.csv 

		# Run the node dating analysis
		Rscript ~/HIV_latency_general/analysis/ML/new.dating.R --tree trees.rooted.rtt/${name}.rooted --info infoML/${name}.csv --timetree outfileML/${name}.timetree --data outfileML/${name}.data.csv --stats outfileML/${name}.stats.csv --patid ${name} &> outfileML/${name}Out &
	done
done
wait
