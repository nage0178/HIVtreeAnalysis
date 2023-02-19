library(ggplot2)
library(viridis)
library(cowplot)
C1V2 <- read.csv("~/HIVtreeAnalysis/analysis/plotsSS/C1V2_LS")
nef <- read.csv("~/HIVtreeAnalysis/analysis/plotsSS/nef_LS")
p17 <- read.csv("~/HIVtreeAnalysis/analysis/plotsSS/p17_LS")
tat <- read.csv("~/HIVtreeAnalysis/analysis/plotsSS/tat_LS")

C1V2_LR <- read.csv("~/HIVtreeAnalysis/analysis/plotsSS/C1V2_LR")
nef_LR <- read.csv("~/HIVtreeAnalysis/analysis/plotsSS/nef_LR")
p17_LR <- read.csv("~/HIVtreeAnalysis/analysis/plotsSS/p17_LR")
tat_LR <- read.csv("~/HIVtreeAnalysis/analysis/plotsSS/tat_LR")

C1V2_ML <- read.csv("~/HIVtreeAnalysis/analysis/plotsSS/C1V2_ML")
nef_ML <- read.csv("~/HIVtreeAnalysis/analysis/plotsSS/nef_ML")
p17_ML <- read.csv("~/HIVtreeAnalysis/analysis/plotsSS/p17_ML")
tat_ML <- read.csv("~/HIVtreeAnalysis/analysis/plotsSS/tat_ML")

p17_Bayes <- read.csv("~/HIVtreeAnalysis/analysis/plotsSS/p17_Bayes")
p17BayesSS10 <- read.csv("~/HIVtreeAnalysis/analysis/plots/p17_Bayes")
p17BayesSS10 <-p17BayesSS10[which(p17BayesSS10$sub == 1), ]
p17BayesSS10 <- cbind(p17BayesSS10[, 1:3], rep(10, dim(p17BayesSS10)[1]), p17BayesSS10[, 4:12])
colnames(p17BayesSS10)[4] <- "sampleSize"

LSD <- rbind(C1V2, nef, p17, tat)
gene <- c(rep("C1V2", dim(C1V2)[1]), 
          rep("nef", dim(nef)[1]),
          rep("p17", dim(p17)[1]),
          rep("tat", dim(tat)[1]))
LSD <- cbind(LSD, as.factor(gene))
colnames(LSD)[length(colnames(LSD))] <- "gene"

LR <- rbind(C1V2_LR, nef_LR, p17_LR, tat_LR)
gene <- c(rep("C1V2", dim(C1V2_LR)[1]), 
          rep("nef", dim(nef_LR)[1]),
          rep("p17", dim(p17_LR)[1]),
          rep("tat", dim(tat_LR)[1]))
LR <- cbind(LR, as.factor(gene))
colnames(LR)[length(colnames(LR))] <- "gene"

ML <- rbind(C1V2_ML, nef_ML, p17_ML, tat_ML)
ML <- cbind(ML[ ,1:(dim(ML)[2]-1)], NA, NA, ML[dim(ML)[2]])
colnames(ML)[(length(colnames(ML))-2) : (length(colnames(ML))-1)] <- c("coverageProb", "CISize")
gene <- c(rep("C1V2", dim(C1V2_ML)[1]), 
          rep("nef", dim(nef_ML)[1]),
          rep("p17", dim(p17_ML)[1]),
          rep("tat", dim(tat_ML)[1]))
ML <- cbind(ML, as.factor(gene))
colnames(ML)[length(colnames(ML))] <- "gene"

Bayes <- rbind(p17_Bayes, p17BayesSS10)
gene <- rep("p17", dim(Bayes)[1])
Bayes <- cbind(Bayes, as.factor(gene))
colnames(Bayes)[length(colnames(Bayes))] <- "gene"

combResult <- as.data.frame(rbind(LSD, LR, ML, Bayes))
combResult$sampleSize <- as.factor(combResult$sampleSize)

analysisType <- c(rep("LS", dim(LSD)[1]),
                  rep("LR", dim(LR)[1]),
                  rep("ML", dim(ML)[1]), 
                  rep("Bayes", dim(Bayes)[1]))
