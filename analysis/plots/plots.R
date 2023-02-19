library(ggplot2)
library(viridis)
library(cowplot)
library(ggpubr)
library(scales)

C1V2 <- read.csv("~/HIVtreeAnalysis/analysis/plots/C1V2_LS")
nef <- read.csv("~/HIVtreeAnalysis/analysis/plots/nef_LS")
p17 <- read.csv("~/HIVtreeAnalysis/analysis/plots/p17_LS")
tat <- read.csv("~/HIVtreeAnalysis/analysis/plots/tat_LS")

C1V2ML <- read.csv("~/HIVtreeAnalysis/analysis/plots/C1V2_ML")
nefML <- read.csv("~/HIVtreeAnalysis/analysis/plots/nef_ML")
p17ML <- read.csv("~/HIVtreeAnalysis/analysis/plots/p17_ML")
tatML <- read.csv("~/HIVtreeAnalysis/analysis/plots/tat_ML")

C1V2LR<- read.csv("~/HIVtreeAnalysis/analysis/plots/C1V2_LR")
nefLR <- read.csv("~/HIVtreeAnalysis/analysis/plots/nef_LR")
p17LR <- read.csv("~/HIVtreeAnalysis/analysis/plots/p17_LR")
tatLR <- read.csv("~/HIVtreeAnalysis/analysis/plots/tat_LR")

C1V2Bayes<- read.csv("~/HIVtreeAnalysis/analysis/plots/C1V2_Bayes")
nefBayes <- read.csv("~/HIVtreeAnalysis/analysis/plots/nef_Bayes")
p17Bayes <- read.csv("~/HIVtreeAnalysis/analysis/plots/p17_Bayes")
tatBayes <- read.csv("~/HIVtreeAnalysis/analysis/plots/tat_Bayes")
combineBayes <- read.csv("~/HIVtreeAnalysis/analysis/plots/combine_Bayes")
combineBayes2 <- read.csv("~/HIVtreeAnalysis/analysis/plots/combine_Bayes2")

LS <- rbind(C1V2, nef, p17, tat)
gene <- c(rep("C1V2", dim(C1V2)[1]), 
          rep("nef", dim(nef)[1]),
          rep("p17", dim(p17)[1]),
          rep("tat", dim(tat)[1]))
LS <- cbind(LS, as.factor(gene))
colnames(LS)[length(colnames(LS))] <- "gene"

ML <- rbind(C1V2ML, nefML, p17ML, tatML)
ML <- cbind(ML[ ,1:(dim(ML)[2]-1)], NA, NA, ML[dim(ML)[2]])
colnames(ML)[(length(colnames(ML))-2) : (length(colnames(ML))-1)] <- c("coverageProb", "CISize")
geneML <- c(rep("C1V2", dim(C1V2ML)[1]), 
          rep("nef", dim(nefML)[1]),
          rep("p17", dim(p17ML)[1]),
          rep("tat", dim(tatML)[1]))
ML <- cbind(ML, as.factor(geneML))
colnames(ML)[length(colnames(ML))] <- "gene"

LR <- rbind(C1V2LR, nefLR, p17LR, tatLR)
geneLR <- c(rep("C1V2", dim(C1V2LR)[1]), 
            rep("nef", dim(nefLR)[1]),
            rep("p17", dim(p17LR)[1]),
            rep("tat", dim(tatLR)[1]))
LR <- cbind(LR, as.factor(geneLR))
colnames(LR)[length(colnames(LR))] <- "gene"

Bayes <- rbind(combineBayes, combineBayes2, C1V2Bayes, nefBayes, p17Bayes, tatBayes)

geneBayes <- c(rep("all", dim(combineBayes)[1]),
               rep("p17/\ntat", dim(combineBayes2)[1]),
              rep( "C1V2", dim(C1V2Bayes)[1]), 
              rep("nef", dim(nefBayes)[1]),
              rep("p17", dim(p17Bayes)[1]),
              rep("tat", dim(tatBayes)[1]))
Bayes <- cbind(Bayes, as.factor(geneBayes))
colnames(Bayes)[length(colnames(Bayes))] <- "gene"

