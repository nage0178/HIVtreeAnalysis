#!/bin/bash

# Changes names from the sequences to have the sample date at the end
# The original names are also shortened

# Finds the relative dates of sampling and treatment start in units of days
Rscript findDates.R

sed -i 's/"//g' dates.csv
sed -i 's/ //g' dates.csv

mkdir alignmentsEdit

# For each alignment
for line in CAP217_ENV_2_all_hap.fasta_combined.msa CAP217_ENV_3_all_hap.fasta_combined.msa CAP217_ENV_4_all_hap.fasta_combined.msa CAP257_ENV_2_all_hap.fasta_combined.msa CAP257_ENV_3_all_hap.fasta_combined.msa CAP257_ENV_4_all_hap.fasta_combined.msa CAP257_GAG_1_all_hap.fasta_combined.msa CAP257_NEF_1_all_hap.fasta_combined.msa  

do

	# Finds name of all sequences
	grep ">" alignments/${line} > ${line}_seqs
	sed -i 's/>//g' ${line}_seqs

	cp alignments/${line} alignmentsEdit/${line}Edit

	# For each sequence
	for seq in $(cat ${line}_seqs)
	do
		pat='(.*)_(.*)_([0-9]*)WPI_(.*)'

		# Sequence is not latent
		if [[ "$seq" =~ $pat ]]; then
			name=/${BASH_REMATCH[1]}/

			# Finds the sample date
			date=$(awk -F "," "${name}" dates.csv | awk -F "," -v w="${BASH_REMATCH[3]}" '$12 == w'  | awk -F "," '{print $8}'| head -1 )
			newName=${BASH_REMATCH[4]}_DPI${date}

			# Updates the sequence name to have the sample date at the end
			sed -i "s/${seq}/${newName}/g" alignmentsEdit/${line}Edit

		else
			pat2='CAP([0-9]*)_(.*)_QVOA_(.*)'

			# Sequence is latent
			if [[ "$seq" =~ $pat2 ]]; then
				name=${BASH_REMATCH[1]}

				# Finds the sample date
				sampleTime=$(grep ${name} dates.csv |head -1 |awk -F "," '{print $14}')

				# Updates the sequence name to have the sample date at the end
				sed -i "s/${seq}/${seq}_${sampleTime}/g" alignmentsEdit/${line}Edit
			else
				# Sequence name is incorrect format
				echo No match for ${seq}
			fi

		fi

	done

rm ${line}_seqs

done
