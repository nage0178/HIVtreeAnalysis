 #!/bin/bash

# Matches the sequences names that were derived from the same QVOA

# Patient 217
rm -f names
# For each alignment
for file in 217_ENV2 217_ENV3 217_ENV4
do
	grep QVOA mcmctree/217*seqsL | awk -F : '{print $2}' | sort | uniq > sequences

	for line in $(cat sequences)
	do
		pat='CAP217_[^_]*_[^_]*_(.*)_QVOA.*'
		if [[ "$line" =~ $pat ]]; then
			echo ${BASH_REMATCH[1]} >> names
		else
			echo Pattern did not match. $line Exiting
			exit
		fi
	done

done

sort names |uniq > uniqNames
echo seq,ENV2,ENV3,ENV4 > sequences217.txt
for seq in $(cat uniqNames)
do
		env2=$(grep C1C2_${seq}_QVOA mcmctree/217_ENV2_d10_0.75_seqsL)
		env3=$(grep C2C3_${seq}_QVOA mcmctree/217_ENV3_d10_0.75_seqsL)
		env4=$(grep C4C5_${seq}_QVOA mcmctree/217_ENV4_d10_0.75_seqsL)
		echo ${seq},${env2},${env3},${env4} >> sequences217.txt

done

# Patient 257
rm -f names
# For each alignment
for file in 257_ENV2 257_ENV3 257_ENV4 257_GAG1 257_NEF1
do
	grep QVOA mcmctree/257*seqsL | awk -F : '{print $2}' | sort | uniq > sequences

	for line in $(cat sequences)
	do
		pat='CAP257_[^_]*_[^_]*_(.*)_QVOA.*'
		if [[ "$line" =~ $pat ]]; then
			echo ${BASH_REMATCH[1]} >> names
		else
			echo Pattern did not match. $line Exiting
			exit
		fi
	done

done

sort names |uniq > uniqNames
echo seq,ENV2,ENV3,ENV4,GAG1,NEF1 > sequences257.txt
for seq in $(cat uniqNames)
do
		env2=$(grep C1C2_${seq}_QVOA mcmctree/257_ENV2_d10_0.75_seqsL)
		env3=$(grep C2C3_${seq}_QVOA mcmctree/257_ENV3_d10_0.75_seqsL)
		env4=$(grep C4C5_${seq}_QVOA mcmctree/257_ENV4_d10_0.75_seqsL)
		gag1=$(grep P17_${seq}_QVOA mcmctree/257_GAG1_d10_0.75_seqsL)
		nef1=$(grep NEF_1_${seq}_QVOA mcmctree/257_NEF1_d10_0.75_seqsL)
		echo ${seq},${env2},${env3},${env4},${gag1},${nef1} >> sequences257.txt

done
Rscript sort_QVOA.R
rm sequences sequences.txt names uniqNames
