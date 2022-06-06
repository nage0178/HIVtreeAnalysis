# File containing summary information about each alignment
CAP217 <- read.csv("~/HIVtreeAnalysis/data/abrahams/CAP217summary")

args = commandArgs(trailingOnly = TRUE)
if(length(args) != 1) {
  stop("Incorrect number of arguements")
} else {
  # Number of sequences to draw at each time point
  numDraw <- as.numeric(args[1])
}

CAP217_ENV2 <- CAP217[CAP217[ ,1] ==  "CAP217_ENV_2_all_hap.fasta_combined.msaEdit", ]
CAP217_ENV3 <- CAP217[CAP217[ ,1] ==  "CAP217_ENV_3_all_hap.fasta_combined.msaEdit", ]
CAP217_ENV4 <- CAP217[CAP217[ ,1] ==  "CAP217_ENV_4_all_hap.fasta_combined.msaEdit", ]
tab_CAP217_ENV2 <- table(CAP217_ENV2$date) # 12 times, including QVOA, 118 seqs sampled
tab_CAP217_ENV3 <- table(CAP217_ENV3$date) # 13, 134
tab_CAP217_ENV4 <- table(CAP217_ENV4$date) # 12, 133

set.seed(1)

##### CAP217_ENV2
CAP217_ENV2_keep <- c()
# Use length minus one since the last time point is the QVOA sequences
for( i in 1:(length(tab_CAP217_ENV2) - 1)) {
  
  # If there are less than numDraw sequences, take all the sequences
  if (tab_CAP217_ENV2[i]  < numDraw) {
    CAP217_ENV2_keep <- c(CAP217_ENV2_keep, which(CAP217_ENV2$date == names(tab_CAP217_ENV2)[i]))
  
  # Else sample numDraw sequences
  } else {
    drawFrom <- which(CAP217_ENV2$date == names(tab_CAP217_ENV2)[i])
    CAP217_ENV2_keep <- c(CAP217_ENV2_keep, sample(drawFrom, numDraw))
  }
}
# i+1 are all the QVOA sequences
# Keep all of the QVOA sequences plus the ones draw in the loop 
CAP217_ENV2_keep <- c(CAP217_ENV2_keep, which(CAP217_ENV2$date == names(tab_CAP217_ENV2)[i + 1]))
keep <- CAP217_ENV2[CAP217_ENV2_keep ,"seq"]
# Record the sequences to be kept 
write(as.character(CAP217_ENV2[CAP217_ENV2_keep ,"seq"]), file = paste("~/HIVtreeAnalysis/data/abrahams/CAP217_ENV2_seqs_d", numDraw, sep = ""))

##### CAP217_ENV3
CAP217_ENV3_keep <- c()
for( i in 1:(length(tab_CAP217_ENV3) - 1)) {
  
  # If there are less than numDraw sequences, take all the sequences
  if (tab_CAP217_ENV3[i]  < numDraw) {
    CAP217_ENV3_keep <- c(CAP217_ENV3_keep, which(CAP217_ENV3$date == names(tab_CAP217_ENV3)[i]))
    
    # Else sample numDraw sequences
  } else {
    drawFrom <- which(CAP217_ENV3$date == names(tab_CAP217_ENV3)[i])
    CAP217_ENV3_keep <- c(CAP217_ENV3_keep, sample(drawFrom, numDraw))
  }
}
CAP217_ENV3_keep <- c(CAP217_ENV3_keep, which(CAP217_ENV3$date == names(tab_CAP217_ENV3)[i + 1]))
keep <- CAP217_ENV3[CAP217_ENV3_keep ,"seq"]
write(as.character(CAP217_ENV3[CAP217_ENV3_keep ,"seq"]), file = paste("~/HIVtreeAnalysis/data/abrahams/CAP217_ENV3_seqs_d", numDraw, sep = ""))

