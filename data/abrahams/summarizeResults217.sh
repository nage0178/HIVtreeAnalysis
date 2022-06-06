#!/bin/bash

pt=$1
numSeq=$2
fil=$3

for seq in $(tail -n +2 sequences${pt}.txt)
do
	run=1

	echo $seq
	name=$(echo $seq |awk -F , '{print $1}')
	ENV2=$(echo $seq |awk -F , '{print $2}')
	ENV3=$(echo $seq |awk -F , '{print $3}')
	ENV4=$(echo $seq |awk -F , '{print $4}')
	echo $name

#217_ENV2_d10_0.75_1
## ENV2 

	file=${pt}_ENV2_d${numSeq}_${fil}
	outfileENV2=mcmctree/${file}_${run}/output
	mcmcENV2=mcmctree/${file}_${run}/mcmc.txt
	priorENV2=mcmctree/${file}Prior_${run}/mcmc.txt

	if [[ $ENV2 ]]; then

		# Finds the node number for a latent tip
		nodeNumENV2=$(grep -w ${ENV2} ${outfileENV2} | head -3 |tail -1 | awk '{print $2}')
	
		# Finds the column number in the mcmc that matches the "seq" latent sequence
		colENV2=$(head -1 mcmctree/${file}_1/mcmc.txt | tr '\t' '\n' | cat -n | grep t_n${nodeNumENV2}$ |awk '{print $1}')

	else 	
		colENV2=1
		mcmcENV2=ENV2.txt
		priorENV2=ENV2.txt
		echo ENV2 > ENV2.txt
	fi

# ENV3 
	file=${pt}_ENV3_d${numSeq}_${fil}
	outfileENV3=mcmctree/${file}_${run}/output
	mcmcENV3=mcmctree/${file}_${run}/mcmc.txt
	priorENV3=mcmctree/${file}Prior_${run}/mcmc.txt

	if [[ $ENV3 ]]; then
		# Finds the node number for a latent tip
		nodeNumENV3=$(grep -w ${ENV3} ${outfileENV3} | head -3 |tail -1 | awk '{print $2}')
	
		# Finds the column number in the mcmc that matches the "seq" latent sequence
		colENV3=$(head -1 mcmctree/${file}_1/mcmc.txt | tr '\t' '\n' | cat -n | grep t_n${nodeNumENV3}$ |awk '{print $1}')
	else
		colENV3=1
		mcmcENV3=ENV3.txt
		priorENV3=ENV3.txt
		echo ENV3 > ENV3.txt
	fi
# ENV4 
	file=${pt}_ENV4_d${numSeq}_${fil}
	outfileENV4=mcmctree/${file}_${run}/output
	mcmcENV4=mcmctree/${file}_${run}/mcmc.txt
	priorENV4=mcmctree/${file}Prior_${run}/mcmc.txt

	if [[ $ENV4 ]]; then

		# Finds the node number for a latent tip
		nodeNumENV4=$(grep -w ${ENV4} ${outfileENV4} | head -3 |tail -1 | awk '{print $2}')

		# Finds the column number in the mcmc that matches the "seq" latent sequence
		colENV4=$(head -1 mcmctree/${file}_1/mcmc.txt | tr '\t' '\n' | cat -n | grep t_n${nodeNumENV4}$ |awk '{print $1}')

	else
		colENV4=1
		mcmcENV4=ENV4.txt
		priorENV4=ENV4.txt
		echo ENV4 > ENV4.txt
	fi

#	awk -v c1=$colENV4 '{printf "%s\n", $c1}' < mcmctree/${file}_1/mcmc.txt 



## When you run under the prior, the node labeling is the as when you run with the data. 
## Thus, we don't nee to find the column numbers for the priors as well
#
	paste <(awk -v c1=$colENV2 '{printf "%s\n", $c1}' < ${mcmcENV2} ) <(awk -v c1=$colENV3 '{printf "%s\n",$c1}' < ${mcmcENV3} ) <(awk -v c1=$colENV4 '{printf "%s\n",$c1}' < ${mcmcENV4} )  <(awk -v c1=$colENV2 '{printf "%s\n", $c1}' < ${priorENV2} ) <(awk -v c1=$colENV3 '{printf "%s\n",$c1}' < ${priorENV3} ) <(awk -v c1=$colENV4 '{printf "%s\n",$c1}' < ${priorENV4} )  > combineGeneFiles/${pt}_d${numSeq}_${fil}_${name}

#<(awk -v c1=$colNef '{printf "%s\n",$c1}' < mcmctree/${name}nefprior_1/mcmc.txt ) <(awk -v c1=$colP17 '{printf "%s\n",$c1}' < mcmctree/${name}p17prior_1/mcmc.txt )  <(awk -v c1=$colTat '{printf "%s\n",$c1}' < mcmctree/${name}tatprior_1/mcmc.txt ) 
#
done