combResult <- rbind(Bayes,LS, ML, LR)
analysisType <- c(rep("Bayes", dim(Bayes)[1]), 
                  rep("LS", dim(LS)[1]),
                  rep("ML", dim(ML)[1]), 
                  rep("LR", dim(LR)[1])
)
combResult <- cbind(combResult, as.factor(analysisType))
colnames(combResult)[length(colnames(combResult))] <- "analysis"

bias_p_leg <- ggplot(combResult, aes(factor(analysis), bias, fill = analysis)) + geom_violin() + facet_grid(cols = vars(gene))  +theme_half_open()  +labs(
  x = "Analysis",
  y = "Bias (years)\n"
) + theme(legend.position = 'top', legend.justification='center',
          legend.direction='horizontal', #panel.spacing = unit(.05, "lines"),
  panel.border = element_rect(color = "black", fill = NA), 
  strip.background = element_rect(color = "black"), 
  plot.title = element_text(face = "plain",  size = 14)) + scale_color_viridis(discrete = TRUE, option = "H") +
  scale_fill_viridis(discrete = TRUE)

bias_p <- ggplot(combResult, aes(factor(analysis), bias, fill = analysis)) + geom_violin() + facet_grid(~factor(gene,levels =c('all','p17/\ntat','C1V2','nef','p17', 'tat')), scales = "free", space = "free")  +theme_half_open()  +labs(
  #x = "Analysis",
  y = "Bias (years)\n"
) + theme(legend.position = "none", axis.title.x=element_blank(),
          axis.text.x=element_blank(),
          axis.ticks.x=element_blank(),
  panel.border = element_rect(color = "black", fill = NA), 
  strip.background = element_rect(color = "black"), 
  plot.title = element_text(face = "plain",  size = 14)) + scale_color_viridis(discrete = TRUE, option = "H") +
  scale_fill_viridis(discrete = TRUE)   
bias_p


legend1 <- cowplot::get_legend(bias_p_leg)
leg1 <- as_ggplot(legend1)

rmse_p <- ggplot(combResult, aes(factor(analysis), RMSE, fill = analysis)) + geom_violin() + facet_grid(~factor(gene,levels =c('all','p17/\ntat','C1V2','nef','p17', 'tat')), scales = "free", space = "free") + theme_half_open() + labs(
 # x = "Analysis",
  y = "RMSE (years)\n"
) + theme(legend.position = "none", axis.title.x=element_blank(),
          axis.text.x=element_blank(),
          axis.ticks.x=element_blank(),
  panel.border = element_rect(color = "black", fill = NA), 
  strip.background = element_rect(color = "black"), 
  plot.title = element_text(face = "plain",  size = 14)) + scale_color_viridis(discrete = TRUE, option = "H") +
  scale_fill_viridis(discrete = TRUE)   

rmse_p

mse_p <- ggplot(combResult, aes(factor(analysis), MSE, fill = analysis)) + geom_violin() + facet_grid(~factor(gene,levels =c('all','p17/\ntat','C1V2','nef','p17', 'tat')), scales = "free", space = "free") + theme_half_open() + labs(
  # x = "Analysis",
  y = "MSE (years squared)\n"
)  + 
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        panel.border = element_rect(color = "black", fill = NA), 
        strip.background = element_rect(color = "black"), 
        plot.title = element_text(face = "plain",  size = 14))+ scale_color_viridis(discrete = TRUE, option = "H") +
  scale_fill_viridis(discrete = TRUE)   
mse_p

pdf("~/latency_manuscript/figures/MSE.pdf", width = 7.5, height = 5)
mse_p
dev.off()

figure <- ggarrange(bias_p, rmse_p, leg1, widths = c(1.5,1.5, .5),
                    ncol = 3, nrow = 1)
figure


