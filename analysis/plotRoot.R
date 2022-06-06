library(kdensity)

prior <- read.table("~/HIVtreeAnalysis/analysis/longMcmcPlots/b1r1a1s1C1V2prior_1/root.txt", header=TRUE)
prior <-prior[, 1]

priorKDE <- kdensity(prior, na.rm = TRUE, normalize = TRUE)

pdf("~/latency_manuscript/figures/rootAge.pdf")
plot(function(x) dgamma(x - .365 * 9 , shape = 36.5, rate = 100, log = FALSE), xlim = c(0,5), xlab = "Root Age", ylab = "Probability Density")
lines(priorKDE, col = "red")
lines(seq(0,4, by = .1), rep(0, 41), xlim = c(0,4), col = "red")
dev.off()
