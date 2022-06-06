library(ggplot2)
library(tidyverse)
library(scales)
library(ggpubr)

# Reads in data
est <- read.csv("~/HIV_latency_general/data/jones/resultsAllMethods/combine.csv")

# Finds the sample time from the sequence names 
est <- cbind(est, as.numeric(unlist(strsplit(as.character(est$sequence), "_"))[seq(2, dim(est)[1]*2, 2)]))
colnames(est)[dim(est)[2]] <- "SampleTime"

# Converts days to years
est[, 5:8] <- est[, 5:8]/365

# Relative diagnosis and treatment times of each patient in years
p1_diagnose <- 0
p2_diagnose <- -1.83
  
p1_treat <- 10
p2_treat <- 9.83

# Shifts the date axis so that zero is the time of diagnosis for patient 2 
est[est$patient == "p2", 5:8] <- est[est$patient == "p2", 5:8] + abs(p2_diagnose)
p2_treat <- p2_treat + abs(p2_diagnose)
p2_diagnose <- p2_diagnose + abs(p2_diagnose)

# Changes sample time to a factor
est[,8] <- as.factor(round(est[,8], digits = 1))

# Split data set into each patient 
est_p1 <- est[est[, "patient"] == "p1", ]
est_p2 <- est[est[, "patient"] == "p2", ]

# USE THIS PLOT FOR MAIN TEXT WITH MCMCTREE METHOD
est_p1_LSD <- as.data.frame(est_p1[est_p1[, "method"] == "Bayes", ])
est_p1_LSD_HKY <- as.data.frame(est_p1_LSD[est_p1_LSD[, "model"] == "HKY", ])
attach(est_p1_LSD_HKY)
newdata <- est_p1_LSD_HKY[order( SampleTime,nodeDate), ]
est_p1_LSD_HKY <- newdata
detach(est_p1_LSD_HKY)
p1_graph <- est_p1_LSD_HKY %>% 
  arrange(nodeDate) %>%
  mutate(sequence = factor(sequence, levels=est_p1_LSD_HKY$sequence)) %>%
  ggplot(mapping = aes(x = sequence, y = nodeDate, ymin = lowCI, 
                       ymax = highCI, color= SampleTime, order = c(1:dim(est_p1_LSD_HKY)[1]))) +
  geom_point() + ylab("inferred integration time (years)")+labs(color = "Sample\n  Time ")+
   coord_flip() +  geom_hline(yintercept =  p1_diagnose) +  geom_hline(yintercept =  p1_treat)+
  geom_hline(yintercept =  unique(as.numeric(as.character(est_p1_LSD_HKY$SampleTime))), color = hue_pal()(4), linetype = "dashed" )+
  theme_classic() + geom_errorbar() +theme(
    axis.text.y = element_blank(),
    axis.ticks = element_blank())

# USE THIS PLOT FOR MAIN TEXT WITH MCMCTREE METHOD

est_p2_LSD <- as.data.frame(est_p2[est_p2[, "method"] == "Bayes", ])
est_p2_LSD_HKY <- as.data.frame(est_p2_LSD[est_p2_LSD[, "model"] == "HKY", ])

attach(est_p2_LSD_HKY)
newdata <- est_p2_LSD_HKY[order( SampleTime,nodeDate), ]
est_p2_LSD_HKY <- newdata
detach(est_p2_LSD_HKY)
p2_graph <- est_p2_LSD_HKY %>% 
  arrange(nodeDate) %>%
  mutate(sequence = factor(sequence, levels=est_p2_LSD_HKY$sequence)) %>%
  ggplot(mapping = aes(x = sequence, y = nodeDate, ymin = lowCI, 
                       ymax = highCI, color= SampleTime, order = c(1:dim(est_p2_LSD_HKY)[1]))) +
  geom_point() + ylab("inferred integration time (years)")+labs(color = "Sample\n  Time ")+
  coord_flip() +  geom_hline(yintercept =  p2_diagnose) +  geom_hline(yintercept =  p2_treat)+
  geom_hline(yintercept =  unique(as.numeric(as.character(est_p2_LSD_HKY$SampleTime))), color = hue_pal()(2), linetype = "dashed" )+
  theme_classic() + geom_errorbar() +theme(
    axis.text.y = element_blank(),
    axis.ticks = element_blank())

figure <- ggarrange(p1_graph, p2_graph,
                    labels = c("a", "b"),
                    ncol = 2, nrow = 1)
