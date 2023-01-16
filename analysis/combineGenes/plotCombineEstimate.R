library(kdensity)
library(GoFKernel)

timeUnit <- 1000
timeZero <- 3650
lowerInt <- 0
upperInt <- 3.695

inFile <- "~/HIVtreeAnalysis/analysis/longMcmcPlots/b1r1a1s1_Node_1_888_2009_3650.csv"
times<- read.csv(inFile, sep = "\t")

names(times) <- c("C1V2", "nef", "p17", "tat", "C1V2Prior", "nefPrior", "p17Prior", "tatPrior")
times <- times[1:(dim(times)[1]/2), ]

C1V2Post <- kdensity(times$C1V2, na.rm = TRUE, normalize = FALSE)
nefPost  <- kdensity(times$nef,  na.rm = TRUE, normalize = FALSE)
p17Post  <- kdensity(times$p17,  na.rm = TRUE, normalize = FALSE)
tatPost  <- kdensity(times$tat,  na.rm = TRUE, normalize = FALSE)

C1V2Prior <- kdensity(times$C1V2Prior, na.rm = TRUE, normalize = FALSE)
nefPrior  <- kdensity(times$nefPrior,  na.rm = TRUE, normalize = FALSE)
p17Prior  <- kdensity(times$p17Prior,  na.rm = TRUE, normalize = FALSE)
tatPrior  <- kdensity(times$tatPrior,  na.rm = TRUE, normalize = FALSE)

adjTime <- function (time) {
  timeZero - time * timeUnit
}

###
constant <- integrate(function(x) C1V2Post(x) * nefPost(x) * p17Post(x) * tatPost(x)/ tatPrior(x) / nefPrior(x) / p17Prior(x) /C1V2Prior(x), lower = lowerInt, upper = upperInt)$value
dist <- function (x) {
  integrate(function (x) C1V2Post(x) * nefPost(x) * p17Post(x) * tatPost(x)/ tatPrior(x) / nefPrior(x) / p17Prior(x)/C1V2Prior(x) / constant, lower = lowerInt, upper = x)[[1]]
}
invFunc <- inverse(dist, lower = lowerInt, upper = upperInt)

xlimits <- c(-0, 3.695)
ylimits <- c(0,3)
pdf("~/latency_manuscript/figures/combinedLatent.pdf", width = 7, height = 5)

plot(function(x) C1V2Post(x) * nefPost(x) * p17Post(x) * tatPost(x)/ tatPrior(x) / nefPrior(x) / p17Prior(x) /C1V2Prior(x) /constant, 
     xlim = xlimits, 
     ylim = ylimits, 
     lwd = 2,
     xlab = "Latent Integration Time", 
     ylab = "Density", )

lines(tatPost, col = "green")
lines(nefPost, col = "red")
lines(p17Post, col = "blue")
lines(C1V2Post, col = "purple")

# Prior
lines(tatPrior, col = "green", lty = 2)
lines(C1V2Prior, col = "purple", lty = 2)
lines(nefPrior, col = "red", lty = 2)
lines(p17Prior, col = "blue", lty = 2)
abline(v = (3650 - 2009) / 1000)

legend(3, 3, legend=c("Combined", "C1V2", "Nef", "p17", "tat"),
       col=c("black", "purple", "red", "blue", "green"), lwd=c(1,1,1,1,1), cex=0.8)
dev.off()
