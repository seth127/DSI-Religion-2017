setwd("~/Documents/DSI/Capstone/DSI-Religion-2017")
library(ggplot2)
library(dplyr)

df <- read.csv('modelOutput/modelStats.csv', stringsAsFactors = T)
View(df)

# summaries by judgementMethod (BORING)
judgeDF <- group_by(df, judgementMethod)
judgeAcc <- summarise(judgeDF, mean(rfAccuracy), mean(svmAccuracy))
names(judgeAcc) <- c("meth", "rf", "svm")
ggplot(data=judgeAcc, aes(x=meth, y=rf)) + geom_bar(stat="identity", position=position_dodge())


# SVM ACCURACY BY JUDGEMENT METHOD
# order it
df <- df[order(df$svmAccuracy, decreasing=T), ]
rownames(df) <- NULL

# plot it
# without PRONOUN COUNTS
ggplot(df[is.na(df$nous),], aes(x=as.numeric(row.names(df[is.na(df$nous),])), fill=judgementMethod, y=svmAccuracy)) + geom_bar(stat="identity", position=position_dodge()) + ggtitle('SVM -WITHOUT- Pronoun Counts') + ylim(0,1) + xlab('')

# with PRONOUN COUNTS
ggplot(df[!is.na(df$nous),], aes(x=as.numeric(row.names(df[!is.na(df$nous),])), fill=judgementMethod, y=svmAccuracy)) + geom_bar(stat="identity", position=position_dodge()) + ggtitle('SVM -WITH- Pronoun Counts') + xlab('')

# with ALL
df$didWeCountPronouns <- ifelse(is.na(df$nous), F,T)
ggplot(df, aes(x=as.numeric(row.names(df)), fill=didWeCountPronouns, y=svmAccuracy)) + geom_bar(stat="identity", position=position_dodge()) + ggtitle('SVM - Did We Count Pronouns?') + ylim(0,1) + xlab('')


# VARIABLE IMPORTANCE
vars <- c("avgEVC","avgSD","elle","il","ils","je","le","nous","vous",
          "perNeg","perNegDoc","perPos","perPosDoc",
          "pronounCount","pronounFrac","toBeCount","toBeFrac")

# with only PRONOUN COUNTS
vip = ggplot(df[!is.na(df$nous),], aes(x=nous, y=svmAccuracy)) + geom_point(size=5, aes(colour='nous')) + ggtitle('') + xlab('variable importance')
vip = vip + geom_point(size=5, aes(x=ils, y=svmAccuracy, colour = 'ils'))
vip = vip + geom_point(size=5, aes(x=je, y=svmAccuracy, colour = 'je'))
vip = vip + geom_point(size=5, aes(x=le, y=svmAccuracy, colour = 'le'))
vip = vip + geom_point(size=5, aes(x=vous, y=svmAccuracy, colour = 'vous'))
vip = vip + geom_point(size=5, aes(x=il, y=svmAccuracy, colour = 'il'))
vip = vip + geom_point(size=5, aes(x=elle, y=svmAccuracy, colour = 'elle'))
vip

# with only the notable PRONOUN COUNTS
vip = ggplot(df[!is.na(df$nous),], aes(x=nous, y=svmAccuracy)) + geom_point(size=5, aes(colour='nous')) + ggtitle('') + xlab('variable importance')
vip = vip + geom_point(size=5, aes(x=ils, y=svmAccuracy, colour = 'ils'))
#vip = vip + geom_point(size=5, aes(x=je, y=svmAccuracy, colour = 'je'))
#vip = vip + geom_point(size=5, aes(x=le, y=svmAccuracy, colour = 'le'))
vip = vip + geom_point(size=5, aes(x=vous, y=svmAccuracy, colour = 'vous'))
vip = vip + geom_point(size=5, aes(x=il, y=svmAccuracy, colour = 'il'))
#vip = vip + geom_point(size=5, aes(x=elle, y=svmAccuracy, colour = 'elle'))
vip

# with JUDGEMENTS
vip = ggplot(df, aes(x=nous, y=svmAccuracy)) + geom_point(size=5, aes(colour='nous')) + ggtitle('') + xlab('variable importance')
vip = vip + geom_point(size=5, aes(x=ils, y=svmAccuracy, colour = 'ils'))
vip = vip + geom_point(size=5, aes(x=il, y=svmAccuracy, colour = 'il'))
vip = vip + geom_point(size=5, aes(x=toBeFrac, y=svmAccuracy, colour = 'toBeFrac'))
vip = vip + geom_point(size=5, aes(x=pronounFrac, y=svmAccuracy, colour = 'pronounFrac'))
vip

# with JUDGEMENTS AND PERFORMATIVE
vip = ggplot(df, aes(x=nous, y=svmAccuracy)) + geom_point(size=5, aes(colour='nous')) + ggtitle('') + xlab('variable importance')
vip = vip + geom_point(size=5, aes(x=ils, y=svmAccuracy, colour = 'ils'))
vip = vip + geom_point(size=5, aes(x=il, y=svmAccuracy, colour = 'il'))
vip = vip + geom_point(size=5, aes(x=toBeFrac, y=svmAccuracy, colour = 'toBeFrac'))
vip = vip + geom_point(size=5, aes(x=pronounFrac, y=svmAccuracy, colour = 'pronounFrac'))
vip = vip + geom_point(size=5, aes(x=toBeFrac, y=avgSD, colour = 'avgSD'))
vip = vip + geom_point(size=5, aes(x=pronounFrac, y=avgEVC, colour = 'avgEVC'))
vip


# with JUDGEMENTS AND PERFORMATIVE
vip = ggplot(df, aes(x=nous, y=svmAccuracy)) + geom_point(size=5, aes(colour='nous')) + ggtitle('') + xlab('variable importance')
vip = vip + geom_point(size=5, aes(x=ils, y=svmAccuracy, colour = 'ils'))
vip = vip + geom_point(size=5, aes(x=il, y=svmAccuracy, colour = 'il'))
vip = vip + geom_point(size=5, aes(x=toBeFrac, y=svmAccuracy, colour = 'toBeFrac'))
vip = vip + geom_point(size=5, aes(x=pronounFrac, y=svmAccuracy, colour = 'pronounFrac'))
vip = vip + geom_point(size=5, aes(x=avgSD, y=svmAccuracy, colour = 'avgSD'))
vip = vip + geom_point(size=5, aes(x=avgEVC, y=svmAccuracy, colour = 'avgEVC'))
vip

## JUST PERFORMATIVE
vip = ggplot(df, aes(y=svmAccuracy)) + geom_point(size=5, aes(x=avgSD, colour = 'avgSD'))
vip = vip + geom_point(size=5, aes(x=avgEVC, colour = 'avgEVC'))
vip

##########
## targetWordCount
ggplot(df, aes(x = targetWordCount, y = svmAccuracy, colour = judgementMethod)) + geom_point(size=5)

## binSize
ggplot(df, aes(x = binSize, y = svmAccuracy, colour = judgementMethod)) + geom_point(size=5)

#########

signalDF <- read.csv('modelOutput/modelPredictions-coco_3_cv_3_netAng_30_twc_30_tfidfNoPro_both_bin_10-5Z4U8N.csv', stringsAsFactors = T)

# ils
ggplot(signalDF, aes(x=rank, y=ils, colour = pronounFrac)) + geom_point(size=5)

# pronounFrac
ggplot(signalDF, aes(x=rank, y=pronounFrac)) + geom_point(size=5)

