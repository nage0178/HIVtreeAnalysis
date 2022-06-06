#!/bin/bash

# Finds summary information about the alignments

echo alignment,seq,date,QVOA > summaryAlignments

# For each alignment
for line in CAP217_ENV_2_all_hap.fasta_combined.msa CAP217_ENV_3_all_hap.fasta_combined.msa CAP217_ENV_4_all_hap.fasta_combined.msa CAP257_ENV_2_all_hap.fasta_combined.msa CAP257_ENV_3_all_hap.fasta_combined.msa CAP257_ENV_4_all_hap.fasta_combined.msa CAP257_GAG_1_all_hap.fasta_combined.msa CAP257_NEF_1_all_hap.fasta_combined.msa
do

	# Find the names of each sequence
	grep ">" alignmentsEdit/${line}Edit > ${line}Edit_seqs
	sed -i 's/>//g' ${line}Edit_seqs

	# For each sequence
	for seq in $(cat ${line}Edit_seqs)
	do
		pat='(.*)_DPI([0-9]*)'

		# The sequence is not latent
		if [[ "$seq" =~ $pat ]]; then
			#newName=${BASH_REMATCH[4]}_DPI${BASH_REMATCH[3]}
			#sed -i "s/${seq}/${newName}/g" alignmentsEdit/${line}Edit
			echo ${line}Edit,${seq},${BASH_REMATCH[2]},0 >> summaryAlignments
		else
			# The sequence is latent
			pat2='CAP([0-9]*)_(.*)_QVOA_(.*)_([0-9]*)'
			if [[ "$seq" =~ $pat2 ]]; then
				echo ${line}Edit,${seq},${BASH_REMATCH[4]},1 >> summaryAlignments

			# Name is in the wrong format
			else
				echo No match for ${seq}
			fi

		fi

	done

	rm ${line}Edit_seqs

done

