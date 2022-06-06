#!/bin/bash


for pt in p1 p2
do
  # Creates unrooted tree
  raxml-ng --msa ${pt}_alignment_date.fa --model HKY+G --tree pars{25},rand{25} &> ${pt}_raxmlOut

  # Roots the tree in two different ways
  Rscript ../longitudinal_lanl/scripts/root.R ${pt}_alignment_date.fa.raxml.bestTree ${pt}_mp.txt ${pt}_rtt.txt

  # Finds the number of sequences in the alignment
  numSeq=$(grep ">" ${pt}_alignment_date.fa | wc -l)

  # Strips the branch lengths from the rooted tree file
  # Adds the number of sequences and the number of trees to the tree file
  ../longitudinal_lanl/scripts/./stripbranchlengths.sh ${pt}_mp.txt ${pt}_strip_mp.txt
  sed -i "1s/^/${numSeq} 1\n/" ${pt}_strip_mp.txt

  # Strips the branch lengths from the rooted tree file
  # Adds the number of sequences and the number of trees to the tree file
  ../longitudinal_lanl/scripts/./stripbranchlengths.sh ${pt}_rtt.txt ${pt}_strip_rtt.txt
  sed -i "1s/^/${numSeq} 1\n/" ${pt}_strip_rtt.txt

  # Finds the name of the first sequence in the sequence file
  # Then finds the length of the sequence (must subtract number of lines
  # because of newline character)
  firstSeq=$(grep ">" ${pt}_alignment_date.fa | sed 's/>//g' |head -1)
  line=$(~/pullseq/src/./pullseq -i ${pt}_alignment_date.fa -g ${firstSeq} |tail -n +2 |wc -l)
  char=$(~/pullseq/src/./pullseq -i ${pt}_alignment_date.fa -g ${firstSeq} |tail -n +2 |wc -c)
  seqLen=$((char-line))

  # Adds the number of sequences and the sequence length to the alignment file
  sed -i "1s/^/${numSeq} ${seqLen}\n/" ${pt}_alignment_date.fa

done
