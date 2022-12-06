library(ape)

tree <- read.tree("~/HIVtreeAnalysis/testHIVtree/tree_BL.txt")
pdf("~/latency_manuscript/figures/simulationTree.pdf", width=40, height=40)
tree$edge.length <-tree$edge.length
plot(tree, cex = 5)
nodelabels(tree$node.label, adj = c(1.2, -.7), frame = "none", cex = 5)
edgelabels(c("", "", "", "", "", "t_D,l"), frame = "none", adj = c(0, -1), cex = 5)
pp <- get("last_plot.phylo", envir = .PlotPhyloEnv)
text(x=(3650-(1216/2)+30), y = 4, "|", cex = 5)
dev.off()


