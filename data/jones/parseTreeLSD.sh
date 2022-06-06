#!/bin/bash

mkdir resultsAllMethods

# For each patient
for pt in p1 p2
do

  # For each substitution model
  for model in HKY GTR
  do

    name=${pt}_${model}

    # Finds the line with the tree in the nexus file (there are other lines that are not needed in the output file)
    line=$(grep = trees.rooted.rtt/${name}.rooted.result.date.nexus)

    # Finds all the latent sequence names
    grep 'b(' runFiles/${name}.datefile | awk '{print $1 }' > runFiles/${name}Latent

    echo sequence,date,lowCI,highCI > resultsAllMethods/${name}_resultsLSD.csv

    # For each sequence
    for seq in $(cat runFiles/${name}Latent)
    do

          prelim_pat='\[&date=(-?[0-9]*\.?[0-9]*),CI_height=\{(-?[0-9]*\.?[0-9]*),(-?[0-9]*\.?[0-9]*)\}\]\[&CI_date="(-?[0-9]*\.?[0-9]*)\((-?[0-9]*\.?[0-9]*),(-?[0-9]*\.?[0-9]*)\)"\].*'
          pat='.*'${seq}${prelim_pat}

	  # Checks the file format is correct, and records the estimated date with confideence intervals
          if [[ "$line" =~ $pat ]]; then
            echo $seq,${BASH_REMATCH[4]},${BASH_REMATCH[5]},${BASH_REMATCH[6]} >> resultsAllMethods/${name}_resultsLSD.csv
          else
            echo Pattern did not match ${name}. Exiting
            exit
          fi


    done
  done
done
