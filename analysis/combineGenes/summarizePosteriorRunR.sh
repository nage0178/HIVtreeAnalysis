#!/bin/bash

batch=$1 # Should be 20
rep=$2 # Should be 5
sub=$3 # Should be 3
numGene=$4
maxAli=30 # Should be 30 

# Runs the script to combine inferences for 2 or 4 genes
# Puts the results (mean and credible set) in a csv file
if [ $numGene == 4 ]; then 

	echo batch,rep,ali,sub,gene,run,nodeName,trueDate,nodeDate,lowCI,highCI > combineGeneFiles/b${batch}r${rep}s${sub}combine.csv 
else
	echo batch,rep,ali,sub,gene,run,nodeName,trueDate,nodeDate,lowCI,highCI > combineGeneFiles/b${batch}r${rep}s${sub}combine2.csv 
fi

for ((ali=1;ali<=maxAli;ali++));
do
	name=b${batch}r${rep}a${ali}s${sub}
	# Skip the analysis that did not converge
	if [ $name == b13r1a6s1 ]
	then
		continue
	fi

	for seq in $(cat mcmctree/${name}_seqsL)
	do
		run=1

		# Finds the true integration time
		pat='(Node_1_([0-9]+)_([0-9]+)_([0-9]+))'
                [[ "$seq" =~ $pat ]]
		trueDate=${BASH_REMATCH[3]}
		sampleDate=${BASH_REMATCH[4]}

		# These are the integration bounds and are the same as
		# the bounds used in the MCMC
		if [[ $sampleDate == '3650' ]]
		then

			lowerBound=0
		else

			lowerBound=1.825
		fi	

		echo $seq
		if [ $numGene == 4 ]; then
			est=$(Rscript combineGenes/combineEstimate.R combineGeneFiles/${name}_${seq}.csv  $lowerBound 3.695 1000 3650 | awk '{print $2}' | sed 's/"//g')
		echo ${batch},${rep},${ali},${sub},combine,${run},${seq},${trueDate},${est} >> combineGeneFiles/b${batch}r${rep}s${sub}combine.csv
		else
			est=$(Rscript combineGenes/combineEstimate2Genes.R combineGeneFiles/${name}_${seq}.csv  $lowerBound 3.695 1000 3650 | awk '{print $2}' | sed 's/"//g')
		echo ${batch},${rep},${ali},${sub},combine,${run},${seq},${trueDate},${est} >> combineGeneFiles/b${batch}r${rep}s${sub}combine2.csv

		fi 	
	done
done
