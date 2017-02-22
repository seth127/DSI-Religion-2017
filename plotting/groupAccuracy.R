library(ggplot2)

setwd('/Users/Seth/Documents/DSI/Capstone/DSI-Religion-2017/modelOutputSingleDocs/logs')

df <- read.csv('Single Runs.csv', stringsAsFactors = F)

#########

names <- unique(gsub('[0-9]', '', df$groupName))


groupAccuracy <- function(df, groupName) {
  df <- df[grep(groupName, df$groupName),]
  svmAcc <- sum(abs((df$rank - df$svmPred)) < 1) / nrow(df)
  svmClassAcc <- sum(abs((df$rank - df$svmClassPred)) < 1) / nrow(df)
  rfAcc <- sum(abs((df$rank - df$rfPred)) < 1) / nrow(df)
  rfClassAcc <- sum(abs((df$rank - df$rfClassPred)) < 1) / nrow(df)
  return(c(svmAcc, svmClassAcc, rfAcc, rfClassAcc))
}

groupAccDF <- data.frame(groupName = character(length(names)),
                         svmAcc = numeric(length(names)),
                         svmClassAcc = numeric(length(names)),
                         rfAcc = numeric(length(names)),
                         rfClassAcc = numeric(length(names)),
                         stringsAsFactors = F)

for (i in 1:length(names)) {
  #print(names[i])
  #print(groupAccuracy(df, names[i]))
  #
  groupAccDF$groupName[i] <- names[i]
  groupAccDF[i,2:5] <- groupAccuracy(df, names[i])
}

#######
ggplot(groupAccDF, aes(x=groupName, y=rfClassAcc)) + geom_point(size=5)

gar <- reshape(groupAccDF, varying = c('svmAcc',))