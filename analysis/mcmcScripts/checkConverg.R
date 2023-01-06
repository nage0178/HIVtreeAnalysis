args = commandArgs(trailingOnly = TRUE)
if(length(args) != 1) {
  stop("Incorrect number of arguements")
} else {
  file <- args[1]
}

conver <- as.data.frame(read.csv(file))

tab1 <- table(abs(conver$run1-conver$run2)<.01)
tab2 <- table(abs(conver$run1-conver$run2)<.02)
tab3 <- table(abs(conver$run1-conver$run2)<.1)

flagRun <- FALSE

if (dim(tab2) > 1 && tab2[1] > 8) {
  flagRun <- TRUE
}
if (dim(tab2) > 1 && tab2[1] > 4) {
  flagRun <- TRUE
}
if (dim(tab3) > 1 && tab3[1] > 0) {
  flagRun <- TRUE
}

if (flagRun) {
  print(file, quote = FALSE)
}
