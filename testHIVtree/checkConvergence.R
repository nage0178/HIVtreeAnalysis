run1 <- read.table("run1")
run2 <- read.table("run2")
run2[,1] <- 0
difference <- abs(run1-run2)

#print(difference)
notConv <- c()
for (i in 2:4 ) {
	if (i ==2 ) {
		tol = .010
	} else {
		tol = .1
	}
	notConv <- c(notConv, which(difference[,i] > tol))
}
notConv <- unique(notConv)
runsNotConv <- difference[notConv,1]
cat(unique(runsNotConv))
#print(length(unique(runsNotConv)))
