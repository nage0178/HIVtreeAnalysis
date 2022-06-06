library(ape)

args = commandArgs(trailingOnly = TRUE)

if (length(args) != 3) {
  stop("Incorrect number of arguements")
} else {
  treeFile <- args[1]
  outTree <- args[2]
  latentFile <- args[3]
}

latentInfo <- read.csv(latentFile)
tree <- read.tree(treeFile)

nodenames <- c()
for (i in 1:length(tree$tip.label)) {
	nodenames <- rbind(nodenames, (strsplit(tree$tip.label[i], "_")[[1]]))
}
date <- as.numeric(nodenames[,2])

for(i in 1:(dim(latentInfo)[1])) {
  if (latentInfo[i,3] == 1 ) {
    match <- 0
    for (j in 1:(length(tree$tip.label))) {
      if (tree$tip.label[j] == (latentInfo[i, 1])) {
        match <- 1
        date[j] <- NA
        break
      }
    }
    if (match == 0) {
      stop("Did not find match for tip")
    }
  }
}

rootTree <- rtt(tree, date, opt.tol = 1e-8)
write.tree(rootTree, file = outTree)
