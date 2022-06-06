#!/bin/bash


#  Runs the analyses to combine estimates across genes

echo patient,numDraw,filter,method,sequence,nodeDate,lowCI,highCI> combineGeneFiles/all_combine.csv
for pt  in 217 257
do
	# This was only run with 10 sequences and
	# a filter of 0.75, but could be done with the other
	# values 

        # For each number of sequences subsampled
        for numSub in 10 #15 20
        do
                # For each level of gap stripping
                for filter in 0.75 #0.85 0.95
                do

			for seq in $(tail +2 sequences${pt}.txt |awk -F , '{print $1}')
			do
                       		name=${pt}_d${numSub}_${filter}_$seq
				if [[ $pt == 217 ]];
				then	
					# These are based on the time units in the MCMC
					upperBound=3.450
					timeZero=3450
				else
					upperBound=3.921
					timeZero=3921
				fi	

				est=$(Rscript combineGenes.R combineGeneFiles/$name 0 $upperBound 1000 $timeZero | awk '{print $2}' | sed 's/"//g')
                		echo ${pt},${numSub},${filter},combine,${seq},${est} >> combineGeneFiles/all_combine.csv

				
			done
		done
	done
done

