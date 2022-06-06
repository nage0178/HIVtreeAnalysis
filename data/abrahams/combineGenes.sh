#!/bin/bash

# Creates files for each latent sequences that was part of the
# same QVOA. This is needed to combine the results across genes
# with the Bayesian method

mkdir combineGeneFiles
# For both of the patients in the dataset
for pt  in 217 257
do
        # For each number of sequences subsampled
	# (The combined analysis was only run for 
	# the smallest trees, with the .75 level of 
	# filtering, but could be run 
	# for the larger trees )
        for numSub in 10 #15 20
        do
                # For each level of gap stripping
                for filter in 0.75 #0.85 0.95
                do
                        name=${file}_d${numSub}_${filter}

				if [[ $pt == 257 ]];
				then	
					./summarizeResults257.sh $pt $numSub $filter
				else
					./summarizeResults217.sh $pt $numSub $filter
				fi	
				
			#fi 
		done
	done
done

rm ENV2.txt ENV3.txt ENV4.txt GAG1.txt NEF1.txt

