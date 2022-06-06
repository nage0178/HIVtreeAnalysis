data <- read.csv("~/HIV_latency_general/data/abrahams/aaw5589_table_s1.csv")
data <- data[1:365,]
data <- cbind(data, (round(data$Time.post.infection..Days./7 )))
colnames(data)[length(colnames(data))] = "WPI"
data <- cbind(data, data$Time.post.infection..Days. - data$Time.on.ART..Days.)
colnames(data)[length(colnames(data))] = "ART_Start_Day"

data <- cbind(data, as.Date(data$PBMC.collection.Date, format ="%d-%b-%y")-as.Date(data$Transmission.date, format ="%d-%b-%y"))
colnames(data)[length(colnames(data))] = "Days_PBMC"
data <- cbind(data , round(as.numeric(apply(as.matrix(data$Days_PBMC, ncol = 1), 1, as.character))/7))
colnames(data)[length(colnames(data))] = "Weeks_PBMC"
data$Viral.Load..cp.ml. <- gsub(",", "", as.character(data$Viral.Load..cp.ml.))
write.csv(data, "~/HIV_latency_general/data/abrahams/dates.csv", row.names = FALSE)
       
