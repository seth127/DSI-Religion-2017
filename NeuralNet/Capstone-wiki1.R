library(XML)
library(tm)
library(MASS)
library(SnowballC)

#######################
### Import the Data ###
#######################

setwd("~/Documents/DSI/Capstone/DSI-Religion-2017")

## read in docRanks.csv file ##
docRanks <- read.csv(paste(c(toString(getwd()),"/refData/docRanks.csv"),collapse = ''), stringsAsFactors = F)
# 


master <- read.csv(paste(c(toString(getwd()),"/NeuralNet/wikiTFIDF/data_dsicap_single-wikiTFIDF-with-ranks.csv"),collapse = ''), stringsAsFactors = F)
master[is.na(master)] <- 0

master$X1 <- ifelse(master$rank == 1, 1, 0)
master$X2 <- ifelse(master$rank == 2, 1, 0)
master$X3 <- ifelse(master$rank == 3, 1, 0)
master$X4 <- ifelse(master$rank == 4, 1, 0)
master$X5 <- ifelse(master$rank == 5, 1, 0)
master$X6 <- ifelse(master$rank == 6, 1, 0)
master$X7 <- ifelse(master$rank == 7, 1, 0)
master$X8 <- ifelse(master$rank == 8, 1, 0)
master$X9 <- ifelse(master$rank == 9, 1, 0)

masterX <- master[,3:(ncol(master)-8)]
masterY <- master[, (ncol(master)-8):ncol(master)]

#


# 80% of the sample size
smp_size <- floor(0.80 * nrow(master))

# set the seed to make your partition reproductible
set.seed(123)
train_ind <- sample(seq_len(nrow(master)), size = smp_size)

trainX <- masterX[train_ind, ]
testX <- masterX[-train_ind, ]

trainY <- masterY[train_ind, ]
testY <- masterY[-train_ind, ]

# write data to csvs 
write.csv(trainX, file = "~/Documents/DSI/Capstone/DSI-Religion-2017/NeuralNet/trainXwiki.csv")
write.csv(trainY, file = "~/Documents/DSI/Capstone/DSI-Religion-2017/NeuralNet/trainYwiki.csv")

write.csv(testX, file = "~/Documents/DSI/Capstone/DSI-Religion-2017/NeuralNet/testXwiki.csv")
write.csv(testY, file = "~/Documents/DSI/Capstone/DSI-Religion-2017/NeuralNet/testYwiki.csv")

