#!/bin/bash

# This will run all of the abrahams analyses
# It is encouraged to run line by line, rather
# than directly from this script. Do not run these
# on a personal computer.
./prepareAbrahams.sh &> outPrepareAbrahams

./summary.sh &> outSummary 

./subsetAlign.sh &> outSubset

# Infers tree
./runRaxml.sh &> outRaxml
wait

# Prepares and runs existing methods
./makeLR.sh &> outMakeLR

./runML.sh &> outRunML

./runLR.sh &> outRunLR

./runLSD.sh &> outRunLSD

./parseTreeLSD.sh &> outParseTree

# Prepares and runs Bayesian methods
./prepareMcmcTree.sh &> outPrepMCMC 

./prepPriormcmctree.sh &> outPrepPrior

./runMcmcTree.sh &> outRunMcmc &&
wait

./runMcmcTreePrior.sh &> outmcmcPrior

./mcmcConvergence.sh &> outMcmcConvergence

./runDidNotConverge.sh &> outNoConverge &&
wait

./mcmcConvergence.sh &> outMcmcConvergence2

./mcmcParse.sh &> outMcmcParse 

# Combines results from different genes
./findMatchQVOA.sh &> outFindQVOA

./combineGenes.sh &> outCombineGenes 

./combinePosterior.sh &> outCombinePosterior 

# Summarize all results
./combineCSV.sh &> outCombine

# Plots for manuscript
Rscript abrahams_mainText.R
Rscript abrahams_plots.R
