#!/bin/bash

# Finds the estimated integration date and confidence intervals from the output of LS

maxBatch=20 # Should be 20
maxAli=30 # Should be ~30
maxRep=5 # Should be 5
maxSub=1 # Should be 3

mkdir resultsSS

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

        # For each gene
        for gene in nef p17 tat C1V2
        do
		for sampleSize in 10 15 20
		do
        		name=b${batch}r${rep}a${ali}s${sub}${gene}S${sampleSize}

         		line=$(grep = alignmentsSS/${name}_rmOG.txt.result.date.nexus)

          		echo nodeName,trueDate,date,lowCI,highCI > resultsSS/${name}_results.csv
          		for seq in $(cat runFilesSS/${name}_seqs)
          		do

            			pat1='Node_([1])_([0-9]+)_([0-9]+)_([0-9]+)'
            			if [[ "$seq" =~ $pat1 ]]; then

	      				true_date=${BASH_REMATCH[3]}
              				prelim_pat='\[&date=(-?[0-9]*\.?[0-9]*),CI_height=\{(-?[0-9]*\.?[0-9]*),(-?[0-9]*\.?[0-9]*)\}\]\[&CI_date="(-?[0-9]*\.?[0-9]*)\((-?[0-9]*\.?[0-9]*),(-?[0-9]*\.?[0-9]*)\)"\].*'

              				pat='.*'${seq}${prelim_pat}

              				if [[ "$line" =~ $pat ]]; then
                				echo $seq,${true_date},${BASH_REMATCH[4]},${BASH_REMATCH[5]},${BASH_REMATCH[6]} >> resultsSS/${name}_results.csv
              				else
                				echo Pattern did not match ${name} ${seq}. Exiting
						exit
              				fi

            			fi
    			done 
          done

        done
      done
    done

  done
done
