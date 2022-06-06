#!/bin/bash

# The scripts should be run in this order to reproduce the results
# It is recommended to run each line individually, rather than running 
# this script
./rmOGtoLR.sh &> outRmOG

./prepare_input1.sh &> outPrepare1

./prepare_input2.sh &> outPrepare2

./runAnalysis.sh &> outrunAnalysis

./combineResults.sh &> outCombine

./rmOGtoLRSS.sh &> outRmOGSS

./prepare_input1SS.sh &> outPrepare1SS

./prepare_input2SS.sh &> outPrepare2SS

./runAnalysisSS.sh &> outrunAnalysisSS

./combineResultsSS.sh &> outCombineSS
