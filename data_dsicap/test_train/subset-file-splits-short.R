setwd("~/Documents/DSI/Capstone/DSI-Religion-2017/data_dsicap/test_train")

for (num in 0:2) {
  split <- read.csv(paste("orig/fileSplit_", num, ".csv", sep=""))
  newsplit <- split[split$group=="Rabbinic" | split$group=="NaumanKhan", ]
  newsplit <- rbind(head(newsplit), tail(newsplit))
  write.csv(newsplit, paste("fileSplit_", num, ".csv", sep=""), row.names = F)
}