pdf(file = "~/latency_manuscript/figures/jones_data_fig.pdf", width = 5.5, height = 4)
figure
dev.off()

#### Other methods 

# LSD 1
est_p1_LSD <- as.data.frame(est_p1[est_p1[, "method"] == "LS", ])
est_p1_LSD_HKY <- as.data.frame(est_p1_LSD[est_p1_LSD[, "model"] == "HKY", ])
attach(est_p1_LSD_HKY)
newdata <- est_p1_LSD_HKY[order( SampleTime,nodeDate), ]
est_p1_LSD_HKY <- newdata
detach(est_p1_LSD_HKY)
p1_graph_LSD_leg <- est_p1_LSD_HKY %>% 
  arrange(nodeDate) %>%
  mutate(sequence = factor(sequence, levels=est_p1_LSD_HKY$sequence)) %>%
  ggplot(mapping = aes(x = sequence, y = nodeDate, ymin = lowCI, 
                       ymax = highCI, color= SampleTime, order = c(1:dim(est_p1_LSD_HKY)[1]))) +
  geom_point() + ylab("")+labs(color = "Sample Time ")+
  coord_flip() +  geom_hline(yintercept =  p1_diagnose) +  geom_hline(yintercept =  p1_treat)+
  theme_classic() + geom_errorbar() +theme(
    axis.text.y = element_blank(),
    axis.ticks = element_blank())

legend1 <- cowplot::get_legend(p1_graph_LSD_leg)
leg1 <- as_ggplot(legend1)

p1_graph_LSD <- est_p1_LSD_HKY %>% 
  arrange(nodeDate) %>%
  mutate(sequence = factor(sequence, levels=est_p1_LSD_HKY$sequence)) %>%
  ggplot(mapping = aes(x = sequence, y = nodeDate, ymin = lowCI, 
                       ymax = highCI, color= SampleTime, order = c(1:dim(est_p1_LSD_HKY)[1]))) +
  geom_point() + ylab("")+labs(color = "Sample Time ")+ #xlab("Patient 1\n sequence")+
  ggtitle("LS") + ylim(c(min(est_p1$lowCI, na.rm = TRUE), max(as.numeric(as.character(est_p1$SampleTime)))))+
  coord_flip() +  geom_hline(yintercept =  p1_diagnose) +  geom_hline(yintercept =  p1_treat)+
  geom_hline(yintercept =  unique(as.numeric(as.character(est_p1_LSD_HKY$SampleTime))), color = hue_pal()(4), linetype = "dashed" )+
  theme_classic() + theme(plot.title = element_text(hjust = 0.5))+geom_errorbar() +theme(legend.position = "none", 
    axis.text.y = element_blank(),
    axis.ticks = element_blank())

# LSD 2

est_p2_LSD <- as.data.frame(est_p2[est_p2[, "method"] == "LS", ])
est_p2_LSD_HKY <- as.data.frame(est_p2_LSD[est_p2_LSD[, "model"] == "HKY", ])
attach(est_p2_LSD_HKY)
newdata <- est_p2_LSD_HKY[order( SampleTime,nodeDate), ]
est_p2_LSD_HKY <- newdata
detach(est_p2_LSD_HKY)
p2_graph_LSD_leg <- est_p2_LSD_HKY %>% 
  arrange(nodeDate) %>%
  mutate(sequence = factor(sequence, levels=est_p2_LSD_HKY$sequence)) %>%
  ggplot(mapping = aes(x = sequence, y = nodeDate, ymin = lowCI, 
                       ymax = highCI, color= SampleTime, order = c(1:dim(est_p2_LSD_HKY)[1]))) +
  geom_point() + ylab("")+labs(color = "Sample Time ")+
  coord_flip() +  geom_hline(yintercept =  p2_diagnose) +  geom_hline(yintercept =  p2_treat)+
  theme_classic() + geom_errorbar() +theme(
    axis.text.y = element_blank(),
    axis.ticks = element_blank())

legend2 <- cowplot::get_legend(p2_graph_LSD_leg)
leg2 <- as_ggplot(legend2)

