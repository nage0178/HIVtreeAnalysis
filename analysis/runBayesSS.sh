#!/bin/bash

##### Sample size
# how did the trees get here
./mcmcScripts/prepareMcmcTreeSS.sh &> outPrepMCMCSS


# Run the sample size
./runMcmcTreeSS.sh &> outRunMcmcSS & 

# Check convergence
./mcmcScripts/checkConvergenceSS.sh

# prepare to run again
./mcmcScripts/mcmcSSNoConverge.sh

# Run again 
./reRunMcmcTreeSS.sh &> outReRunMcmcSS 

# Check convergence
./mcmcScripts/checkConvergenceSSRerun.sh

# Parse/combine
./mcmcScripts/mcmcCombineOutSS.sh


