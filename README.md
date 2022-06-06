# HIVtreeAnalysis
## Software 
Necessary software to repeat the analysis in this study: 

1. HIVtreeSimulations:
https://github.com/nage0178/HIVtreeSimulations
(In home directory)

2. HIVtree:
https://github.com/nage0178/HIVtree
(In home directory)

3. mcmctree: 
https://github.com/abacus-gene/paml
Version 4.9

3. pullSeq:
https://github.com/bcthomas/pullseq
(In home directory)

4. RAxML-ng:
https://github.com/amkozlov/raxml-ng
(RAxML-NG v. 1.0.1-master released on 27.12.2020 by The Exelixis Lab)

5. MAFFT
(version 7.453)


3. R packages
	* ape
	* cowplot
	* ggplot2
	* ggpubr
	* GoFKernel
	* kdensity
	* optparse
	* phangorn
	* phytools
	* scales
	* tidyverse
	* viridis
	
There are additional packages required for the LR method. Please see the github for the method for further detail. 

4.  Existing dating methods
(In home directory)
	* Least Squares
https://github.com/tothuhien/lsd-0.3beta/releases/tag/v0.3.3
	* Maximum likelihood 
https://github.com/brj1/node.dating/releases/tag/v1.2
	* Linear Regression
https://github.com/cfe-lab/phylodating


## Running the Analysis
Do not try to run these scripts on a personal computer. 
These analysis are both time and memory intensive. 
The simulation of single tree may take too much RAM to be run on a personal computer. 
Many of the scripts run tens of thousands of jobs.

To simulate the tree topologies using the simulators in HIVtreeSimulations, run the following script 20 times, changing the argument to increase by one each time.
This simulation took several days to run and uses more RAM than is avaliable on most personal computers.
```
~/HIVtreeAnalysis/treeSimulation/checkpoint/runModel.sh 1
~/HIVtreeAnalysis/treeSimulation/checkpoint/runModel.sh 2
...

~/HIVtreeAnalysis/treeSimulation/checkpoint/runModel.sh 20
```

To estimate the parameters used in the DNA simulation with mcmctree, run the following scripts. 
Note that adding the outgroup to the existing alignments was done with the SynchAlign tool from the LANL database. See the manuscript for full details.
```
~/HIVtreeAnalysis/data/longitudinal_lanl/outgroup.sh
~/HIVtreeAnalysis/data/longitudinal_lanl/mkCtrl.sh
~/HIVtreeAnalysis/analysis/mu/runMCMC.sh
~/HIVtreeAnalysis/analysis/mu/empirical_mu.sh
```

To run the DNA simulation after the trees are created, run the following script 
```
~/HIVtreeAnalysis/dnaSimulations/alignments/runDnaSim.sh
~/HIVtreeAnalysis/dnaSimulations/sampleSize/runDnaSamleSize.sh
```

To run raxml 
``` 
~/HIVtreeAnalysis/analysis/raxml/runRaxml.sh
~/HIVtreeAnalysis/analysis/raxmlSS/runRaxml.sh
```

To run the analysis with HIVtree
``` 
~/HIVtreeAnalysis/analysis/runAllBayes.sh
~/HIVtreeAnalysis/analysis/runBayesSS.sh
```
The last command above must be run after the LS script (the next command below). 
It uses some of the same file

To run the least squares, maximum likelihood, and linear regression analysis, run these scripts, respectively. 
```
~/HIVtreeAnalysis/analysis/LS/runLSAll.sh
~/HIVtreeAnalysis/analysis/ML/runAllML.sh
~/HIVtreeAnalysis/analysis/LR/runAllLR.sh
```
Each of these scripts runs many separate scripts. 
It is recommended to look at the scripts before running them, and consider running each separate script individually. 
Note that the LS method uses files produced when preparing the HIVtree analysis. 

To produce the summary of the results and some figures 
``` 
~/HIVtree/analysis/summarizeResults.sh
~/HIVtree/analysis/regressionSum.sh
~/HIVtree/analysis/plots/plots.R

~/HIVtree/analysis/summarizeResultsSS.sh
~/HIVtree/analysis/regressionSumSS.sh
~/HIVtree/analysis/plotsSS/plotsSS.R
```


Analysis on the Jones et al. data set are run with the file 
```
~/HIVtreeAnalysis/data/jones/runJonesAll.sh
```
This also produces all of the figures for this dataset. 

Analysis on the Abrahams et al. data set are run with the file 
```
~/HIVtreeAnalysis/data/abrahams/runAbrahamsAll.sh
```
This also produces all of the figures for this dataset. 

## Figures 
Note than many of the figures are output to the directory.
In order for the scripts to work, you must have the same directory structure.
```
~/latency_manscript/figures
```
There are the files used to make the figures. 

Figure 1
```
~/HIVtreeAnalysis/analysis/fixedTreeplots.R 
```
In Supplement
```
~/HIVtreeAnalysis/analysis/longMcmcPlots/root.sh
~/HIVtreeAnalysis/analysis/plotRoot.R
```

Figure 2
```
~/HIVtreeAnalysis/analysis/longMCMC.sh
~/HIVtreeAnalysis/analysis/combineGenes/plotCombineEstimate.R
```

To make supplemental figure S2, in the ~/HIVtreeAnalysis/treeSimulation/compareVolume directory, 
```
make
```
Then run the following scripts. 
```
~/HIVtreeAnalysis/treeSimulation/runCompareVolume/runCompareVolume.sh
~/HIVtreeAnalysis/treeSimulation/compareVolume/compareVolume.sh
```

