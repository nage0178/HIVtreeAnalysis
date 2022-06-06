#!/bin/bash

# In order to reproduce the results from the paper, 
# The scripts should be run in this order. 
# It is encouraged to run them line by line, rather that
# to run them directly from this script
./root.sh &> outRoot

./prepareML.sh &> outPrepare

./runML.sh &> outRunML

./combineResults.sh &> outCombineResults


./rootSS.sh &> outRootSS

./prepareMLSS.sh &> outPrepareSS

./runMLSS.sh &> outRunMLSS

./combineResultsSS.sh &> outCombineResultsSS
