library(kdensity)
library(GoFKernel)

args = commandArgs(trailingOnly = TRUE)
if(length(args) != 5) {
  stop("Incorrect number of arguements")
} else {
  inFile <- args[1]
  lowerInt <- as.numeric(args[2])
  upperInt <- as.numeric(args[3])
  timeUnit <- as.numeric(args[4])
  timeZero <- as.numeric(args[5])
  # timeUnit <- 1000
  # timeZero <- 3650
}

# timeUnit <- 1000
# timeZero <- 3650
# lowerInt <- 0
# upperInt <- 3.695

times<- read.csv(inFile, sep = "\t")

names(times) <- c("ENV2", "ENV3", "ENV4", "GAG1", "NEF1", "ENV2Prior", "ENV3Prior", "ENV4Prior", "GAG1Prior", "NEF1Prior")

if (! all(is.na(times$ENV2))) {
  ENV2Post <- kdensity(times$ENV2, na.rm = TRUE, normalize = FALSE)
  ENV2Prior <- kdensity(times$ENV2Prior, na.rm = TRUE, normalize = FALSE)
} else {
  ENV2Post <- function(x) 1
  ENV2Prior <- function(x) 1
}

if (! all(is.na(times$ENV3))) {
  ENV3Post <- kdensity(times$ENV3, na.rm = TRUE, normalize = FALSE)
  ENV3Prior <- kdensity(times$ENV3Prior, na.rm = TRUE, normalize = FALSE)
} else {
  ENV3Post <- function(x) 1
  ENV3Prior <- function(x) 1
}

if (! all(is.na(times$ENV4))) {
  ENV4Post <- kdensity(times$ENV4, na.rm = TRUE, normalize = FALSE)
  ENV4Prior <- kdensity(times$ENV4Prior, na.rm = TRUE, normalize = FALSE)
} else {
  ENV4Post <- function(x) 1
  ENV4Prior <- function(x) 1
}

if (! all(is.na(times$GAG1))) {
  GAG1Post <- kdensity(times$GAG1, na.rm = TRUE, normalize = FALSE)
  GAG1Prior <- kdensity(times$GAG1Prior, na.rm = TRUE, normalize = FALSE)
} else {
  GAG1Post <- function(x) 1
  GAG1Prior <- function(x) 1
}

if (! all(is.na(times$NEF1))) {
  NEF1Post <- kdensity(times$NEF1, na.rm = TRUE, normalize = FALSE)
  NEF1Prior <- kdensity(times$NEF1Prior, na.rm = TRUE, normalize = FALSE)
} else {
  NEF1Post <- function(x) 1
  NEF1Prior <- function(x) 1
}


adjTime <- function (time) {
  timeZero - time * timeUnit
}

###
constant <- integrate(function(x) ENV2Post(x) * ENV3Post(x) * ENV4Post(x) * GAG1Post(x) * NEF1Post(x)/ GAG1Prior(x) / ENV3Prior(x) / ENV4Prior(x) / NEF1Prior(x) / ENV2Prior(x), lower = lowerInt, upper = upperInt)$value
dist <- function (x) {
  integrate(function (x) ENV2Post(x) * ENV3Post(x) * ENV4Post(x) * GAG1Post(x) * NEF1Post(x)/ GAG1Prior(x) / ENV3Prior(x) / ENV4Prior(x) / NEF1Prior(x) / ENV2Prior(x) /constant, lower = lowerInt, upper = x)[[1]]
}
invFunc <- inverse(dist, lower = lowerInt, upper = upperInt)
lowerEst <- invFunc(.025)
upperEst <- invFunc(.975)
meanEst <- integrate(function(x) x * ENV2Post(x) * ENV3Post(x) * ENV4Post(x) * GAG1Post(x) * NEF1Post(x)/ GAG1Prior(x) / ENV3Prior(x) / ENV4Prior(x) / NEF1Prior(x) / ENV2Prior(x) /constant, lower = lowerInt, upper = upperInt)[[1]]
print(paste(adjTime(meanEst), adjTime(upperEst), adjTime(lowerEst), sep = ","))

# plot(function(x) ENV2Post(x) * ENV3Post(x) * ENV4Post(x) * GAG1Post(x)/ GAG1Prior(x) / ENV3Prior(x) / ENV4Prior(x) /constant, 
#      xlim = xlimits, 
#      ylim = ylimits, 
#      lwd = 2,
#      xlab = "Latent Integration Time", 
#      ylab = "Density", )
# 
# lines(GAG1Post, col = "green")
# lines(ENV3Post, col = "red")
# lines(ENV4Post, col = "blue")
# lines(ENV2Post, col = "purple")
# # Prior
# lines(GAG1Prior, col = "green", lty = 2)
# lines(ENV2Prior, col = "purple", lty = 2)
# lines(ENV3Prior, col = "red", lty = 2)
# lines(ENV4Prior, col = "blue", lty = 2)

# prior <- c()
# post <- c()
# for (i in 1:length(nonEmpty)) {
#   priorOffset <- dim(times)[2]/2
#   post[[i]] <- kdensity(times[,nonEmpty[i]], na.rm = TRUE, normalize = FALSE)
#   prior[[i]] <- kdensity(times[,nonEmpty[i]+priorOffset], na.rm = TRUE, normalize = FALSE)
#   
# }
# 
# product <- c()
# product[[1]] <- function(x) post[[1]](x) / prior[[1]](x)
# for(i in 2:length(nonEmpty)) {
#   product[[i]] <- function(x) post[[i]](x) / prior[[i]](x)
# }
# 
# final <- c()
# final[[1]] <- function(x) product[[1]](x)
# for (i in 2:length(nonEmpty)) {
#   final[[i]] <- function(x) product[[i]](x) * final[[i-1]](x)
# }


# nonEmpty <- c()
# 
# for(i in 1:(dim(times)[2]/2)) {
#   if ( ! all(is.na(times[,1]))) {
#     nonEmpty <- c(nonEmpty, i)
#   }
# }
# 
# if (length(nonEmpty)<2) {
#   message("No genes to combine. Only one gene. Exiting")
#   exit()
# }
# 
# 
