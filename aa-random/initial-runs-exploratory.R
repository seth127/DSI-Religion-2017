setwd("~/Documents/DSI/Capstone/DSI-Religion-2017")
library(ggplot2)
library(dplyr)

df <- read.csv('modelOutput/modelStats.csv', stringsAsFactors = T)
View(df)

judgeDF <- group_by(df, judgementMethod)
judgeAcc <- summarise(judgeDF, mean(rfAccuracy), mean(svmAccuracy))
names(judgeAcc) <- c("meth", "rf", "svm")

ggplot(data=judgeAcc, aes(x=meth, y=rf)) + geom_bar(stat="identity", position=position_dodge())

# SVM ACCURACY BY JUDGEMENT METHOD
# order it
df <- df[order(df$svmAccuracy, decreasing=T), ]
rownames(df) <- NULL
# plot it
# with PRONOUN COUNTS
ggplot(df[!is.na(df$nous),], aes(x=as.numeric(row.names(df[!is.na(df$nous),])), fill=judgementMethod, y=svmAccuracy)) + geom_bar(stat="identity", position=position_dodge())

# without PRONOUN COUNTS
ggplot(df[is.na(df$nous),], aes(x=as.numeric(row.names(df[is.na(df$nous),])), fill=judgementMethod, y=svmAccuracy)) + geom_bar(stat="identity", position=position_dodge())




  # now plot it
  #ggplot(df, aes(x=fac, y= col, fill=ClassGeneral)) + geom_bar(stat="identity", position=position_dodge()) + ggtitle("Percentage of readings with Screen On") + 
    #scale_y_continuous(breaks = c(.05,.1,.15,.2), labels = c("5%", "10%", "15%", "20%"))