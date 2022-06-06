seqs <- read.csv("~/HIV_latency_general/data/abrahams/sequences.txt")
#View(seqs[c(which(seqs[,1] == "W25"),which(seqs[,1] == "B_W15")), ])
#View(seqs[c(which(seqs[,1] == "W6"),which(seqs[,1] == "W11")), ])

rowW25 <- which(seqs[,1] == "W25")
rowB_W15 <- which(seqs[,1] == "B_W15")

rowW6 <- which(seqs[,1] == "W6")
rowW11 <- which(seqs[,1] == "W11")

for (i in 2:dim(seqs)[2]){
  if (seqs[rowW25, i] != "") {
    seqs[rowB_W15,i] <- seqs[rowW25, i] 
  }

  if (seqs[rowW6, i] != "") {
    seqs[rowW11,i] <- seqs[rowW6, i] 
  }
}

seqs[rowB_W15, 1] <- "W25-B_W15"
seqs[rowW11, 1] <- "W6-W11"
seqs <- seqs[c(-rowW6,-rowW25), ]

write.csv(seqs, "~/HIV_latency_general/data/abrahams/sequences257.txt", quote =FALSE, row.names=FALSE)
