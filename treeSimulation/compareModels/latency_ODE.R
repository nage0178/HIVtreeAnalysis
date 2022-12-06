library(deSolve)
library(ggplot2)
library(gridExtra)
library(ggplotify)
library(cowplot)
mLBlood <- 100 # mL of blood we are approximating
# Initial conditions. The number before the multiplication is the concentration
# in units mLBlood ^-1 
state <- c(Tcell = 10^4 * mLBlood,
          #Tcell = 10^6 * mLBlood, 
           Tstar = 1 , 
           V = 10 * mLBlood,
           Latent = 0 * mLBlood, 
           Incomp = 0 * mLBlood
)


parameters<- rep(0, 11)
names(parameters) <- c("lambda", "d", "k", "p", "c", "delta", "n", "alpha", "gamma", "sigma", "tau")
parameters["lambda"] <- 170 * mLBlood      # Birth rate of uninfected cells
parameters["d"] <- 0.017                     # Death rate of uninfected cells
parameters["k"] <-8*10^-7 / mLBlood     # Rate of transition from uninfected to actively infected cells
parameters["p"] <- 730                    # Viral birth rate
parameters["c"] <- 3                       # Viral clearance rate
parameters["delta"] <- .31                    # Actively infectevid cell death rate
parameters["n"] <- 1.16*10^-3    #fix this number                # Probability that a newly infected cell is latently infected 
#Fix number so that 56 rep. comp per mL in blood if say 2 % of 1.4*10^6  rep comp in blood, 98% in lymph tissue, otherwise, 280 in blood if spread over 5 L of blood
# to get 280, use 1.16*10^-3. To get 56, use 2.27*10^-4 
parameters["alpha"] <- 5.7*10^-5                # Rate of activation of replication competent, latently infected cells
parameters["gamma"] <- .95                  # Proportion of viruses that are defective
parameters["sigma"] <- 0.00052                    # Death rate of latently infected replication incompetent cells
parameters["tau"] <- 0.00011         # Death rate of latently infected, rerplication compenent cells 


measured_kappa <- 8*10^-7/ mLBlood
parameters["k"] <- measured_kappa/ (1-parameters["gamma"])/ (1 - parameters["n"])

virusODE <- function (t, state, parameters) {
  with(as.list(c(state, parameters)), {
    dT <- lambda - d*Tcell - (1 - gamma *(1-n)) * k*Tcell*V
    dTstar <-(1-n) * ((1-gamma) * k )*Tcell*V - delta*Tstar + alpha * Latent
    dV <- p*Tstar - c*V
    dLatent <- (1-gamma) * n * k * Tcell * V - alpha * Latent - sigma * Latent
    dIncomp <- gamma * n * k * Tcell * V - tau * Incomp

    list(c(dT, dTstar, dV, dLatent, dIncomp))
  })
}


times <- seq(0, 300, by = 0.01)
out <- ode(y = state, times = times, func = virusODE, parms = parameters)
timesART <- seq(300, 365, by =0.01)
stateART <- c(Tcell = as.numeric(out[dim(out)[1], 2]),
              #Tcell = 10^6 * mLBlood, 
              Tstar = as.numeric(out[dim(out)[1], 3]), 
              V = as.numeric(out[dim(out)[1], 4]),
              Latent = as.numeric(out[dim(out)[1], 5]), 
              Incomp = as.numeric(out[dim(out)[1], 6]))
parameters["k"] <-0
outART <- ode(y=stateART, times = timesART, func = virusODE, parms = parameters)

outAll <- rbind(out, outART)

plot(outAll)
out <- outAll
testing <- read.csv("~/HIVtreeAnalysis/treeSimulation/manuscript_figure.txt")
#testing <- read.csv("~/HIVtreeAnalysis/treeSimulation/compareModels/testing")

##### THIS IS THE PART I USED TO MAKE THE GRAPHS
margins = c(4, 3, 4, 1)
r6 <-as.ggplot(function() {par(oma=c(1,3,0,0), mar = margins)
  plot(testing[, 1], testing[, "numCellUninfect"], type = "l", log = "y", ylab = "Number of Cells or Virions", xlab = "", col = 2, 
       xlim = c(0, 370), yaxt="n")
  axis(2, at= c(40000, 200000, 800000))
  lines(out[, c(1,2)])
  title("Uninfected Cells", line = .5, cex.main = 1)
})

r7 <-as.ggplot(function() {par(oma=c(1,1,0,0), mar = margins)
  plot(testing[, 1], testing[ , "numCellInfect"], type = "l",  log = "y", ylab = "", xlab = "", col = 2, ylim = c(min(out[,3]), max(out[,3])), 
       xlim = c(0, 370), yaxt="n")
  axis(2, at= c(10, 1000, 100000))
  lines(out[350:dim(out)[1], c(1,3)])
  title("Actively Infected Cells", line = .5, cex.main = 1)})
r7

r8 <-as.ggplot(function() {par(oma=c(1,1,0,0), mar = margins)
  plot(testing[, 1], testing[, "numVirus"], type = "l", log = "y", xlab = "Time (days)", ylab = "", col = 2, ylim = c(min(out[,4]), max(out[,4])) , 
       xlim = c(0, 370), yaxt="n")
  axis(2, at= c(1000, 100000, 10000000))
  lines(out[100:dim(out)[1], c(1,4)])
  title("Virions", line = .5, cex.main = 1)})

r9 <-as.ggplot(function() {par(oma=c(1,1,0,0), mar = margins)
  plot(testing[, 1], testing[, "numLatentComp"], type = "l", log = "y", ylab = "", xlab = "", col = 2, 
       xlim = c(0, 370), yaxt="n")
  axis(2, at= c(2, 20, 200, 2000))
  lines(out[600:dim(out)[1], c(1,5)])
  title("Latent Replication \nCompetent Cells", line = .5, cex.main = 1)})

r10 <-as.ggplot(function() {par(oma=c(1,1,0,0), mar = margins)
  plot(testing[, 1], testing[, "numLatentIncomp"], type = "l", log = "y", ylab = "", xlab = "", col = 2, 
       xlim = c(0, 370), yaxt="n")
  axis(2, at= c(50, 500, 5000, 50000))
  lines(out[550:dim(out)[1], c(1,6)])
  title("Latent Replication \nIncompetent Cells", line = .5, cex.main = 1)})

panel5 <- plot_grid(r6, r7, r8, r9, r10, nrow=1, ncol = 5, scale = 1)
pdf("~/latency_manuscript/figures/compare_stoch_det_ART.pdf", width = 11, height = 4)
 panel5 
dev.off()
# save as pdf, 4x11