p2_graph_LSD <- est_p2_LSD_HKY %>% 
  arrange(nodeDate) %>%
  mutate(sequence = factor(sequence, levels=est_p2_LSD_HKY$sequence)) %>%
  ggplot(mapping = aes(x = sequence, y = nodeDate, ymin = lowCI, 
                       ymax = highCI, color= SampleTime, order = c(1:dim(est_p2_LSD_HKY)[1]))) +
  geom_point() + ylab("")+labs(color = "Sample Time ")+ ylim(c(min(est_p2$lowCI, na.rm = TRUE),max(as.numeric(as.character(est_p2$SampleTime)))))+
  coord_flip() +  geom_hline(yintercept =  p2_diagnose) +  geom_hline(yintercept =  p2_treat)+
  geom_hline(yintercept =  unique(as.numeric(as.character(est_p2_LSD_HKY$SampleTime))), color = hue_pal()(2), linetype = "dashed" )+
  theme_classic() + geom_errorbar() +theme(legend.position = "none", 
                                           axis.text.y = element_blank(),
                                           axis.ticks = element_blank())


# ND 1
est_p1_ND <- as.data.frame(est_p1[est_p1[, "method"] == "ML", ])
est_p1_ND_HKY <- as.data.frame(est_p1_ND[est_p1_ND[, "model"] == "HKY", ])
attach(est_p1_ND_HKY)
ND1_order <- rep(0, dim(est_p1_LSD_HKY)[1])
for (i in 1: dim(est_p1_LSD_HKY)[1]){
  ND1_order[i] <- which(est_p1_ND_HKY$sequence == est_p1_LSD_HKY$sequence[i])
}
newdata <- est_p1_ND_HKY[ND1_order, ]
est_p1_ND_HKY <- newdata
detach(est_p1_ND_HKY)
p1_graph_ND <- est_p1_ND_HKY %>% 
  arrange(nodeDate) %>%
  mutate(sequence = factor(sequence, levels=est_p1_ND_HKY$sequence)) %>%
  ggplot(mapping = aes(x = sequence, y = nodeDate, ymin = lowCI, 
                       ymax = highCI, color= SampleTime, order = c(1:dim(est_p1_ND_HKY)[1]))) +
  geom_point() + ylab("")+labs(color = "Sample Time ")+xlab("")+
  ggtitle("ML") + ylim(c(min(est_p1$lowCI, na.rm = TRUE),  max(as.numeric(as.character(est_p1$SampleTime)))))+
  coord_flip() +  geom_hline(yintercept =  p1_diagnose) +  geom_hline(yintercept =  p1_treat)+
  geom_hline(yintercept =  unique(as.numeric(as.character(est_p1_LSD_HKY$SampleTime))), color = hue_pal()(4), linetype = "dashed" )+
  theme_classic() + theme(plot.title = element_text(hjust = 0.5))+geom_errorbar() +theme(legend.position = "none", 
    axis.text.y = element_blank(),
    axis.ticks = element_blank())

# ND 2

est_p2_ND <- as.data.frame(est_p2[est_p2[, "method"] == "ML", ])
est_p2_ND_HKY <- as.data.frame(est_p2_ND[est_p2_ND[, "model"] == "HKY", ])
attach(est_p2_ND_HKY)
ND2_order <- rep(0, dim(est_p2_LSD_HKY)[1])
for (i in 2: dim(est_p2_LSD_HKY)[1]){
  ND2_order[i] <- which(est_p2_ND_HKY$sequence == est_p2_LSD_HKY$sequence[i])
}
newdata <- est_p2_ND_HKY[ND2_order, ]
est_p2_ND_HKY <- newdata
detach(est_p2_ND_HKY)
p2_graph_ND <- est_p2_ND_HKY %>% 
  arrange(nodeDate) %>%
  mutate(sequence = factor(sequence, levels=est_p2_ND_HKY$sequence)) %>%
  ggplot(mapping = aes(x = sequence, y = nodeDate, ymin = lowCI, 
                       ymax = highCI, color= SampleTime, order = c(1:dim(est_p2_ND_HKY)[1]))) +
  geom_point() + ylab("")+labs(color = "Sample Time ")+xlab("")+
  ylim(c(min(est_p2$lowCI, na.rm = TRUE), max(as.numeric(as.character(est_p2$SampleTime)))))+
  coord_flip() +  geom_hline(yintercept =  p2_diagnose) +  geom_hline(yintercept =  p2_treat)+
  geom_hline(yintercept =  unique(as.numeric(as.character(est_p2_LSD_HKY$SampleTime))), color = hue_pal()(2), linetype = "dashed" )+
  theme_classic() + geom_errorbar() +theme(legend.position = "none", 
    axis.text.y = element_blank(),
    axis.ticks = element_blank())

