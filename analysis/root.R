library(ape)

args = commandArgs(trailingOnly = TRUE)

if (length(args) != 2) {
  stop("Incorrect number of arguements")
} else {
  treeFile <- args[1]
  outTree <- args[2]
}

tree <- read.tree(treeFile)
tree <- drop.tip(tree, "outgroup")
nodenames <- c()

for (i in 1:length(tree$tip.label)) {
	nodenames <- rbind(nodenames, (strsplit(tree$tip.label[i], "_")[[1]]))
}
date <- as.numeric(nodenames[,4])
date[ which(nodenames[,2] == 1)] <- NA

rootTree <- rtt(tree, date, opt.tol = 1e-8)
write.tree(rootTree, file = outTree)
