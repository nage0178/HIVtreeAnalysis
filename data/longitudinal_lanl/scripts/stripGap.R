library(ape)

args = commandArgs(trailingOnly = TRUE)
if(length(args) != 2) {
  stop("Incorrect number of arguements")
} else {
  inFile <- args[1]
  outFile<- args[2]
}

seq <- read.dna(inFile, format="fasta", as.matrix = TRUE, as.character = TRUE )

percGap <- .75

rmSeq <- c()
for(i in 1:dim(seq)[2]){
  seqTab<- table(seq[, i])
  if((is.na(seqTab["-"]) == FALSE) && (seqTab["-"] >= percGap * dim(seq)[1])) {
    rmSeq <- cbind(rmSeq, i)
  }
}
colnames(rmSeq) <- NULL
print(inFile)
print(paste("Gaps removed:", length(rmSeq)))
if (length(rmSeq)>0) {

print(paste("Positions: "))

print(as.character(rmSeq))
seqShort <- seq[, -rmSeq]

write.dna(seqShort, colsep = "", file = outFile, format = "fasta")
} else {
	write.dna(seq, colsep = "", file = outFile, format = "fasta")
}
