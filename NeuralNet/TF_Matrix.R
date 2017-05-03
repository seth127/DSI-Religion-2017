library(XML)
library(tm)
library(MASS)
library(SnowballC)

#######################
### Import the Data ###
#######################

setwd("~/Documents/MSDS/DSI-Religion-2017")

## read in docRanks.csv file ##
docRanks <- read.csv(paste(c(toString(getwd()),"/refData/docRanks.csv"),collapse = ''))

## get single docs ##
# load in first file
file <- paste(c(toString(getwd()), "/data_dsicap_single/", toString(docRanks$groupName[1]), "/raw/", toString(docRanks$groupName[1]), ".txt"), collapse = '')
rawtext <- readLines(file, encoding = "utf-8")
df <- as.data.frame(rawtext)
# get temp data frame
dftemp <- data.frame(matrix(ncol = 1))
names(dftemp)[1] <- "rawtext"
# load rest of docs in temp data frame one by one and append
for (i in 2:(nrow(docRanks)))
{
  file <- paste(c(toString(getwd()), "/data_dsicap_single/", toString(docRanks$groupName[i]), "/raw/", toString(docRanks$groupName[i]), ".txt"), collapse = '')
  rawtext <- readLines(file, encoding = "utf-8")
  if (length(rawtext) > 1)
  {
    rawtext <- toString(paste(rawtext))
  }
  dftemp$rawtext <- rawtext
  df <- rbind(df, dftemp)
}

master <- cbind(df, docRanks)
master <- master[,c(1,4)]

master$X1 <- ifelse(master$rank == 1, 1, 0)
master$X2 <- ifelse(master$rank == 2, 1, 0)
master$X3 <- ifelse(master$rank == 3, 1, 0)
master$X4 <- ifelse(master$rank == 4, 1, 0)
master$X5 <- ifelse(master$rank == 5, 1, 0)
master$X6 <- ifelse(master$rank == 6, 1, 0)
master$X7 <- ifelse(master$rank == 7, 1, 0)
master$X8 <- ifelse(master$rank == 8, 1, 0)
master$X9 <- ifelse(master$rank == 9, 1, 0)

masterX <- master[1]
masterY <- master[3:11]

# get text and transform it into a corpus for train and test
masterX = VCorpus(DataframeSource(masterX))
# compute TF matrix and clean
masterX.clean.tf <- DocumentTermMatrix(masterX, control = list(removePunctuation = TRUE, tolower = TRUE, removeNumbers = TRUE, stripWhitespace = TRUE))
# convert to data frame
masterX.clean.tf <- as.data.frame(as.matrix(masterX.clean.tf))

# 80% of the sample size
smp_size <- floor(0.80 * nrow(master))

# set the seed to make your partition reproductible
set.seed(123)
train_ind <- sample(seq_len(nrow(master)), size = smp_size)

trainX <- masterX.clean.tf[train_ind, ]
testX <- masterX.clean.tf[-train_ind, ]

trainY <- masterY[train_ind, ]
testY <- masterY[-train_ind, ]

# write data to csvs 
write.csv(trainX, file = "~/Documents/MSDS/DSI-Religion-2017/NeuralNet/trainX.csv")
write.csv(trainY, file = "~/Documents/MSDS/DSI-Religion-2017/NeuralNet/trainY.csv")

write.csv(testX, file = "~/Documents/MSDS/DSI-Religion-2017/NeuralNet/testX.csv")
write.csv(testY, file = "~/Documents/MSDS/DSI-Religion-2017/NeuralNet/testY.csv")

