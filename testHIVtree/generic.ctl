seed = -1

seqfile = ../generic.fa 
treefile = ../mcmcTree.txt
mcmcfile = mcmc.txt
outfile = out.txt

seqtype = 0
usedata = 1

ndata = 1
clock = 1
TipDate = 1 1000

RootAge = F(3.6499,3.6501)
model = 0
alpha =  0 

cleandata = 0

rgene_gamma = 2 200
sigma2_gamma = 2 2 1

print = 1
burnin = 100000
sampfreq =25 
nsample = 15000

latentFile = ../seqsL.txt
latentBound = 3.695
