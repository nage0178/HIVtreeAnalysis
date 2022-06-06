args = commandArgs(trailingOnly = TRUE)

meanGamma <- as.numeric(args[1])
varGamma <- as.numeric(args[2])
timeScale <- as.numeric(args[3])
lastSample <- as.numeric(args[4])
meanGamma <- meanGamma / timeScale
beta <- meanGamma / varGamma
alpha <- varGamma * beta^2

print(alpha)
print(beta)
print(lastSample/timeScale)
