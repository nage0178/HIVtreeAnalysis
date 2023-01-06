#!/bin/bash

maxBatch=20  # Should be 20
maxAli=30  # Should be 30
maxRep=5 # Should be 5
maxSub=3 # Should be 3


awk -F / '{print $2}' convergenceOut | sed 's/.csv//g' > failedMcmc
sed 's/$/_1/g' failedMcmc > runNames.txt
sed 's/$/_2/g' failedMcmc >> runNames.txt
for mcmc in $(cat failedMcmc)
do 


	seed1=$(grep seed mcmctree/${mcmc}_1.ctl | awk '{print $3}')
	((seed1New=seed1+2))
	seed2=$(grep seed mcmctree/${mcmc}_2.ctl | awk '{print $3}')
	((seed2New=seed2+2))
	sed -i "s/seed = ${seed1}/seed = ${seed1New}/g" mcmctree/${mcmc}_1.ctl
	sed -i "s/seed = ${seed2}/seed = ${seed2New}/g" mcmctree/${mcmc}_2.ctl
	sed -i "s/nsample = 30000/nsample = 60000/g" mcmctree/${mcmc}_1.ctl
	sed -i "s/nsample = 30000/nsample = 60000/g" mcmctree/${mcmc}_2.ctl
done

rm failedMcmc
rm latentRerunFiles
