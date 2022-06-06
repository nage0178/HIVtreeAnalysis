#!/bin/bash

# Runs all of the analysis for the Jones et al. dataset
# This will take a long time to run due to the MCMCs.
# It is recommended to ru this line by line rather than 
# all at once
./sortPatients.sh &> outSort &&

./runRaxml.sh &> outRaxml &&

wait 
./runML.sh &> outML &&

wait 
./makeLR.sh &> outMakeLR &&

wait 
./runLR.sh &> outLR &&

wait 
./runLSD.sh &> outLSD &&

wait
./parseTreeLSD.sh &> outParse &&

wait 
./prepareMcmcTree.sh &> outPrepmcmc &&

wait 
./runMcmcTree.sh &> outRunMcmc &&

wait
./mcmcConvergence.sh &> outConvergence &&

wait
./mcmcParse.sh &> outMcmcParse &&

wait
./combineCSV.sh &> outCombine &

wait
Rscript jones_plots.R
