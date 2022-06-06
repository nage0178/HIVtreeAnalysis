#!/bin/bash

for outgroup in 1006 1018 CS2 PIC55751
do

	for file in C1V2 nef p17 tat
	do

#		# Finds the sequence names for patient 1362
#		# Pulls those sequences in a file
# 		grep 1362_d ../outgroup/${outgroup}/${file}.Fasta |sed 's/>//g' > ${file}_1362_seqs
#
# 		# Need to add in outgroup sequence
# 		grep ">" ../outgroup/${outgroup}/${outgroup}.fasta |sed 's/>//g' >> ${file}_1362_seqs
#
# 		if [ $file == nef ]
# 		then
#   			# Short or problematic sequences to remove
#	 		grep -v -f rm_${file} ${file}_1362_seqs > ${file}_1362_seqs_red
#			cp ${file}_1362_seqs_red  ${file}_1362_seqs
#			rm ${file}_1362_seqs_red
#		fi
#
#		# Puts sequences for only patient 1362 in a file
#		~/pullseq/src/./pullseq -i ../outgroup/${outgroup}/${file}.Fasta  -n ${file}_1362_seqs > ${file}_${outgroup}_reduced.fa
#
#		# Swaps the order of the 2nd and last (1 or 2) field(s) in the name of the sequences
#		# This makes the sample date the last part of the name of each sequence
#		for name in $(cat ${file}_1362_seqs)
#		do
#  			pat='(1362)(_d[0-9]+)(_.*)'
#  			if [[ "$name" =~ $pat ]]
#			then
#  				newName=${BASH_REMATCH[1]}${BASH_REMATCH[3]}${BASH_REMATCH[2]}
#
#				sed -i "s/${name}$/${newName}/g" ${file}_${outgroup}_reduced.fa
#			fi
#
#		done
#		rm ${file}_1362_seqs
#
#		# Removes all sites with more than 75% gaps (these are mostly cases the alignment looks unreliable)
#		Rscript scripts/stripGap.R ${file}_${outgroup}_reduced.fa ${file}_og${outgroup}.fa
#
		# Finds the name of the outgroup seqeunce
		ogSeq=$(grep ">" ../outgroup/${outgroup}/${outgroup}.fasta |sed 's/>//g')

		# Make a tree with raxml
		raxml-ng --msa ${file}_og${outgroup}.fa --model HKY+G --tree pars{25},rand{25} --seed 1 --outgroup ${ogSeq} &> ${file}

		# Remove outgroup from sequence file
		grep ">" ${file}_og${outgroup}.fa | grep -v ${ogSeq} | sed 's/>//g' > finalSeqs
		~/pullseq/src/./pullseq -i ${file}_og${outgroup}.fa  -n finalSeqs > ${file}_${outgroup}_mcmc.fa
		rm finalSeqs

		# Finds the number of sequences in the reduced alignment
		numSeq=$(grep ">" ${file}_${outgroup}_mcmc.fa | wc -l)

		# Removes the outgroup from the tree file
		Rscript scripts/rmOutgroup.R ${file}_og${outgroup}.fa.raxml.bestTree ${file}_${outgroup}_rmOG.txt ${ogSeq}

		# Strips the branch lengths from the rooted tree file
		# Adds the number of sequences and the number of trees to the tree file
		scripts/./stripbranchlengths.sh ${file}_${outgroup}_rmOG.txt ${file}_strip_${outgroup}.txt

		# Adds the number of sequences (taxa) to to the tree file
		sed -i "1s/^/${numSeq} 1\n/" ${file}_strip_${outgroup}.txt

		# Finds the name of the first sequence in the sequence file
		# Then finds the length of the sequence (must subtract number of lines
		# because of newline character)
		firstSeq=$(grep ">" ${file}_${outgroup}_mcmc.fa | sed 's/>//g' |head -1)
		line=$(~/pullseq/src/./pullseq -i ${file}_${outgroup}_mcmc.fa -g ${firstSeq} |tail -n +2 |wc -l)
		char=$(~/pullseq/src/./pullseq -i ${file}_${outgroup}_mcmc.fa -g ${firstSeq} |tail -n +2 |wc -c)
		seqLen=$((char-line))

		# Adds the number of sequences and the sequence length to the alignment file
		sed -i "1s/^/${numSeq} ${seqLen}\n/" ${file}_${outgroup}_mcmc.fa

	done
done
