library(kdensity)
mcmc <- read.table("outputFile", header=TRUE)
#apply(mcmc, 2, mean)


t5 <- kdensity(mcmc$t_n5, na.rm=TRUE, normalize =FALSE)
t6 <- kdensity(mcmc$t_n6, na.rm=TRUE, normalize =TRUE)
t7 <- kdensity(mcmc$t_n7, na.rm=TRUE, normalize =TRUE)
t4 <- kdensity(mcmc$t_n4, na.rm=TRUE, normalize =TRUE)
mu <- kdensity(mcmc$mu, na.rm=TRUE, normalize =TRUE)

p = seq(0,1, length=1000)

n <- 3

pdf("t5.pdf", width=7, height =5)
plot(t5)
dev.off()


k <- 3
pdf("t6.pdf", width=7, height =5)
plot(t6, xlab = "age of node BCD", main = "")
lines(p * 3.65, dbeta(p, k, n + 1 - k) / 3.65, type='l', col = "red")
dev.off()


k <- 2
pdf("t7.pdf", width=7, height =5)
plot(t7, xlab = "age of node CD", main = "")
lines(p * 3.65, dbeta(p, k, n + 1 - k) / 3.65, type='l', col = "red")
dev.off()

k <- 1
pdf("t4.pdf", width=7, height =5)
plot(t4, xlab = "latent time", main = "")
lines(p * 3.65, dbeta(p, k, n + 1 - k) / 3.65, type='l', col = "red")
dev.off()

p <- seq(0,.05, length=1000)
pdf("mu.pdf", width=7, height =5)
plot(mu, xlab = "mutation rate", main = "")
lines(p, dgamma(p, 2, 200), type ='l', col = "red")
dev.off()
