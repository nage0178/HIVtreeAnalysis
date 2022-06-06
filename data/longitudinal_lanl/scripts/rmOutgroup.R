library(ape)

args = commandArgs(trailingOnly = TRUE)
if(length(args) != 3) {
  stop("Incorrect number of arguements")
} else {
  inFile <- args[1]
  outFile <- args[2]
  sequence <- args[3]
}

tree <- read.tree(inFile)
newTree <-  drop.tip(tree, sequence)
write.tree(newTree, file = outFile)