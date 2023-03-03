#!/bin/bash
make

./testPrior > rejSim.txt

~/HIVtree/HIVtree generic.ctl

Rscript priorComparison.R

