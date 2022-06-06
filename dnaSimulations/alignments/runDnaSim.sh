#!/bin/bash

seed=1

maxBatch=20 # Should be 20
maxAli=30 #30 # Should be ~30
maxRep=5 # Should be 5
maxSub=3 # Should be 3
treeDir=~/HIVtreeAnalysis/treeSimulation/checkpoint/


# For each batch (this is naming for tree simualation)
for ((batch=1;batch<=maxBatch;batch++));
do
  # For each rep (this is naming for tree simualation)
  for ((rep=1;rep<=maxRep;rep++));
  do

    # For each gene/parameters combination
    for line in $(tail -n 4 ../ref_seq/parameter_est.csv)
    do

      # KO3444_geneName.fasta,mu,alpha,kappa,statFreq_A,statFreq_C,statFreq_G,statFreq_T
      #pat='K03455_(.*).fasta,([0-9]+.[0-9]+),([0-9]+.[0-9]+)'
      #gene,outgroup,mu,alpha,kappa,T,C,A,G
      pat='(.*),(.*),([0-9]+.[0-9]+),([0-9]+.[0-9]+),([0-9]+.[0-9]+),([0-9]+.[0-9]+),([0-9]+.[0-9]+),([0-9]+.[0-9]+),([0-9]+.[0-9]+)'
      [[ "$line" =~ $pat ]]

      gene=${BASH_REMATCH[1]}
      #og=${BASH_REMATCH[2]}
      mu=${BASH_REMATCH[3]}
      alpha=${BASH_REMATCH[4]}
      kappa=${BASH_REMATCH[5]}
      # Stationary frequencies
      piT=${BASH_REMATCH[6]}
      piC=${BASH_REMATCH[7]}
      piA=${BASH_REMATCH[8]}
      piG=${BASH_REMATCH[9]}


      # Make maxAli number of alignments
      for ((ali=1;ali<=maxAli;ali++));
      do

        # Simulate DNA
        ~/HIVtreeSimulations/dnaSim/./dna_sim -u ${mu} -a ${alpha} -i ../ref_seq/K03455_${gene}.fasta -s ${seed} -t ${treeDir}b${batch}r${rep}SampledTree.txt -l ${treeDir}b${batch}r${rep}LatentStates.txt -o b${batch}r${rep}a${ali}${gene} -f ${piA}:${piC}:${piG}:${piT}-1.0:${kappa}:1.0:1.0:${kappa}:1.0 -r &> b${batch}r${rep}a${ali}${gene}DNAout

        ((seed=seed+1))
      done
    done
  done
done

seed=1

# For each batch (this is naming for tree simualation)
for ((batch=1;batch<=maxBatch;batch++));
do

  # For each rep (this is naming for tree simualation)
  for ((rep=1;rep<=maxRep;rep++));
  do

    # Subsample the tree maxSub number of times
    # Each gene has the same true tree, thus outside of the gene loop
    for ((sub=1;sub<=maxSub; sub++));
    do
      gene=C1V2
      # This script does the subsampling
      Rscript ../subsample.R b${batch}r${rep}a1${gene}TreeOG.txt ${treeDir}../runFiles/samples.csv ${treeDir}../runFiles/subsample.csv b${batch}r${rep}s${sub} ${seed}

      # Strip branch lengths
      sed -E 's/:[0-9.Ee-]+//g' b${batch}r${rep}s${sub}_dropTipsTree.txt > b${batch}r${rep}s${sub}_strip.txt

      ((seed=seed+1))
      # Make new fasta file with only the sequences from the subsampled tree
      for ((ali=1;ali<=maxAli;ali++));
      do
        for gene in C1V2 nef tat p17
        do
        ~/pullseq/src/./pullseq -i b${batch}r${rep}a${ali}${gene}.fa -n b${batch}r${rep}s${sub}_keepTips.txt > b${batch}r${rep}a${ali}s${sub}${gene}.fa
      done
    done
  done
done
done