##### CAP217_ENV4
CAP217_ENV4_keep <- c()
for( i in 1:(length(tab_CAP217_ENV4) - 1)) {
  
  # If there are less than numDraw sequences, take all the sequences
  if (tab_CAP217_ENV4[i]  < numDraw) {
    CAP217_ENV4_keep <- c(CAP217_ENV4_keep, which(CAP217_ENV4$date == names(tab_CAP217_ENV4)[i]))
    
    # Else sample numDraw sequences
  } else {
    drawFrom <- which(CAP217_ENV4$date == names(tab_CAP217_ENV4)[i])
    CAP217_ENV4_keep <- c(CAP217_ENV4_keep, sample(drawFrom, numDraw))
  }
}
CAP217_ENV4_keep <- c(CAP217_ENV4_keep, which(CAP217_ENV4$date == names(tab_CAP217_ENV4)[i + 1]))
keep <- CAP217_ENV4[CAP217_ENV4_keep ,"seq"]
write(as.character(CAP217_ENV4[CAP217_ENV4_keep ,"seq"]), file = paste("~/HIVtreeAnalysis/data/abrahams/CAP217_ENV4_seqs_d", numDraw, sep = ""))


# For the other patient, repeat 
CAP257 <- read.csv("~/HIVtreeAnalysis/data/abrahams/CAP257summary")


CAP257_ENV2 <- CAP257[CAP257[ ,1] ==  "CAP257_ENV_2_all_hap.fasta_combined.msaEdit", ]
CAP257_ENV3 <- CAP257[CAP257[ ,1] ==  "CAP257_ENV_3_all_hap.fasta_combined.msaEdit", ]
CAP257_ENV4 <- CAP257[CAP257[ ,1] ==  "CAP257_ENV_4_all_hap.fasta_combined.msaEdit", ]
CAP257_GAG1 <- CAP257[CAP257[ ,1] ==  "CAP257_GAG_1_all_hap.fasta_combined.msaEdit", ]
CAP257_NEF1 <- CAP257[CAP257[ ,1] ==  "CAP257_NEF_1_all_hap.fasta_combined.msaEdit", ]
tab_CAP257_ENV2 <- table(CAP257_ENV2$date)
tab_CAP257_ENV3 <- table(CAP257_ENV3$date)
tab_CAP257_ENV4 <- table(CAP257_ENV4$date)
tab_CAP257_GAG1 <- table(CAP257_GAG1$date)
tab_CAP257_NEF1 <- table(CAP257_NEF1$date)

##### CAP257_ENV2
CAP257_ENV2_keep <- c()
for( i in 1:(length(tab_CAP257_ENV2) - 1)) {
  
  # If there are less than numDraw sequences, take all the sequences
  if (tab_CAP257_ENV2[i]  < numDraw) {
    CAP257_ENV2_keep <- c(CAP257_ENV2_keep, which(CAP257_ENV2$date == names(tab_CAP257_ENV2)[i]))
    
    # Else sample numDraw sequences
  } else {
    drawFrom <- which(CAP257_ENV2$date == names(tab_CAP257_ENV2)[i])
    CAP257_ENV2_keep <- c(CAP257_ENV2_keep, sample(drawFrom, numDraw))
  }
}
CAP257_ENV2_keep <- c(CAP257_ENV2_keep, which(CAP257_ENV2$date == names(tab_CAP257_ENV2)[i + 1]))
keep <- CAP257_ENV2[CAP257_ENV2_keep ,"seq"]
write(as.character(CAP257_ENV2[CAP257_ENV2_keep ,"seq"]), file = paste("~/HIVtreeAnalysis/data/abrahams/CAP257_ENV2_seqs_d", numDraw, sep = ""))

##### CAP257_ENV3
CAP257_ENV3_keep <- c()
for( i in 1:(length(tab_CAP257_ENV3) - 1)) {
  
  # If there are less than numDraw sequences, take all the sequences
  if (tab_CAP257_ENV3[i]  < numDraw) {
    CAP257_ENV3_keep <- c(CAP257_ENV3_keep, which(CAP257_ENV3$date == names(tab_CAP257_ENV3)[i]))
    
    # Else sample numDraw sequences
  } else {
    drawFrom <- which(CAP257_ENV3$date == names(tab_CAP257_ENV3)[i])
    CAP257_ENV3_keep <- c(CAP257_ENV3_keep, sample(drawFrom, numDraw))
  }
}
CAP257_ENV3_keep <- c(CAP257_ENV3_keep, which(CAP257_ENV3$date == names(tab_CAP257_ENV3)[i + 1]))
keep <- CAP257_ENV3[CAP257_ENV3_keep ,"seq"]
write(as.character(CAP257_ENV3[CAP257_ENV3_keep ,"seq"]), file = paste("~/HIVtreeAnalysis/data/abrahams/CAP257_ENV3_seqs_d", numDraw, sep = ""))

