df <- read.csv("~/HIVtreeAnalysis/treeSimulations/compareVolume/compare_volume.csv")
# plot(df[ , "Volume"], df[, "Tree_length"])
# plot(df[ , "Volume"], df[, "time_latent"])
# plot(df[ , "Volume"], df[, "percent_time_latent"])
# plot(df[ , "Volume"], df[, "root_age"])

savepdf <- function(file, width=16, height=10)
{
  fname <- paste("~/github/HIV_latency/writing/",file,".pdf",sep="")
  pdf(fname, width=width/2.54 * .9, height=height/2.54,
      pointsize=17)
  par(mgp=c(2.2,0.45,0), tcl=-0.4, mar=c(3.3,3.6,1.1,1.1))
}

require(graphics)
require(stats)
library(splines)
library(ggplot2)
library(ggplotify)
library(cowplot)

# Tree length
meanTreeLength <-aggregate(Tree_length~Volume, data =df,  FUN=mean)
sdTreeLength  <- 2* aggregate(Tree_length~Volume, data =df,  FUN=sd)

ispl<-interpSpline(meanTreeLength$Volume, meanTreeLength$Tree_length)
plot(predict(ispl, seq(2.5, 100, length.out = 100)), ylim = c(0 , max(df[, "Tree_length"], na.rm = TRUE) + 1000), xlim=c(0,100.6), xaxs="i", yaxs="i", ylab= "Tree   Length", xlab= "Volume (mL)", type = "l")

# savepdf("vol_tree_length_wo_white")
ispl<-interpSpline(meanTreeLength$Volume, meanTreeLength$Tree_length)

# time latent
meanTimeLatent <-aggregate(time_latent~Volume, data =df,  FUN=mean)
sdTimeLatent  <- 2 * aggregate(time_latent~Volume, data =df,  FUN=sd)

# percent time latent 
meanPercentTimeLatent <-aggregate(percent_time_latent~Volume, data =df,  FUN=mean)
sdPercentTimeLatent  <- 2 * aggregate(percent_time_latent~Volume, data =df,  FUN=sd)
# root age
meanRootAge <-aggregate(root_age~Volume, data =df,  FUN=mean)
sdRootAge  <- 2 * aggregate(root_age~Volume, data =df,  FUN=sd)

scale = .013
pdf(file="~/HIVtreeAnalysis/treeSimulations/compareVolume/compareVolumeHorizontal.pdf",width= 185 * 3 * scale ,height=350  / 3  * scale)
par(mfrow=c(1,3), mar= c(.5, 4, .5, 1), mai = c(.4,.5, .2, 0.05))
ispl<-interpSpline(meanTreeLength$Volume, meanTreeLength$Tree_length)
plot(predict(ispl, seq(2.5, 100, length.out = 100)), ylim = c(0 , max(df[, "Tree_length"], na.rm = TRUE) + 1000), xlim=c(0,100.6), xaxs="i", yaxs="i", ylab= "",  type = "l", xlab = "")
points(meanTreeLength$Volume, meanTreeLength$Tree_length, pch = 20)
segments(meanTreeLength[ , 1], meanTreeLength[, 2]-sdTreeLength[ , 2], meanTreeLength[, 1], meanTreeLength[, 2]+sdTreeLength[ , 2])
title(ylab = "Tree   Length (days)", line = 2)


p2 <- plot(meanTimeLatent, ylim = c(5000, max(df[, "time_latent"],  na.rm = TRUE)), pch = 20, ylab = "", xlab = "", xaxs="i", yaxs="i", xlim=c(0,100.6))
segments(meanTimeLatent[ , 1], meanTimeLatent[, 2]-sdTimeLatent[ , 2], meanTimeLatent[, 1],meanTimeLatent[, 2]+sdTimeLatent[ , 2])
title(ylab = "Total time latent (days)", line = 2)
mtext(text = "Volume (mL)",
      side = 1,#side 1 = bottom
      line = 1.8,
      cex = .7)

plot(meanRootAge, ylim = c(250, 305), xlim=c(0,100.6), pch = 20, ylab = "", xlab = "",  yaxs="i",)
segments(meanRootAge[ , 1], meanRootAge[, 2]-sdRootAge[ , 2], meanRootAge[, 1],meanRootAge[, 2]+sdRootAge[ , 2])
title(ylab = "Root age (days)", line = 2)

dev.off()