combResult <- cbind(combResult, as.factor(analysisType))
colnames(combResult)[length(colnames(combResult))] <- "analysis"
combResult$bias <- as.numeric(combResult$bias)


bias_p <- ggplot(combResult, aes(factor(analysis), bias, fill = sampleSize)) + geom_violin()   +theme_half_open()  +labs(
  x = "Analysis",
  y = "Bias (years)"
)+ facet_grid(cols = vars(gene), scales = "free", space = "free")+ theme(#panel.spacing = unit(.05, "lines"),
  panel.border = element_rect(color = "black", fill = NA), 
  strip.background = element_rect(color = "black"), 
  plot.title = element_text(face = "plain",  size = 14)) + scale_color_viridis(discrete = TRUE, option = "H") +
  scale_fill_viridis(discrete = TRUE, name="sample\nsize")   

pdf("~/latency_manuscript/figures/sampleSizeBias.pdf", width = 7, height =5)
bias_p
dev.off()

mse_p <- ggplot(combResult, aes(factor(analysis), MSE, fill = sampleSize)) + geom_violin()   +theme_half_open()  +labs(
  x = "Analysis",
  y = "MSE"
) + facet_grid(cols = vars(gene), scales = "free", space = "free") + theme(#panel.spacing = unit(.05, "lines"),
  panel.border = element_rect(color = "black", fill = NA),
  strip.background = element_rect(color = "black"),
  plot.title = element_text(face = "plain",  size = 14)) + scale_color_viridis(discrete = TRUE, option = "H") +
  scale_fill_viridis(discrete = TRUE, name="sample\nsize")   

pdf("~/latency_manuscript/figures/sampleSizeMSE.pdf", width = 7, height =5)
mse_p
dev.off()

corr_p <- ggplot(combResult, aes(factor(analysis), correlation, fill = sampleSize)) + geom_violin()   +theme_half_open()  +labs(
  x = "Analysis",
  y = "Correlation"
) + facet_grid(cols = vars(gene), scales = "free", space = "free") + theme(#panel.spacing = unit(.05, "lines"),
  panel.border = element_rect(color = "black", fill = NA),
  strip.background = element_rect(color = "black"),
  plot.title = element_text(face = "plain",  size = 14)) + scale_color_viridis(discrete = TRUE, option = "H") +
  scale_fill_viridis(discrete = TRUE, name="sample\nsize")   

corr_p

# Subset data
resultSub <- combResult[c(which(combResult$analysis == "LS"), which(combResult$analysis == "LR"), which(combResult$analysis == "Bayes")), ]
CISize_p <- ggplot(resultSub, aes(factor(analysis),  CISize, fill = sampleSize)) + geom_violin() + theme_half_open() + labs(
  x = "Analysis",
  y = "Size of 95% Confidence Interval (years)"
) +  facet_grid(cols = vars(gene), scales = "free", space = "free")+ theme(#panel.spacing = unit(.05, "lines"),
  panel.border = element_rect(color = "black", fill = NA),
  strip.background = element_rect(color = "black"),
  plot.title = element_text(face = "plain",  size = 14)) + scale_color_viridis(discrete = TRUE, option = "H") + #+ geom_hline(yintercept = 1.28165)+
  scale_fill_viridis(discrete = TRUE, name="sample\nsize")   

pdf("~/latency_manuscript/figures/sampleSizeCISize.pdf", width = 7, height =5)
CISize_p
dev.off()

coverageP_p <- ggplot(resultSub, aes(factor(analysis),  coverageProb, fill = sampleSize)) + geom_violin() + theme_half_open() + labs(
  x = "Analysis",
  y = "Coverage Probability"
) + facet_grid(cols = vars(gene), scales = "free", space = "free")+ theme(#panel.spacing = unit(.05, "lines"),
  panel.border = element_rect(color = "black", fill = NA),
  strip.background = element_rect(color = "black"),
  plot.title = element_text(face = "plain",  size = 14)) + scale_color_viridis(discrete = TRUE, option = "H") +
  scale_fill_viridis(discrete = TRUE, name="sample\nsize")   

pdf("~/latency_manuscript/figures/sampleSizeCoverageP.pdf", width = 7, height =5)
coverageP_p
dev.off()
