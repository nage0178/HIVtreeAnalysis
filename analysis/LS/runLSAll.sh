#!/bin/bash

# This will run the entire analysis for the LS methods
# Do not run this on a personal computer. 
# It is recommended to run each line individually rather than
# all at once. 

./runLSD.sh &> outRunLS

./parseTree.sh &> outParse

./combineCSV.sh &> outCombine

./runSampleSizeLSD.sh &> outRunSS

./parseTreeSS.sh &> outParseSS

./combineCSVSS.sh &> outCombineSS 
