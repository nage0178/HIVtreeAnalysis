library(ggplot2)

ndFiles <- c("~/HIVtreeAnalysis/analysis/ML/results/b3r1s1C1V2_combine.csv",
             "~/HIVtreeAnalysis/analysis/ML/results/b3r1s1nef_combine.csv",
             "~/HIVtreeAnalysis/analysis/ML/results/b3r1s1p17_combine.csv",
             "~/HIVtreeAnalysis/analysis/ML/results/b3r1s1tat_combine.csv")

lsdFiles <- c("~/HIVtreeAnalysis/analysis/LS/results/b3r1s1C1V2_combine.csv",
              "~/HIVtreeAnalysis/analysis/LS/results/b3r1s1nef_combine.csv",
              "~/HIVtreeAnalysis/analysis/LS/results/b3r1s1p17_combine.csv",
              "~/HIVtreeAnalysis/analysis/LS/results/b3r1s1tat_combine.csv")

jonesFiles <- c("~/HIVtreeAnalysis/analysis/LR/results/b3r1s1C1V2_combine.csv",
                "~/HIVtreeAnalysis/analysis/LR/results/b3r1s1nef_combine.csv",
                "~/HIVtreeAnalysis/analysis/LR/results/b3r1s1p17_combine.csv",
                "~/HIVtreeAnalysis/analysis/LR/results/b3r1s1tat_combine.csv")

bayesFiles <- c("~/HIVtreeAnalysis/analysis/mcmctree/b3r1s1C1V2_combine.csv",
                "~/HIVtreeAnalysis/analysis/mcmctree/b3r1s1nef_combine.csv",
                "~/HIVtreeAnalysis/analysis/mcmctree/b3r1s1p17_combine.csv",
                "~/HIVtreeAnalysis/analysis/mcmctree/b3r1s1tat_combine.csv")
jones <- c()
for (i in 1:length(jonesFiles)){
  jones <- rbind(jones, read.csv(jonesFiles[i]))
}
jones <- cbind(jones)

nd <- c()
for (i in 1:length(ndFiles)){
  nd <- rbind(nd, read.csv(ndFiles[i]))
}
nd <- cbind(nd, NA, NA)

lsd <- c()
for (i in 1:length(lsdFiles)){
  lsd <- rbind(lsd, read.csv(lsdFiles[i]))
}

bayes <- c()
for (i in 1:length(bayesFiles)){
  bayes <- rbind(bayes, read.csv(bayesFiles[i]))
}
bayes <-bayes[, -6]

names(jones) <- names(lsd)
names(nd) <- names(lsd)

data <- rbind(jones, nd, lsd, bayes)
data <- cbind(data, c(rep("LR", dim(jones)[1]), 
              rep("ML", dim(nd)[1]),
              rep("LS", dim(lsd)[1]), 
              rep("Bayes", dim(bayes)[1])))
names(data)[length(names(data))] <- "analysis"
data$trueDate <- data$trueDate/365
data$nodeDate <- data$nodeDate/365

p <- ggplot(data, aes(trueDate, nodeDate)) + geom_point(cex = .1) + theme_bw() +
  labs(
    x = "True Integration Time (years after infection)",
    y = "Inferred Integration Time (years after infection)"
  )+ 

  facet_grid(analysis~gene, scales = "fixed") + geom_abline() + coord_fixed(ratio = 1) + 
  scale_x_continuous(breaks = c(0, 5, 10))+  theme(panel.grid.minor = element_blank())+theme(panel.grid.major = element_blank())+
  theme(axis.text.x = element_text(angle = 45,  hjust=1)) 
p

pdf("~/latency_manuscript/figures/fixedTreeAllGenes.pdf", width = 5, height = 10)
p
dev.off()

subData <- data[which(data$gene == "C1V2"), ]
p_sub <- ggplot(data, aes(trueDate, nodeDate)) + geom_point(cex = .1) + theme_bw() +
  labs(
    x = "True Integration Time (years after infection)",
    y = "Inferred Integration Time (years after infection)"
  )+
  facet_grid(.~analysis, scales = "fixed") + geom_abline() + coord_fixed(ratio = 1) + 
  scale_x_continuous(breaks = c(0, 5, 10)) +  theme(panel.grid.minor = element_blank())+theme(panel.grid.major = element_blank())+
  theme(axis.text.x = element_text(angle = 45,  hjust=1))
p_sub

pdf("~/latency_manuscript/figures/fixedTree.pdf", width = 4, height = 3.5)
p_sub
dev.off()
