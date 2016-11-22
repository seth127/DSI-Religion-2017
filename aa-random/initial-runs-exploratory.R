setwd("~/Documents/DSI/Capstone/DSI-Religion-2017")
library(ggplot2)
library(dplyr)

df <- read.csv('modelOutput/modelStats.csv', stringsAsFactors = F)
View(df)

judgeDF <- group_by(df, judgementMethod)
judgeAcc <- summarise(judgeDF, mean(rfAccuracy), mean(svmAccuracy))
names(judgeAcc) <- c("meth", "rf", "svm")

ggplot(data=judgeAcc, aes(x=meth, y=rf)) + geom_bar(stat="identity", position=position_dodge())

# avgSD for 
ggplot(df, aes(x=runID, fill=judgementMethod, y=rfAccuracy)) + geom_bar(stat="identity", position=position_dodge())


orderDF <- function(df, col, fac) {
  # order it
  df <- df[order(df$col, decreasing=T), ]
  rownames(df) <- NULL
  # set factor levels to new order
  df <- within(df, fac <- factor(fac, levels=fac))
  df
}

# order it
df <- df[order(df$col, decreasing=T), ]
rownames(df) <- NULL
# set factor levels to new order
df <- within(df, fac <- factor(fac, levels=fac))
df
  # now plot it
  #ggplot(df, aes(x=fac, y= col, fill=ClassGeneral)) + geom_bar(stat="identity", position=position_dodge()) + ggtitle("Percentage of readings with Screen On") + 
    #scale_y_continuous(breaks = c(.05,.1,.15,.2), labels = c("5%", "10%", "15%", "20%"))