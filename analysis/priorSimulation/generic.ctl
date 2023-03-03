seed = -1

seqfile = seqData.fa 
treefile = tree.tre
mcmcfile = mcmc.txt
outfile = out.txt

seqtype = 0
usedata = 0

ndata = 1
clock = 1
TipDate = 1 1000

RootAge = G(5,10)
*RootAge = F(.5,1)
model = 0
alpha =  0 

cleandata = 0

rgene_gamma = 2 200
sigma2_gamma = 2 2 1

print = 1
burnin = 100000
sampfreq =25 
nsample = 500000

latentFile = latent.txt
priorRat = 1
