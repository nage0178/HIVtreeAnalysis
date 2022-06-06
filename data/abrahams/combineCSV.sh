#!/bin/bash

# Combines the results from all of the methods into a single csv file 
echo patient,numDraw,filter,method,sequence,nodeDate,lowCI,highCI > resultsAllMethods/combine.csv

# For each alignment 
for file in 217_ENV2 217_ENV3 217_ENV4 257_ENV2 257_ENV3 257_ENV4 257_GAG1 257_NEF1
do
	# For each subsampled number of sequences
        for numSub in 10 15 20
        do
		# For each gap removal level
                for filter in 0.75 0.85 0.95
                do
          		name=${file}_d${numSub}_${filter}

			# If the file exist (some of the gap filterings result in identical
			# alignments. If so, only one analysis was run)
			if test -f "raxml/${name}.raxml.bestTree"; then

				# Put the results from each sequences into the csv file
	  			for line in $(tail -n +2 resultsAllMethods/${name}_resultsLSD.csv)
          			do
          				echo ${file},${numSub},${filter},LS,${line} >> resultsAllMethods/combine.csv

          			done
			fi

		done
	done
done

# For each alignment 
for file in 217_ENV2 217_ENV3 217_ENV4 257_ENV2 257_ENV3 257_ENV4 257_GAG1 257_NEF1
do
	# For each subsampled number of sequences
        for numSub in 10 15 20
        do
		# For each gap removal level
                for filter in 0.75 0.85 0.95
                do
          		name=${file}_d${numSub}_${filter}

			# If the file exist (some of the gap filterings result in identical
			# alignments. If so, only one analysis was run)
			if test -f "raxml/${name}.raxml.bestTree"; then

				# Put the results from each sequences into the csv file
	  			for line in $(tail -n +2 resultsAllMethods/${name}_resultsBayes.csv)
          			do
          				echo ${file},${numSub},${filter},Bayes,${line} >> resultsAllMethods/combine.csv

          			done
			fi

		done
	done
done

# For each alignment 
for file in 217_ENV2 217_ENV3 217_ENV4 257_ENV2 257_ENV3 257_ENV4 257_GAG1 257_NEF1
do
	# For each subsampled number of sequences
        for numSub in 10 15 20
        do
		# For each gap removal level
                for filter in 0.75 0.85 0.95
                do
          		name=${file}_d${numSub}_${filter}

			# If the file exist (some of the gap filterings result in identical
			# alignments. If so, only one analysis was run)
			if test -f "raxml/${name}.raxml.bestTree"; then

				# Put the results from each sequences into the csv file
				for line in $(tail -n +2 outfileML/${name}.data.csv)
				do
					# Checks to see if sequence is latent
					pat='"(.+)",1,[0-9]+,.*,1,(-?[0-9]+.?[0-9]+),.*'
					if [[ "$line" =~ $pat ]]; then
						echo ${file},${numSub},${filter},ML,${BASH_REMATCH[1]},${BASH_REMATCH[2]},NA,NA >> resultsAllMethods/combine.csv 
					fi
          			done
			fi

		done
	done
done


# For each alignment 
for file in 217_ENV2 217_ENV3 217_ENV4 257_ENV2 257_ENV3 257_ENV4 257_GAG1 257_NEF1
do
	# For each subsampled number of sequences
        for numSub in 10 15 20
        do
		# For each gap removal level
                for filter in 0.75 0.85 0.95
                do
			# If the file exist (some of the gap filterings result in identical
			# alignments. If so, only one analysis was run)
                        name=${file}_d${numSub}_${filter}
                        if test -f "raxml/${name}.raxml.bestTree"; then

				# Put the results from each sequences into the csv file
                                for line in $(tail -n +2 dataLR/${name}.txt)
                                do
					# Checks to see if seqeunces is latent
					pat='"(.+QVOA.+)",([0-9]+),[0-1],(-?[0-9]+.?[0-9]+),(-?[0-9]+.?[0-9]+),(-?[0-9]+.?[0-9]+)'
                                        if [[ "$line" =~ $pat ]]; then
                                                echo ${file},${numSub},${filter},LR,${BASH_REMATCH[1]},${BASH_REMATCH[3]},${BASH_REMATCH[4]},${BASH_REMATCH[5]}>> resultsAllMethods/combine.csv
                                        fi
                                done
                        fi
                done
        done
done