##### CAP257_ENV4
CAP257_ENV4_keep <- c()
for( i in 1:(length(tab_CAP257_ENV4) - 1)) {
  
  # If there are less than numDraw sequences, take all the sequences
  if (tab_CAP257_ENV4[i]  < numDraw) {
    CAP257_ENV4_keep <- c(CAP257_ENV4_keep, which(CAP257_ENV4$date == names(tab_CAP257_ENV4)[i]))
    
    # Else sample numDraw sequences
  } else {
    drawFrom <- which(CAP257_ENV4$date == names(tab_CAP257_ENV4)[i])
    CAP257_ENV4_keep <- c(CAP257_ENV4_keep, sample(drawFrom, numDraw))
  }
}
CAP257_ENV4_keep <- c(CAP257_ENV4_keep, which(CAP257_ENV4$date == names(tab_CAP257_ENV4)[i + 1]))
keep <- CAP257_ENV4[CAP257_ENV4_keep ,"seq"]
write(as.character(CAP257_ENV4[CAP257_ENV4_keep ,"seq"]), file = paste("~/HIVtreeAnalysis/data/abrahams/CAP257_ENV4_seqs_d", numDraw, sep = ""))

##### CAP257_GAG1
CAP257_GAG1_keep <- c()
for( i in 1:(length(tab_CAP257_GAG1) - 1)) {
  
  # If there are less than numDraw sequences, take all the sequences
  if (tab_CAP257_GAG1[i]  < numDraw) {
    CAP257_GAG1_keep <- c(CAP257_GAG1_keep, which(CAP257_GAG1$date == names(tab_CAP257_GAG1)[i]))
    
    # Else sample numDraw sequences
  } else {
    drawFrom <- which(CAP257_GAG1$date == names(tab_CAP257_GAG1)[i])
    CAP257_GAG1_keep <- c(CAP257_GAG1_keep, sample(drawFrom, numDraw))
  }
}
CAP257_GAG1_keep <- c(CAP257_GAG1_keep, which(CAP257_GAG1$date == names(tab_CAP257_GAG1)[i + 1]))
keep <- CAP257_GAG1[CAP257_GAG1_keep ,"seq"]
write(as.character(CAP257_GAG1[CAP257_GAG1_keep ,"seq"]), file = paste("~/HIVtreeAnalysis/data/abrahams/CAP257_GAG1_seqs_d", numDraw, sep = ""))

##### CAP257_NEF1
CAP257_NEF1_keep <- c()
for( i in 1:(length(tab_CAP257_NEF1) - 1)) {
  
  # If there are less than numDraw sequences, take all the sequences
  if (tab_CAP257_NEF1[i]  < numDraw) {
    CAP257_NEF1_keep <- c(CAP257_NEF1_keep, which(CAP257_NEF1$date == names(tab_CAP257_NEF1)[i]))
    
    # Else sample numDraw sequences
  } else {
    drawFrom <- which(CAP257_NEF1$date == names(tab_CAP257_NEF1)[i])
    CAP257_NEF1_keep <- c(CAP257_NEF1_keep, sample(drawFrom, numDraw))
  }
}
CAP257_NEF1_keep <- c(CAP257_NEF1_keep, which(CAP257_NEF1$date == names(tab_CAP257_NEF1)[i + 1]))
keep <- CAP257_NEF1[CAP257_NEF1_keep ,"seq"]
write(as.character(CAP257_NEF1[CAP257_NEF1_keep ,"seq"]), file = paste("~/HIVtreeAnalysis/data/abrahams/CAP257_NEF1_seqs_d", numDraw, sep = ""))

