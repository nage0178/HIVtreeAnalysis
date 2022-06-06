 #!/bin/bash

# Parses the tree output from the LS analysis

mkdir resultsAllMethods

# For each alignment
for file in 217_ENV2 217_ENV3 217_ENV4 257_ENV2 257_ENV3 257_ENV4 257_GAG1 257_NEF1
do
	# For each number of sequences sampled at each sample time
        for numSub in 10 15 20
        do
		# For each level of gap filtering
                for filter in 0.75 0.85 0.95
                do
			# If the file exists (some level result in the same alignments, so only one analysis was run in this case)
                        name=${file}_d${numSub}_${filter}
                        if test -f "raxml/${name}.raxml.bestTree"; then

				# Find the line in output file with the tree (there are extra lines in the nexus file)
				line=$(grep = trees.rooted.rtt/${name}.rooted.result.date.nexus)

				# Find the latent sequences
    				grep 'b(' runFiles/${name}.datefile | awk '{print $1 }' > runFiles/${name}Latent
    				#grep 'u(' runFiles/${name}.datefile | awk '{print $1 }' > runFiles/${name}Latent

				echo sequence,date,lowCI,highCI > resultsAllMethods/${name}_resultsLSD.csv

				# For each latent sequence
				for seq in $(cat runFiles/${name}Latent)
				do

					#prelim_pat='\[&date=(-?[0-9]*\.?[0-9]*),CI_height=\{(-?[0-9]*\.?[0-9]*),(-?[0-9]*\.?[0-9]*)\}\]\[&CI_date="(-?[0-9]*\.?[0-9]*)\((-?[0-9]*\.?[0-9]*),(-?[0-9]*\.?[0-9]*)\)"\].*'
					prelim_pat='\[&date=(-?[0-9]*\.?[0-9]*e?\+?[0-9]*?),CI_height=\{(-?[0-9]*\.?[0-9]*e?\+?[0-9]*?),(-?[0-9]*\.?[0-9]*e?\+?[0-9]*?)\}\]\[&CI_date="(-?[0-9]*\.?[0-9]*e?\+?[0-9]*?)\((-?[0-9]*\.?[0-9]*e?\+?[0-9]*?),(-?[0-9]*\.?[0-9]*e?\+?[0-9]*?)\)"\].*'

					pat='.*'${seq}${prelim_pat}

					# Check the date in the nexus file is in the correct format
					if [[ "$line" =~ $pat ]]; then

						# Records the infered date with confidence intervals
						echo $seq,${BASH_REMATCH[4]},${BASH_REMATCH[5]},${BASH_REMATCH[6]} >> resultsAllMethods/${name}_resultsLSD.csv
					else
						echo Pattern did not match ${name}. Exiting
						exit
					fi
				done
			fi
		done
	done
done
