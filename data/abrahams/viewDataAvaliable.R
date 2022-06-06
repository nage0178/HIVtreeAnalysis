alignSum <- read.csv("~/github/HIV_latency_general/data/abrahams/summaryAlignments")

library(ggplot2)
ggplot(alignSum, aes(x=date)) +facet_grid(cols = vars(alignment))+ geom_histogram()

counts <- table(alignSum$alignment)

for (i in 1:length(counts)){
  hist(alignSum[alignSum[, 1] == names(counts)[i], 3], main = names(counts)[i])
}

Cap217 <- alignSum[6961:8911, ]
Cap217Active <- Cap217[Cap217[ ,3] <400 , ]
Cap217QVOA <- Cap217[Cap217[ ,3] >400 , ]

counts217A <- table(Cap217Active$alignment)

alignCap217 <- which(counts217A != 0)
for (i in 1:length(alignCap217 )){
  hist(Cap217Active[Cap217Active[, 1] == names(alignCap217)[i], 3], main =  names(alignCap217)[i])
}

