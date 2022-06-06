library(ape)
library(phytools)


args = commandArgs(trailingOnly = TRUE)
if(length(args) != 3) {
  stop("Incorrect number of arguements")
} else {
  treeFile <- args[1]
  mpFile <- args[2]
  rttFile <- args[3]
}


#tree <- read.tree(file = "~/github/HIV_latency_general/data/longitudinal_lanl/tat_reali.fa.raxml.bestTree")
tree <- read.tree(file = treeFile)

nodenames <- c()
for (i in 1: length(tree$tip.label)) {
  splitNames <- strsplit(tree$tip.label[i], "_")[[1]]
  splitNames <- splitNames[length(splitNames)]
  date <- as.numeric(strsplit(splitNames, "d")[[1]][2])
  nodenames<- rbind(nodenames, date)
}


root_tree <- rtt(tree, nodenames)
write.tree(root_tree, rttFile, digits = 1)

root_mp <- midpoint.root(tree)
write.tree(root_mp, mpFile, digits = 1)
