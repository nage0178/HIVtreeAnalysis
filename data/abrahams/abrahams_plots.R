library(ggplot2)
library(tidyverse)
library(scales)

# Reads in the data
est <- read.csv("~/HIVtreeAnalysis/data/abrahams/resultsAllMethods/combine.csv")

# Gets the sample date from the sequence name
est <- cbind(est, -1)
for (i in 1:dim(est)[1]) {
  name <- strsplit(as.character(est$sequence[i]), "_")[[1]]
  est[i, dim(est)[2]] <- as.numeric(name[length(name)])

}
colnames(est)[dim(est)[2]] <- "SampleTime"

# Converts days to years
est[, 6:9] <- est[, 6:9]/365

# Changes sample date to factor
est[,9] <- as.factor(round(est[,9], digits = 1))

# Finds the patient number and adds the time of treatment start
est <- cbind(est, -1)
colnames(est)[dim(est)[2]] <- "ptNum"
est <- cbind(est, -1)
colnames(est)[dim(est)[2]] <- "ART_start"

for (i in 1:dim(est)[1]) {
  if (est$patient[i] == "217_ENV2" || est$patient[i] == "217_ENV3" || est$patient[i] == "217_ENV4") {
    est$ptNum[i] <- 217
    est$ART_start[i] <- 2521/365
    
  } else if (est$patient[i] == "257_ENV2" || est$patient[i] == "257_ENV3" || est$patient[i] == "257_ENV4" || est$patient[i] == "257_GAG1" || est$patient[i] == "257_NEF1") {
    est$ptNum[i] <- 257
    est$ART_start[i] <- 1741/365
    
  } else {
    message("Name doesn't match")
  }

}

# Changes the removal of columns with gaps to a factor
est$filter <- as.factor(est$filter)

# Changes the sample time to be numeric
est$SampleTime <- as.numeric(as.character(est$SampleTime))
colors <- hue_pal()(3)  

est$patient<- as.factor(est$patient)

#colnames(est)[length(colnames(est))] <- "drawColor"
for (pt in levels(est$patient)){
  for (fil in levels(est$filter)){
  est_pt <- est[est[, "patient"] == pt, ]
  est_pt <- est_pt[est_pt[, "filter"] == fil, ]
  est_pt$numDraw <- as.factor(est_pt$numDraw)
  est_pt_df <- as.data.frame(est_pt)
  if (dim(est_pt_df)[1]>0){
    pdf(paste("~/latency_manuscript/figures/pt",pt,"fil", as.numeric(as.character(fil)) * 100, ".pdf", sep =""))
    tab <- table(est_pt_df$numDraw)
    if(length(names(tab)) == 3 ){
      colGraph <-  c("10" = colors[1],
                     "15" = colors[2],
                      "20" = colors[3])
      } else if (length(names(tab)) == 2 && "10" %in% names(tab)) {
      colGraph <-  c("10" = colors[1], "15" = colors[2])
      
    } else if (length(names(tab)) == 2 && "20" %in% names(tab)) {
      colGraph <-  c("15" = colors[2], "20" = colors[3])}
    
  print(est_pt_df %>% 
          ggplot(mapping = aes(x = sequence, y = nodeDate, ymin = lowCI, ymax = highCI, 
                               color= numDraw, order = c(1:dim(est_pt_df)[1]))) + facet_grid(numDraw ~ method) +
        
          scale_color_manual(values = colGraph)+
          geom_point() + geom_hline(yintercept =  0, linetype="dashed") + 
          geom_hline(yintercept =  est_pt_df$ART_start[1])+
          geom_hline(yintercept =  est_pt_df$SampleTime[1], linetype="dotted")+
          coord_flip() + ylab("inferred integration date (years)") +labs(color = "Number of RNA \nsequences per \nsample time") +
           ylim(min(c(est_pt$nodeDate, est_pt$lowCI, 0), na.rm = TRUE), max(c(est_pt$nodeDate, est_pt$highCI,  est_pt_df$SampleTime[1]), na.rm = TRUE))+
          geom_errorbar()+
          theme_bw()  +theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
            axis.text.y = element_blank(),
            axis.ticks = element_blank()))
  dev.off()
  }
  }
}
