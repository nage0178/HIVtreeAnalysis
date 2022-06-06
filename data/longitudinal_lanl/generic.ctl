seed = -1

seqfile = ../../../../data/longitudinal_lanl/C1V2.fa 
treefile = ../../../../data/longitudinal_lanl/C1V2.txt
mcmcfile = mcmc.txt
outfile = out.txt

seqtype = 0
usedata = 1

ndata = 1
clock = 1
TipDate = 1 1000

RootAge = B(1, 10.0, 0.01, 0.01)
model = 4
alpha = 1.5
ncatG = 15

cleandata = 0

alpha_gamma = 1 1
rgene_gamma = 2 200
sigma2_gamma = 2 2 1

BDparas = 2 1 0 1.8

finetune = 1: 0.5 0.2 0.1 0.05 0.05 0.05

print = 1
burnin = 1000
sampfreq = 2
nsample = 10000
kappa_gamma = 8 1
