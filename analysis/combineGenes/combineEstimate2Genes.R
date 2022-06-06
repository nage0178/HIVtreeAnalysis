library(kdensity)
library(GoFKernel)

args = commandArgs(trailingOnly = TRUE)
if(length(args) != 5) {
  stop("Incorrect number of arguements")
} else {
  # MCMC file
  inFile <- args[1]

  # Integration bounds
  lowerInt <- as.numeric(args[2])
  upperInt <- as.numeric(args[3])

  # To convert to calendar time from the output of the MCMC
  timeUnit <- as.numeric(args[4])
  timeZero <- as.numeric(args[5])
}

times<- read.csv(inFile, sep = "\t")

names(times) <- c("C1V2", "nef", "p17", "tat", "C1V2Prior", "nefPrior", "p17Prior", "tatPrior")

# Kernel density estimate
p17Post  <- kdensity(times$p17,  na.rm = TRUE, normalize = FALSE)
tatPost  <- kdensity(times$tat,  na.rm = TRUE, normalize = FALSE)

p17Prior  <- kdensity(times$p17Prior,  na.rm = TRUE, normalize = FALSE)
tatPrior  <- kdensity(times$tatPrior,  na.rm = TRUE, normalize = FALSE)


adjTime <- function (time) {
  timeZero - time * timeUnit
}

###
# Find the integrating constant so the the density integrates to 1
constant <- integrate(function(x)  p17Post(x) * tatPost(x)/ tatPrior(x) / p17Prior(x), lower = lowerInt, upper = upperInt)$value
dist <- function (x) {
  integrate(function (x) p17Post(x) * tatPost(x)/ tatPrior(x) / p17Prior(x) /constant, lower = lowerInt, upper = x)[[1]]
}
# Finds the 95% credible set
invFunc <- inverse(dist, lower = lowerInt, upper = upperInt)
lowerEst <- invFunc(.025)
upperEst <- invFunc(.975)

# Finds the mean
meanEst <- integrate(function(x) x * p17Post(x) * tatPost(x)/ tatPrior(x) /  p17Prior(x) /constant, lower = lowerInt, upper = upperInt)[[1]]
print(paste(adjTime(meanEst), adjTime(upperEst), adjTime(lowerEst), sep = ","))
