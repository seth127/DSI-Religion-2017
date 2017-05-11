library(ggplot2)

# change this to your root folder
setwd("/Users/Seth/Documents/DSI/Capstone/DSI-Religion-2017")

df <- read.csv("signalFiles/binnedSignals1.csv")

## Pronouns
ggplot(df, aes(x=as.factor(rank), y = nous)) + geom_boxplot() + ggtitle('"We" Pronouns') + xlab("Linguistic Rigidity") + ylab('fraction of words that are "We" pronoun')

ggplot(df, aes(x=as.factor(rank), y = ils)) + geom_boxplot() + ggtitle('"They" Pronouns') + xlab("Linguistic Rigidity") + ylab('fraction of words that are "They" pronoun')

# used boxplots instead of the point plots below (paper is in b&w anyway)
#ggplot(df, aes(x=as.factor(rank), y = nous, colour = groupId)) + geom_point()
#ggplot(df, aes(x=as.factor(rank), y = ils, colour = groupId)) + geom_point()

## Judgments
ggplot(df, aes(x=as.factor(rank), y = judgementFrac)) + geom_boxplot() + ggtitle('Judgments') + xlab("Linguistic Rigidity") + ylab('fraction of sentences counted at judgments')