# JN 1
est_p1_JN <- as.data.frame(est_p1[est_p1[, "method"] == "LR", ])
est_p1_JN_HKY <- as.data.frame(est_p1_JN[est_p1_JN[, "model"] == "HKY", ])
attach(est_p1_JN_HKY)
JN1_order <- rep(0, dim(est_p1_LSD_HKY)[1])
for (i in 1: dim(est_p1_LSD_HKY)[1]){
  JN1_order[i] <- which(est_p1_JN_HKY$sequence == est_p1_LSD_HKY$sequence[i])
}
newdata <- est_p1_JN_HKY[JN1_order, ]
est_p1_JN_HKY <- newdata
detach(est_p1_JN_HKY)
p1_graph_JN <- est_p1_JN_HKY %>% 
  arrange(nodeDate) %>%
  mutate(sequence = factor(sequence, levels=est_p1_JN_HKY$sequence)) %>%
  ggplot(mapping = aes(x = sequence, y = nodeDate, ymin = lowCI, 
                       ymax = highCI, color= SampleTime, order = c(1:dim(est_p1_JN_HKY)[1]))) +
  geom_point() + ylab("")+labs(color = "Sample Time ")+xlab("")+
  ggtitle("LR") + ylim(c(min(est_p1$lowCI, na.rm = TRUE), max(as.numeric(as.character(est_p1$SampleTime)))))+
  coord_flip() +  geom_hline(yintercept =  p1_diagnose) +  geom_hline(yintercept =  p1_treat)+
  geom_hline(yintercept =  unique(as.numeric(as.character(est_p1_LSD_HKY$SampleTime))), color = hue_pal()(4), linetype = "dashed" )+
  theme_classic() + theme(plot.title = element_text(hjust = 0.5))+geom_errorbar() +theme(legend.position = "none", 
    axis.text.y = element_blank(),
    axis.ticks = element_blank())

# JN 2

est_p2_JN <- as.data.frame(est_p2[est_p2[, "method"] == "LR", ])
est_p2_JN_HKY <- as.data.frame(est_p2_JN[est_p2_JN[, "model"] == "HKY", ])
attach(est_p2_JN_HKY)
JN2_order <- rep(0, dim(est_p2_LSD_HKY)[1])
for (i in 2: dim(est_p2_LSD_HKY)[1]){
  JN2_order[i] <- which(est_p2_JN_HKY$sequence == est_p2_LSD_HKY$sequence[i])
}
newdata <- est_p2_JN_HKY[JN2_order, ]
est_p2_JN_HKY <- newdata
detach(est_p2_JN_HKY)
p2_graph_JN <- est_p2_JN_HKY %>% 
  arrange(nodeDate) %>%
  mutate(sequence = factor(sequence, levels=est_p2_JN_HKY$sequence)) %>%
  ggplot(mapping = aes(x = sequence, y = nodeDate, ymin = lowCI, 
                       ymax = highCI, color= SampleTime, order = c(1:dim(est_p2_JN_HKY)[1]))) +
  geom_point() + ylab("inferred integration time (years)")+labs(color = "Sample Time ")+xlab("")+
  ylim(c(min(est_p2$lowCI, na.rm = TRUE), max(as.numeric(as.character(est_p2$SampleTime)))))+
  coord_flip() +  geom_hline(yintercept =  p2_diagnose) +  geom_hline(yintercept =  p2_treat)+
  geom_hline(yintercept =  unique(as.numeric(as.character(est_p2_LSD_HKY$SampleTime))), color = hue_pal()(2), linetype = "dashed" )+
  theme_classic() + geom_errorbar() +theme(legend.position = "none",
    axis.text.y = element_blank(),
    axis.ticks = element_blank())

figure_sup <- ggarrange(p1_graph_LSD, p1_graph_JN, p1_graph_ND,leg1,
                    p2_graph_LSD, p2_graph_JN, p2_graph_ND,leg2,
                    labels = c("a", "b", "c", "", "d", "e", "f", ""),
                    ncol = 4, nrow = 2, widths= c(1, 1, 1, .5))

pdf(file = "~/latency_manuscript/figures/jones_allmethods.pdf", width = 8.5, height = 5)
figure_sup
dev.off()
