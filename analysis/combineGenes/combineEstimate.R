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

  # Used to convert to calendar time, HIVtree reports in backwards time
  # with a different time scale
  timeUnit <- as.numeric(args[4])
  timeZero <- as.numeric(args[5])
}

times<- read.csv(inFile, sep = "\t")

names(times) <- c("C1V2", "nef", "p17", "tat", "C1V2Prior", "nefPrior", "p17Prior", "tatPrior")

# Kernel density estimation 
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
# Finds the integration constant to renormalize
constant <- integrate(function(x) C1V2Post(x) * nefPost(x) * p17Post(x) * tatPost(x)/ tatPrior(x) / nefPrior(x) / p17Prior(x) /C1V2Prior(x), lower = lowerInt, upper = upperInt)$value
dist <- function (x) {
  integrate(function (x) C1V2Post(x) * nefPost(x) * p17Post(x) * tatPost(x)/ tatPrior(x) / nefPrior(x) / p17Prior(x) / C1V2Prior(x) / constant, lower = lowerInt, upper = x)[[1]]
}

invFunc <- inverse(dist, lower = lowerInt, upper = upperInt)
# Find the 95 % credible set 
lowerEst <- invFunc(.025)
upperEst <- invFunc(.975)

# Finds the mean
meanEst <- integrate(function(x) x * C1V2Post(x) * nefPost(x) * p17Post(x) * tatPost(x)/ tatPrior(x) / nefPrior(x) / p17Prior(x) / C1V2Prior(x)/constant, lower = lowerInt, upper = upperInt)[[1]]

print(paste(adjTime(meanEst), adjTime(upperEst), adjTime(lowerEst), sep = ","))
