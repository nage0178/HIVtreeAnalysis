#!/bin/bash

# Finds the estimated integration date and confidence intervals from the output of LS

mkdir results

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

	  # Line in the file with the tree (there are extra lines that are not needed in the nexus file format)
          line=$(grep = trees/${name}_rmOG.txt.result.date.nexus)

          echo nodeName,trueDate,date,lowCI,highCI > results/${name}_results.csv

	  # For each sequence
          for seq in $(cat runFiles/${name}_seqs)
          do

		# If the sequence is latent
		pat1='Node_([1])_([0-9]+)_([0-9]+)_([0-9]+)'
		if [[ "$seq" =~ $pat1 ]]; then

			true_date=${BASH_REMATCH[3]}

			# Pattern for the estimated date and confidence intervals in the output tree file from the LSD analysis
			prelim_pat='\[&date=(-?[0-9]*\.?[0-9]*),CI_height=\{(-?[0-9]*\.?[0-9]*),(-?[0-9]*\.?[0-9]*)\}\]\[&CI_date="(-?[0-9]*\.?[0-9]*)\((-?[0-9]*\.?[0-9]*),(-?[0-9]*\.?[0-9]*)\)"\].*'
			pat='.*'${seq}${prelim_pat}

			if [[ "$line" =~ $pat ]]; then
				# Puts estimate with confidence intervals into csv file
				echo $seq,${true_date},${BASH_REMATCH[4]},${BASH_REMATCH[5]},${BASH_REMATCH[6]} >> results/${name}_results.csv
			else
				echo Pattern did not match ${name}. Exiting
				exit
			fi

		fi

          done
        done
      done
    done
  done
done
