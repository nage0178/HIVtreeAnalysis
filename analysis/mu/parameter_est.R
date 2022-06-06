mu <- read.csv("~/HIVtreeAnalysis/analysis/mu/mu.csv")

# Finds the average of all of the parameters by outgroup
C1V2 <- as.data.frame(mu[which(mu[,1] == "C1V2"),])
C1V2_avg <- aggregate(C1V2[4:16], list(C1V2$outgroup), mean)

# Finds the average confidence interval size for each outgroup
C1V2_avg <- cbind (C1V2_avg, (C1V2_avg[ , 4] - C1V2_avg[ , 3]) / C1V2_avg[, "mu"] )
colnames(C1V2_avg)[length(colnames(C1V2_avg))] <- "mean_CI_size"

# Finds the outgroup with the smallest average confidence interval
C1V2_outgroup <- C1V2_avg[which(C1V2_avg[ , "mean_CI_size"] == min(C1V2_avg[ , "mean_CI_size"])), 1]

# Finds the average of all of the parameters by outgroup
nef <- as.data.frame(mu[which(mu[,1] == "nef"),])
nef_avg <- aggregate(nef[4:16], list(nef$outgroup), mean)

# Finds the average confidence interval size for each outgroup
nef_avg <- cbind (nef_avg, (nef_avg[ , 4] - nef_avg[ , 3]) / nef_avg[, "mu"] )
colnames(nef_avg)[length(colnames(nef_avg))] <- "mean_CI_size"

# Finds the outgroup with the smallest average confidence interval
# 1006 has a much different rooting than the other 3 outgroups. Of the other three outgroups, the estimates are very similar. 
# The rooting is in the same location for CS2 and PIC55751, so I use the outgroup with the smallest rooting of those two
nef_outgroup <- nef_avg[which(nef_avg[ , "mean_CI_size"] == min(nef_avg[-c(1,2) , "mean_CI_size"])), 1]

# Finds the average of all of the parameters by outgroup
p17 <- as.data.frame(mu[which(mu[,1] == "p17"),])
p17_avg <- aggregate(p17[4:16], list(p17$outgroup), mean)

# Finds the average confidence interval size for each outgroup
p17_avg <- cbind (p17_avg, (p17_avg[ , 4] - p17_avg[ , 3]) / p17_avg[, "mu"] )
colnames(p17_avg)[length(colnames(p17_avg))] <- "mean_CI_size"

# Finds the outgroup with the smallest average confidence interval
p17_outgroup <- p17_avg[which(p17_avg[ , "mean_CI_size"] == min(p17_avg[ , "mean_CI_size"])), 1]

# Finds the average of all of the parameters by outgroup
tat <- as.data.frame(mu[which(mu[,1] == "tat"),])
tat_avg <- aggregate(tat[4:16], list(tat$outgroup), mean)

# Finds the average confidence interval size for each outgroup
tat_avg <- cbind (tat_avg, (tat_avg[ , 4] - tat_avg[ , 3]) / tat_avg[, "mu"] )
colnames(tat_avg)[length(colnames(tat_avg))] <- "mean_CI_size"

# Finds the outgroup with the smallest average confidence interval
tat_outgroup <- tat_avg[which(tat_avg[ , "mean_CI_size"] == min(tat_avg[ , "mean_CI_size"])), 1]


estimates <- C1V2[intersect(which(C1V2[, "outgroup"] == C1V2_outgroup), which(C1V2[ , "rep"] == 1)), ]
estimates <- rbind(estimates, nef[intersect(which(nef[, "outgroup"] == nef_outgroup), which(nef[ , "rep"] == 1)), ])
estimates <- rbind(estimates ,p17[intersect(which(p17[, "outgroup"] == p17_outgroup), which(p17[ , "rep"] == 1)), ] )
estimates <- rbind(estimates , tat[intersect(which(tat[, "outgroup"] == tat_outgroup), which(tat[ , "rep"] == 1)), ])

final <- estimates[ , -c(2, 5, 6, 8, 9, 11, 12)]
final[, "mu"] <- final[,"mu"] * 10^-3 # This is to account for the fact mcmc tree has a scaling factor, which is set to 1000 in the control file
write.csv(format(final, scientific = FALSE), "~/HIVtreeAnalysis/analysis/mu/parameter_est.csv", row.names = FALSE)
