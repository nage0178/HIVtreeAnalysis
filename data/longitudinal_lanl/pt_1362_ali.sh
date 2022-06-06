#!/bin/bash

# Need to run this in the ~HIV_latency_general/data/longitudinal_lanl directory

for file in C1V2 C2V5 gp41 nef p17 p24 RT tat vpr Vpu
do
  # Finds the sequence names for patient 1362
  # Pulls those sequences in a file
 grep 1362_d ${file}_1362.fasta |sed 's/>//g' > ${file}_1362_seqs

 if [ $file == vpr ] || [ $file == nef ]
 then
	 grep -v -f rm_${file} ${file}_1362_seqs > ${file}_1362_seqs_red
	 cp ${file}_1362_seqs_red  ${file}_1362_seqs
	 rm ${file}_1362_seqs_red
 fi

 ~/pullseq/src/./pullseq -i ${file}_1362.fasta -n ${file}_1362_seqs > ${file}_1362_reduced.fa

 # Swaps the order of the 2nd and last (1 or 2) field(s) in the name of the sequences
 # This makes the sample date the last part of the name of each sequence
 for name in $(cat ${file}_1362_seqs)
 do
   pat='(1362)(_d[0-9]+)(_.*)'
   [[ "$name" =~ $pat ]]
   newName=${BASH_REMATCH[1]}${BASH_REMATCH[3]}${BASH_REMATCH[2]}

   sed -i "s/${name}$/${newName}/g" ${file}_1362_reduced.fa
 done

# Realigns the sequences without the extra patient sequences
~/bin/mafft --maxiterate 1000 ${file}_1362_reduced.fa > ${file}_reali.fa
${file}_reali.fa > ${file}_1362_reduced.fa

Rscript scripts/stripGap.R ${file}_1362_reduced.fa ${file}_gapStrip.fa

# Make a tree with raxml
raxml-ng --msa ${file}_gapStrip.fa --model HKY+G --tree pars{25},rand{25} --seed 1 &> ${file} 

# Roots the raxml tree two ways: root to tip regression and midpoint rooting
Rscript scripts/root.R ${file}_gapStrip.fa.raxml.bestTree ${file}_mp.txt ${file}_rtt.txt

# Finds the number of sequences in the reduced alignment
numSeq=$(grep ">" ${file}_gapStrip.fa | wc -l)

# Strips the branch lengths from the rooted tree file
# Adds the number of sequences and the number of trees to the tree file
scripts/./stripbranchlengths.sh ${file}_mp.txt ${file}_strip_mp.txt
sed -i "1s/^/${numSeq} 1\n/" ${file}_strip_mp.txt

# Strips the branch lengths from the rooted tree file
# Adds the number of sequences and the number of trees to the tree file
scripts/./stripbranchlengths.sh ${file}_rtt.txt ${file}_strip_rtt.txt
sed -i "1s/^/${numSeq} 1\n/" ${file}_strip_rtt.txt

# Finds the name of the first sequence in the sequence file
# Then finds the length of the sequence (must subtract number of lines
# because of newline character)
firstSeq=$(grep ">" ${file}_gapStrip.fa | sed 's/>//g' |head -1)
line=$(~/pullseq/src/./pullseq -i ${file}_gapStrip.fa -g ${firstSeq} |tail -n +2 |wc -l)
char=$(~/pullseq/src/./pullseq -i ${file}_gapStrip.fa -g ${firstSeq} |tail -n +2 |wc -c)
seqLen=$((char-line))

# Adds the number of sequences and the sequence length to the alignment file
sed -i "1s/^/${numSeq} ${seqLen}\n/" ${file}_gapStrip.fa

done
