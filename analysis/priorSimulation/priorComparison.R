rejSim <- read.table("rejSim.txt", header = TRUE)
mcmc <- read.table("mcmc.txt", header = TRUE)



pdf("~/latency_manuscript/figures/priorComparison.pdf", width = 5, height = 7)
par(mfrow=c(3,1))
den_rejSim <-density(rejSim$t_ABC)
den_mcmc <- density(mcmc$t_n4)
plot(den_rejSim, col ="red", xlab = "root age", main = "")
lines(den_mcmc)

den_rejSim_l <-density(rejSim$t_Al)
den_mcmc_l <- density(mcmc$t_n3)
plot(den_rejSim_l, col ="red", xlab = "latent integration time", main = "")
lines(den_mcmc_l)

den_rejSim_BC <-density(rejSim$t_BC)
den_mcmc_BC <- density(mcmc$t_n5)
plot(den_rejSim_BC, col ="red", xlab = "Age of node BC", main = "")
lines(den_mcmc_BC)

dev.off()