#!/bin/bash

seed=1

maxBatch=20 # Should be 20
maxAli=30 # Should be ~30
maxRep=5 # Should be 5
maxSub=3 # Should be 3


# Runs Raxml for each of the simulated data sets 
# First check to see if there is an existing raxml tree before running raxml
# This is because the script did not finish running and had to be restarted 

# trees in number of starting trees, parsimony + random
# msa is alignment
# model is substition model, could do Gn{a} where a is the number of rate categories
for ((ali=1;ali<=maxAli;ali++));
do
  for gene in nef tat p17 C1V2
  do
      for ((rep=1;rep<=maxRep;rep++));
      do
        for ((sub=1;sub<=maxSub;sub++));
        do
          for ((batch=1;batch<=maxBatch;batch++));
          do
	     if [ -f "b${batch}r${rep}a${ali}s${sub}${gene}raxmlOut" ];
	     then
		     if grep -q  time b${batch}r${rep}a${ali}s${sub}${gene}raxmlOut 
	             then
		          echo b${batch}r${rep}a${ali}s${sub}${gene} finished 
		     else 
		          echo b${batch}r${rep}a${ali}s${sub}${gene} restarting  
		          rm  *b${batch}r${rep}a${ali}s${sub}${gene}*  
                          raxml-ng --msa ~/HIVtreeAnalysis/dnaSimulations/alignments/b${batch}r${rep}a${ali}s${sub}${gene}.fa --model HKY+G --prefix b${batch}r${rep}a${ali}s${sub}${gene} --threads 1 --seed ${seed} --tree pars{25},rand{25} --outgroup outgroup &> b${batch}r${rep}a${ali}s${sub}${gene}raxmlOut &
		     fi 
             else
		     echo b${batch}r${rep}a${ali}s${sub}${gene} starting 
                     raxml-ng --msa ~/HIVtreeAnalysis/dnaSimulations/alignments/b${batch}r${rep}a${ali}s${sub}${gene}.fa --model HKY+G --prefix b${batch}r${rep}a${ali}s${sub}${gene} --threads 1 --seed ${seed} --tree pars{25},rand{25} --outgroup outgroup &> b${batch}r${rep}a${ali}s${sub}${gene}raxmlOut &

	     fi 
            ((seed=seed+1))
        done
      done
      wait $!
    done
  done
done
