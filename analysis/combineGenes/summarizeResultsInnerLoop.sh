#!/bin/bash

name=$1

# Combines the samples from the MCMC from a single latent 
# sample from each gene. This reduces the size of the files
# that need to be read into R.

for seq in $(cat mcmctree/${name}_seqsL)
do
	run=1

# C1V2
	outfileC1V2=mcmctree/${name}C1V2_${run}/output

	# Finds the node number for a latent tip
	nodeNumC1V2=$(grep -w ${seq} ${outfileC1V2} | head -3 |tail -1 | awk '{print $2}')

	# Finds the column number in the mcmc that matches the "seq" latent sequence
	colC1V2=$(head -1 mcmctree/${name}C1V2_1/mcmc.txt | tr '\t' '\n' | cat -n | grep t_n${nodeNumC1V2}$ |awk '{print $1}')


# nef 
	outfileNef=mcmctree/${name}nef_${run}/output

	# Finds the node number for a latent tip
	nodeNumNef=$(grep -w ${seq} ${outfileNef} | head -3 |tail -1 | awk '{print $2}')

	# Finds the column number in the mcmc that matches the "seq" latent sequence
	colNef=$(head -1 mcmctree/${name}nef_1/mcmc.txt | tr '\t' '\n' | cat -n | grep t_n${nodeNumNef}$ | awk '{print $1}')


# p17 
	outfileP17=mcmctree/${name}p17_${run}/output

	# Finds the node number for a latent tip
	nodeNumP17=$(grep -w ${seq} ${outfileP17} | head -3 |tail -1 | awk '{print $2}')

	# Finds the column number in the mcmc that matches the "seq" latent sequence
	colP17=$(head -1 mcmctree/${name}p17_1/mcmc.txt | tr '\t' '\n' | cat -n | grep t_n${nodeNumP17}$ |awk '{print $1}')


# tat 
	outfileTat=mcmctree/${name}tat_${run}/output

	# Finds the node number for a latent tip
	nodeNumTat=$(grep -w ${seq} ${outfileTat} | head -3 |tail -1 | awk '{print $2}')

	# Finds the column number in the mcmc that matches the "seq" latent sequence
	colTat=$(head -1 mcmctree/${name}tat_1/mcmc.txt | tr '\t' '\n' | cat -n | grep t_n${nodeNumTat}$ |awk '{print $1}')

# When you run under the prior, the node labeling is the as when you run with the data. 
# Thus, we don't nee to find the column numbers for the priors as well

	paste <(awk -v c1=$colC1V2 '{printf "%s\n", $c1}' < mcmctree/${name}C1V2_1/mcmc.txt ) <(awk -v c1=$colNef '{printf "%s\n",$c1}' < mcmctree/${name}nef_1/mcmc.txt ) <(awk -v c1=$colP17 '{printf "%s\n",$c1}' < mcmctree/${name}p17_1/mcmc.txt )  <(awk -v c1=$colTat '{printf "%s\n",$c1}' < mcmctree/${name}tat_1/mcmc.txt ) <(awk -v c1=$colC1V2 '{printf "%s\n", $c1}' < mcmctree/${name}C1V2prior_1/mcmc.txt ) <(awk -v c1=$colNef '{printf "%s\n",$c1}' < mcmctree/${name}nefprior_1/mcmc.txt ) <(awk -v c1=$colP17 '{printf "%s\n",$c1}' < mcmctree/${name}p17prior_1/mcmc.txt )  <(awk -v c1=$colTat '{printf "%s\n",$c1}' < mcmctree/${name}tatprior_1/mcmc.txt ) > combineGeneFiles/${name}_${seq}.csv 

done
