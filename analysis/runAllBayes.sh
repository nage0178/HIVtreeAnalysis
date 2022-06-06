#!/bin/bash

# Root
./mcmcScripts/root_mcmctree.sh &> outRoot 

# Prepares input files
./mcmcScripts/prepareMcmcTree.sh &> outPrepMCMC 

# Runs the MCMC
./runMcmcTree.sh &> outRunMCMC 

# Checks convergence
./mcmcScripts/mcmcConvergence.sh &> convergenceOut


# Prepares control files for MCMCs that need to be rerun
./mcmcScripts/mcmcRerunNoConverge.sh &>  outMcmcRunNoConverge


# Need to start the ones that need re-running
./reRunMcmcTree.sh &> outMcmcReRun 

# Check convergence 
./mcmcScripts/mcmcConvergenceReRun.sh &> convergenceOut2

#Prepare to run a second time
./mcmcScripts/mcmcReRunNoConvergeTry2.sh

# Run a second time
./reRunFinalMcmcTree.sh &> outReRunFinalMcmc

# Check convergence
./mcmcScripts/mcmcConvergenceFinalRerun.sh


# Parse
./mcmcScripts/mcmcCombineOut.sh &> outmcmccombine


# Another script for running without data preparePriors.sh
# Run again 
./mcmcScripts/preparePriors.sh


# Run under prior
./runMcmcTreePrior.sh

# Combines estimates across genes
./combineGenes/summarizeResults.sh

./combineGenes/summarizePosterior.sh

./combineGenes/summarizePosterior2.sh

./combineGenes/rmNonintegrable.sh

./combineGenes/rmNonintegrable2.sh

# Figures
./longMcmc.sh 

./combineGenes/summarizeResultsLongRun.sh
