#!/bin/bash


# Subsets alignments and remove site with many gaps
head -1 summaryAlignments > CAP217summary
head -1 summaryAlignments > CAP257summary

grep CAP217 summaryAlignments >> CAP217summary
grep CAP257 summaryAlignments >> CAP257summary

mkdir alignmentsSub

# For each number of sequences subsampled at each sample time
for numSub in 10 15 20
do 
	Rscript subsettingData.R ${numSub}

	# For each alignment
	for file in 217_ENV2 217_ENV3 217_ENV4 257_ENV2 257_ENV3 257_ENV4 257_GAG1 257_NEF1
	do
		# Patient_GeneName
  		firstPart=${file::-1}

		# Number after gene name
  		lastLetter=$(echo -n $file | tail -c 1)

		# Make new alignment
  		~/pullseq/src/./pullseq -i alignmentsEdit/CAP${firstPart}_${lastLetter}_all_hap.fasta_combined.msaEdit -n CAP${file}_seqs_d${numSub}  > alignmentsSub/${file}_d${numSub}.fa

		# Removes columns in the alignment that are more that "gap" percent gaps 
  		for gap in 0.75 0.85 0.95
		do 
			Rscript stripGap.R alignmentsSub/${file}_d${numSub}.fa alignmentsSub/${file}_d${numSub}_${gap}.fa ${gap}
		done 
		rm CAP${file}_seqs_d${numSub}
	done
done
