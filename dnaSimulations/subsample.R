library(ape)
library(phangorn)
library(phytools)

args = commandArgs(trailingOnly = TRUE)
if(length(args) != 5) {
  stop("Incorrect number of arguements")
} else {
  treeFile <- args[1]
  oldSampleFile <- args[2]
  newSampleFile <- args[3]
  outFile<- args[4]
  seed <- args[5]
}
set.seed(seed)

# Reads in tree
sim_tree <- read.tree(file = treeFile)

# Original sampling numbers and times
original_sample <- read.csv(oldSampleFile, header = FALSE)
colnames(original_sample) <- c("time", "active", "latent")
# New number of sequences to sample 
new_sample <- read.csv(newSampleFile, header = FALSE)
colnames(new_sample) <- c("time", "active", "latent")

# The dimensions of the sampling files must be the same
if(!all(dim(new_sample) == dim(original_sample))) {
  stop("Sample files do not match in dimensions")
} 
# The sampling times must be the same
if(!all(new_sample[, 1] == original_sample[, 1])) {
  stop("Sample times do not match in new and old files")
  
}

# Number of tips to remove at each time 
numSubSample <- original_sample - new_sample
numSubSample[, 1] <- original_sample[, 1]
if (any(numSubSample < 0)) {
  stop("There are too many sequences to subsample")
  
}

nodenames <- c()
# Splits the node names by the "_" and saves it in a matrix.
# Nodes are named as follows: Node_[latent state 0 or 1]_[node index]_[sampletime - tottimelatent on branch]_[sample time]
# The node index is unqiue for each node.
for (i in 1: length(sim_tree$tip.label)) {
  nodenames<- rbind(nodenames, (strsplit(sim_tree$tip.label[i], "_")[[1]]))
}
tipKeepNames <- c()
if (any(nodenames[, 1] == "outgroup")) {
  # Remove "Node" column from matrix
	tipKeepNames <- c("outgroup")
  nodenames <- (nodenames[-which(nodenames[, 1] == "outgroup"), -1])
} else {
  nodenames <- (nodenames[ , -1])
}

# Converts matrix to numeric 
nodenames <- matrix(as.numeric(nodenames), ncol = ncol(nodenames))

# Find the index for the tips that are latent and active
latent <- which(nodenames[, 1] == 1) 
active <- which(nodenames[, 1] == 0)


tipsRemove <- c()
for(i in 1:dim(new_sample)[1]) {
  # Finds which tips were sampled at a particular sample time
  timeSample <- numSubSample[i, 1]
  sampledAtTime <-(which(abs(nodenames[ ,4] - timeSample) < .001))

  # Separates the sampled tips into active and latent 
  latentAtTime <- intersect(latent, sampledAtTime)
  activeAtTime <- intersect(active, sampledAtTime)

  # Draws which tips to remove
  removeActive <- sample(activeAtTime, numSubSample[i, 2], replace = FALSE)
  removeLatent <- sample(latentAtTime, numSubSample[i, 3], replace = FALSE)
  
  # Adds tips to the list to remove
  tipsRemove<- c(tipsRemove, removeActive)
  tipsRemove<- c(tipsRemove, removeLatent)
  
}

# Finds the names of the tips to keep
tipsKept <- nodenames[-tipsRemove, ]
tipKeepNames <- c(tipKeepNames, paste("Node", tipsKept[ , 1], tipsKept[ , 2], tipsKept[ , 3], tipsKept[ , 4], sep = "_"))

# Finds the names of the tips to drop
tipsDrop <- nodenames[tipsRemove, ]
tipDropNames <- paste("Node", tipsDrop[ , 1], tipsDrop[ , 2], tipsDrop[ , 3], tipsDrop[ , 4], sep = "_")

# Removes tips from the tree
subSampleTree <- drop.tip(sim_tree, tipsRemove)

# Write the next tree file
write.tree(subSampleTree, paste(outFile, "_dropTipsTree.txt", sep = ""))

# Writes the names of the tips that were removed 
write(tipDropNames, file = paste(outFile, "_dropTips.txt", sep = ""))

# Writes the names of the tips that were kept
write(tipKeepNames, file = paste(outFile, "_keepTips.txt", sep = ""))