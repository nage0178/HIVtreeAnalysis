#!/bin/bash

# This combines combines the results from all of the analysies into a single csv file

echo patient,model,method,sequence,nodeDate,lowCI,highCI > resultsAllMethods/combine.csv

# LSD method
# For each patient
for pt in p1 p2
do
  
  # For each substitution model 
  for model in HKY GTR
  do
          name=${pt}_${model}

	  # For each latent sequence
	  for line in $(tail -n +2 resultsAllMethods/${name}_resultsLSD.csv)
          do
          	echo ${pt},${model},LS,${line} >> resultsAllMethods/combine.csv
          done

  done
done

# Bayes method
# For each patient
for pt in p1 p2
do
  
          name=${pt}
	  model=HKY

	  # For each latent sequence
	  for line in $(tail -n +2 resultsAllMethods/${name}_resultsBayes.csv)
          do
          	echo ${pt},${model},Bayes,${line} >> resultsAllMethods/combine.csv
          done

done


# Node dating method
# For each patient
for pt in p1 p2 
do
  # For each substitution model
  for model in HKY GTR 
  do
    name=${pt}_${model}

    # For each sequence
    for line in $(tail -n +2 outfileML/${name}.data.csv)
	do
		# If the sequence is latent
		pat='"(.+)",1,[0-9]+,.*,1,(-?[0-9]+.?[0-9]+),.*'
		if [[ "$line" =~ $pat ]]; then
			echo ${pt},${model},ML,${BASH_REMATCH[1]},${BASH_REMATCH[2]},NA,NA >> resultsAllMethods/combine.csv 
		fi 
    done
  done
done

# Jones linear regression method
# For each patient
for pt in p1 p2
do

  # For each model 
  for model in HKY GTR
  do

    name=${pt}_${model}

    # For each sequences
    for line in $(tail -n +2 data/${name}.txt)
        do
		# If the sequence is latent
		pat='"(.+)",([0-9]+),1,(-?[0-9]+.?[0-9]+),(-?[0-9]+.?[0-9]+),(-?[0-9]+.?[0-9]+)'

                if [[ "$line" =~ $pat ]]; then
                echo ${pt},${model},LR,${BASH_REMATCH[1]},${BASH_REMATCH[3]},${BASH_REMATCH[4]},${BASH_REMATCH[5]}>> resultsAllMethods/combine.csv

		fi
    done
  done
done