corr_p <- ggplot(combResult, aes(factor(analysis), correlation, fill = analysis)) + geom_violin() + facet_grid(cols = vars(gene)) + theme_half_open() + labs(
  x = "Analysis",
  y = "Correlation"
) + theme(axis.text.x = element_text(angle = 90), 
  panel.border = element_rect(color = "black", fill = NA), 
  strip.background = element_rect(color = "black"), 
  plot.title = element_text(face = "plain",  size = 14)) + scale_color_viridis(discrete = TRUE, option = "H") +
  scale_fill_viridis(discrete = TRUE)   + labs(title  ="Long                                                                                   Short \nFast Evolving                                                         Slow Evolving ") # + scale_fill_brewer(palette = "RdYlBu") 

corr_p

# Subset data
resultSub <- combResult[which(combResult$analysis != "ML"), ]

# Edit/check when have final results
colors <-viridis_pal()(4) 
colGraph <- colors[1:3]

CISize_p_leg <- ggplot(resultSub, aes(factor(analysis),  CISize, fill = analysis)) + geom_violin() + facet_grid(cols = vars(gene)) + theme_half_open() + labs(
  x = "Analysis",
  y = "Size of 95% \nConfidence Interval (years)"
) +  scale_fill_manual(values = colGraph)+
  theme(axis.text.x = element_text(angle = 90),
        panel.border = element_rect(color = "black", fill = NA), 
        strip.background = element_rect(color = "black"), 
        plot.title = element_text(face = "plain",  size = 14)) 
legend2 <- cowplot::get_legend(CISize_p_leg)
leg2 <- as_ggplot(legend2)


CISize_p <- ggplot(resultSub, aes(factor(analysis),  CISize, fill = analysis)) + geom_violin() + facet_grid(~factor(gene,levels =c('all','p17/\ntat','C1V2','nef','p17', 'tat')), scales = "free", space = "free") + theme_half_open() + labs(
  x = "Analysis",
  y = "Size of 95%\nConfidence Interval (years)"
) +  scale_fill_manual(values = colGraph)+
  theme(legend.position = "none", axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
  panel.border = element_rect(color = "black", fill = NA), 
  strip.background = element_rect(color = "black"), 
  plot.title = element_text(face = "plain",  size = 14)) 
CISize_p


coverageP_p <- ggplot(resultSub, aes(factor(analysis),  coverageProb, fill = analysis)) + geom_violin() + facet_grid(~factor(gene,levels =c('all','p17/\ntat','C1V2','nef','p17', 'tat')), scales = "free", space = "free") + theme_half_open() + labs(
  x = "Analysis",
  y = "Probability the true time \nis in the confidence interval"
) + scale_fill_manual(values = colGraph)+
  theme(legend.position = "none", axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
  panel.border = element_rect(color = "black", fill = NA), 
  strip.background = element_rect(color = "black"), 
  plot.title = element_text(face = "plain",  size = 14))

coverageP_p

figure <- ggarrange(CISize_p, coverageP_p,leg2, 
                    widths = c(1.5,1.5, .5),
                    ncol = 3, nrow = 1)
figure
# saved as 5 by 10

coverageP_p_leg <- ggplot(resultSub, aes(factor(analysis),  coverageProb, fill = analysis)) + geom_violin() + facet_grid(~factor(gene,levels =c('all','p17/\ntat','C1V2','nef','p17', 'tat')), scales = "free", space = "free") + theme_half_open() + labs(
  x = "Analysis",
  y = "Probability the true time is in the confidence interval"
) +scale_fill_manual(values = colGraph)+
  theme(axis.text.x = element_text(angle = 90),
          panel.border = element_rect(color = "black", fill = NA), 
          strip.background = element_rect(color = "black"), 
          plot.title = element_text(face = "plain",  size = 14)) 
coverageP_p_leg

pdf("~/latency_manuscript/figures/coverage.pdf", width = 7, height = 5)
coverageP_p_leg
dev.off()

figure <- ggarrange(rmse_p, bias_p, CISize_p, coverageP_p, leg1,
                    labels = c("a", "b", "c", "d", ""),
                    heights = c( 3, 3, 3, 3, .5),
                    ncol = 1, nrow = 5)
pdf("~/latency_manuscript/figures/summary.pdf", width = 7, height = 15)
figure
dev.off()
# save pdf 5 x 7
