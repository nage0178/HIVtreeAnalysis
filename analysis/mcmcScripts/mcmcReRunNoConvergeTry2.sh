#!/bin/bash

awk -F / '{print $2}' convergenceOut2 | sed 's/.csv//g' > failedMcmc2
sed 's/$/_1/g' failedMcmc2 > runNames2.txt
sed 's/$/_2/g' failedMcmc2 >> runNames2.txt
for mcmc in $(cat failedMcmc2)
do 
	seed1=$(grep seed mcmctree/${mcmc}_1.ctl | awk '{print $3}')
	((seed1New=seed1+4))
	seed2=$(grep seed mcmctree/${mcmc}_2.ctl | awk '{print $3}')
	((seed2New=seed2+6))
	sed -i "s/seed = ${seed1}/seed = ${seed1New}/g" mcmctree/${mcmc}_1.ctl
	sed -i "s/seed = ${seed2}/seed = ${seed2New}/g" mcmctree/${mcmc}_2.ctl
	sed -i "s/nsample = 30000/nsample = 120000/g" mcmctree/${mcmc}_1.ctl
	sed -i "s/nsample = 30000/nsample = 120000/g" mcmctree/${mcmc}_2.ctl
	sed -i "s/burnin = 2500/burnin = 10000/g" mcmctree/${mcmc}_1.ctl
	sed -i "s/burnin = 2500/burnin = 10000/g" mcmctree/${mcmc}_2.ctl
done

rm failedMcmc2
