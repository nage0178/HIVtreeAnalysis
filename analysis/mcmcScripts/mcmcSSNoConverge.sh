#!/bin/bash


awk -F / '{print $2}' outMcmcConv2 | sed 's/.csv//g' > failedMcmcSS
sed 's/$/_1/g' failedMcmcSS > runNamesSS.txt
sed 's/$/_2/g' failedMcmcSS >> runNamesSS.txt
for mcmc in $(cat failedMcmcSS)
do 


	seed1=$(grep seed mcmctreeSS/${mcmc}_1.ctl | awk '{print $3}')
	((seed1New=seed1+2))
	seed2=$(grep seed mcmctreeSS/${mcmc}_2.ctl | awk '{print $3}')
	((seed2New=seed2+2))
	sed -i "s/seed = ${seed1}/seed = ${seed1New}/g" mcmctreeSS/${mcmc}_1.ctl
	sed -i "s/seed = ${seed2}/seed = ${seed2New}/g" mcmctreeSS/${mcmc}_2.ctl
	sed -i "s/nsample = 50000/nsample = 100000/g" mcmctreeSS/${mcmc}_1.ctl
	sed -i "s/nsample = 50000/nsample = 100000/g" mcmctreeSS/${mcmc}_2.ctl
	sed -i "s/burnin = 5000/burnin = 10000/g" mcmctreeSS/${mcmc}_1.ctl
	sed -i "s/burnin = 5000/burnin = 10000/g" mcmctreeSS/${mcmc}_2.ctl
done

rm failedMcmcSS
