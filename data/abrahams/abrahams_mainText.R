library(ggplot2)
library(tidyverse)
library(scales)

# Reads in the data
est <- read.csv("~/HIVtreeAnalysis/data/abrahams/resultsAllMethods/combine.csv")
combine <- read.csv("~/HIVtreeAnalysis/data/abrahams/combineGeneFiles/all_combine.csv")
est_sub <- est[intersect(which(est$numDraw == 10), which(est$filter == .75)),]
est_sub$QVOA <-unlist(strsplit(est_sub$sequence, "_QVOA"))[seq(1,dim(est_sub)[1] *2, by = 2)]
combine$QVOA <- combine$seq


splitNames <- (strsplit(est_sub$QVOA, "_"))
for (i in 1:length(splitNames)) {
  name <- splitNames[[i]]
  est_sub$QVOA[i] <- paste(name[4:length(name)], collapse = "_")
}

all <- rbind(est_sub, combine) 

# Which QVOA were combined
all[c(which(all$QVOA == "W25"), which(all$QVOA == "B_W15")), 9] <- "W25-B_W15"
all[c(which(all$QVOA == "W6"), which(all$QVOA == "W11")), 9] <- "W6-W11"


# Gets the sample date from the sequence name
all <- cbind(all, -1)
for (i in 1:(dim(all)[1]-dim(combine)[1])) {
  name <- strsplit(as.character(all$sequence[i]), "_")[[1]]
  all[i, dim(all)[2]] <- as.numeric(name[length(name)])

}
colnames(all)[dim(all)[2]] <- "SampleTime"
all[intersect(which(all$SampleTime == "-1"), which(all$patient == "217")), 10] <- 3450
all[intersect(which(all$SampleTime == "-1"), which(all$patient == "257")), 10] <- 3921


# Converts days to years
all[, c(6:8, 10)] <- all[, c(6:8, 10)]/365

# Changes sample date to factor
all[,10] <- as.factor(round(all[,10], digits = 1))

# Finds the patient number and adds the time of treatment start
all <- cbind(all, -1)
colnames(all)[dim(all)[2]] <- "ptNum"
all <- cbind(all, -1)
colnames(all)[dim(all)[2]] <- "ART_start"

for (i in 1:dim(all)[1]) {
  if (all$patient[i] == "217_ENV2" || all$patient[i] == "217_ENV3" || all$patient[i] == "217_ENV4" || all$patient[i] == "217") {
    all$ptNum[i] <- 217
    all$ART_start[i] <- 2521/365
    
  } else if (all$patient[i] == "257_ENV2" || all$patient[i] == "257_ENV3" || all$patient[i] == "257_ENV4" || all$patient[i] == "257_GAG1" || all$patient[i] == "257_NEF1" || all$patient[i] == "257") {
    all$ptNum[i] <- 257
    all$ART_start[i] <- 1741/365
    
  } else {
    message("Name doesn't match")
  }

}

all[which(all$patient == "217_ENV2"), 1] <- "C1C2"
all[which(all$patient == "217_ENV3"), 1] <- "C2C3"
all[which(all$patient == "217_ENV4"), 1] <- "C4C5"
all[which(all$patient == "217"), 1] <- "combined"


all[which(all$patient == "257_ENV2"), 1] <- "C1C2"
all[which(all$patient == "257_ENV3"), 1] <- "C2C3"
all[which(all$patient == "257_ENV4"), 1] <- "C4C5"
all[which(all$patient == "257_GAG1"), 1] <- "p17"
all[which(all$patient == "257_NEF1"), 1] <- "nef"
all[which(all$patient == "257"), 1] <- "combined"


# Changes the sample time to be numeric
all$SampleTime <- as.numeric(as.character(all$SampleTime))


all$ptNum<- as.factor(all$ptNum)

all$QVOA <- as.factor(all$QVOA)
for (pt in levels(all$ptNum)){
  est_pt <- all[all[, "ptNum"] == pt, ]
  est_pt <- est_pt[c(which(est_pt[, "method"] == "combine"), which(est_pt[, "method"] == "Bayes")), ]
  est_pt_df <- as.data.frame(est_pt)
  if (pt == "257"){
    est_pt_df$patient <- factor(est_pt_df$patient, levels = c("C1C2", "C2C3","C4C5", "p17", "nef", "combined"))
    
  }
  pdf(paste("~/latency_manuscript/figures/pt",pt, ".pdf", sep =""), height = 3.8, width = 5.5)
  
  print(est_pt_df %>% 
          ggplot(mapping = aes(x = QVOA, y = nodeDate, ymin = lowCI, ymax = highCI, 
                               color= patient)) + 
          facet_grid(~ patient) +
          geom_point() + 
          geom_hline(yintercept =  0, linetype="dashed") + 
          geom_hline(yintercept =  est_pt_df$ART_start[1])+
          geom_hline(yintercept =  est_pt_df$SampleTime[1], linetype="dotted")+
          coord_flip() + 
          ylab("inferred integration time (years)") +
          xlab("sequence") +
          ylim(min(c(est_pt$nodeDate, est_pt$lowCI, 0), na.rm = TRUE), max(c(est_pt$nodeDate, est_pt$highCI,  est_pt_df$SampleTime[1]), na.rm = TRUE)) +
          geom_errorbar()+
          theme_bw() +
          theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                             axis.text.y = element_blank(), # Each row is its own QVOA
                             axis.ticks = element_blank(), 
                             legend.position = "none"))
  dev.off()
}

