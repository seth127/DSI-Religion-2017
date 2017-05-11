setwd("~/Documents/DSI/Capstone/DSI-Religion-2017")
library(ggplot2)
library(dplyr)

# FANCY FONTS
#https://www.r-bloggers.com/how-to-use-your-favorite-fonts-in-r-charts/
#install.packages("extrafont")
# library(extrafont)
# font_import() # this takes a minute or two
# fonts()
theme_set(theme_grey(base_size = 16))

signalDF <- read.csv('modelOutputSingleDocs/modelPredictions-coco_3_cv_3_netAng_30_twc_30_tfidfNoPro_both_bin_10-SUSAWD', stringsAsFactors = T)

# ils
#ggplot(signalDF, aes(x=rank, y=ils, colour = groupName)) + geom_point(size=5) + ggtitle("They") + theme(text=element_text(size=16, family="Comic Sans MS"))
# ils
ggplot(signalDF, aes(x=rank, y=ils, colour = groupName)) + geom_point(size=5) + ggtitle("They")

# nous
ggplot(signalDF, aes(x=rank, y=nous, colour = groupName)) + geom_point(size=5) + ggtitle("We")

# vous
ggplot(signalDF, aes(x=rank, y=vous, colour = groupName)) + geom_point(size=5) + ggtitle("You")

# it
ggplot(signalDF, aes(x=rank, y=le, colour = groupName)) + geom_point(size=5) + ggtitle("It")


# pronounFrac
ggplot(signalDF, aes(x=rank, y=pronounFrac, colour=perNeg)) + geom_point(size=5)

####
# NOW WITH KEYWORD+PRONOUN JUDGEMENTS
#
files <- c("modelOutput/modelPredictions-coco_3_cv_3_netAng_30_twc_15_tfidf_pronounFrac_bin_10-Y6DDDX.csv",
           #"modelOutput/modelPredictions-coco_3_cv_3_netAng_30_twc_15_tfidfNoPro_both_bin_10-RO610D.csv",
           "modelOutput/modelPredictions-coco_3_cv_3_netAng_30_twc_20_tfidf_pronounFrac_bin_10-7J7LBO.csv",
           #"modelOutput/modelPredictions-coco_3_cv_3_netAng_30_twc_20_tfidfNoPro_both_bin_10-2YZAOL.csv",
           "modelOutput/modelPredictions-coco_3_cv_3_netAng_30_twc_20_tfidfNoPro_pronounFrac_bin_10-7B7C2E.csv",
           "modelOutput/modelPredictions-coco_3_cv_3_netAng_30_twc_30_tfidf_pronounFrac_bin_10-BZ2OB7.csv",
           "modelOutput/modelPredictions-coco_3_cv_3_netAng_30_twc_30_tfidfNoPro_pronounFrac_bin_10-XYVISL.csv"
           )

signalDF <- read.csv("modelOutput/modelPredictions-coco_3_cv_3_netAng_30_twc_15_tfidfNoPro_pronounFrac_bin_10-YNJG3G.csv", stringsAsFactors = T)
for (file in files) {
  newDF <- read.csv(file, stringsAsFactors = T)
  signalDF <- rbind(signalDF, newDF)
  print(file)
  print(dim(newDF))
}
dim(signalDF)

# KEYWORD + PRONOUN JUDGEMENTS
ggplot(signalDF, aes(x=rank, y=PSJudge, colour = groupName)) + geom_point(size=5) + ggtitle("Keyword + Pronoun Judgements")
ggplot(signalDF, aes(x=rank, y=PSJudge, colour = groupName)) + geom_boxplot() + ggtitle("Keyword + Pronoun Judgements")
ggplot(signalDF, aes(x=as.factor(rank), y=PSJudge)) + geom_boxplot() + xlab("rank") + ggtitle("Keyword + Pronoun Judgements")

# AVGSD 
ggplot(signalDF, aes(x=rank, y=avgSD, colour = groupName)) + geom_boxplot() + ggtitle("Keyword + Pronoun Judgements")


# by number of keywords selected
for (i in 1:nrow(signalDF)){
  keys <- unlist(strsplit(as.character(signalDF$keywords[i]), ', '))
  #print(length(keys))
  signalDF$keywordCount[i] <- length(keys)
}
ggplot(signalDF, aes(x=keywordCount, y=PSJudge, colour = rank)) + geom_point(size=5) + ggtitle("PSJudge")

ggplot(signalDF, aes(x=keywordCount, y=avgSD, colour = rank)) + geom_point(size=5) + ggtitle("avgSD")
ggplot(signalDF, aes(x=as.factor(keywordCount), y=avgSD, colour = groupName)) + geom_boxplot() + ggtitle("avgSD")

#
# with PSJUDGE vs pronouns
vip = ggplot(df[!is.na(df$PSJudge),], aes(x=nous, y=svmAccuracy)) + geom_point(size=5, aes(colour='nous')) + ggtitle('') + xlab('variable importance')
vip = vip + geom_point(size=5, aes(x=ils, y=svmAccuracy, colour = 'ils'))
vip = vip + geom_point(size=5, aes(x=nous, y=svmAccuracy, colour = 'nous'))
vip = vip + geom_point(size=5, aes(x=PSJudge, y=svmAccuracy, colour = 'PSJudge'))
vip = vip + geom_point(size=5, aes(x=pronounFrac, y=svmAccuracy, colour = 'pronounFrac'))
#vip = vip + geom_point(size=5, aes(x=avgSD, y=svmAccuracy, colour = 'avgSD'))
#vip = vip + geom_point(size=5, aes(x=avgEVC, y=svmAccuracy, colour = 'avgEVC'))
vip

###################
#   with toBe
##################
files <- c("modelOutput/modelPredictions-coco_3_cv_3_netAng_30_twc_15_tfidfNoPro_both_bin_10-RO610D.csv",
           "modelOutput/modelPredictions-coco_3_cv_3_netAng_30_twc_20_tfidfNoPro_both_bin_10-2YZAOL.csv"
           )

signalDF <- read.csv(files[1], stringsAsFactors = T)
for (i in 2:length(files)) {
  newDF <- read.csv(files[i], stringsAsFactors = T)
  signalDF <- rbind(signalDF, newDF)
  print(files[i])
  print(dim(newDF))
}
dim(signalDF)

ggplot(signalDF, aes(x=rank, y=toBeFrac, colour = groupName)) + geom_boxplot() + ggtitle("noun + 'to be' + adj Judgements")

###################
#   scores
##################

df$id <- as.numeric(row.names(df))
rs1 <- data.frame(id = df$id, Accuracy = df$svmAccuracy, Model = rep("SVM", nrow(df)))
rs2 <- data.frame(id = df$id, Accuracy = df$rfAccuracy, Model = rep("Random Forest", nrow(df)))
rsdf <- rbind(rs1, rs2)
rsdf$Accuracy <- rsdf$Accuracy * 100
accplot <- ggplot(rsdf[rsdf$id < 60 | rsdf$id > 66 ,], aes(x=id, y=Accuracy, colour = Model)) + geom_line() + ggtitle("Model Accuracy") + xlab('Run ID Number')
accplot <- accplot + geom_hline(yintercept = 84, linetype = "longdash") 
#accplot <- accplot + geom_vline(xintercept = 66, linetype = "longdash") 
accplot

###################
#   scores BY BINSIZE
##################

df$id <- as.numeric(row.names(df))
rs1 <- data.frame(id = df$id, binSize = as.factor(df$binSize), Accuracy = df$svmAccuracy, Model = rep("SVM", nrow(df)))
rs2 <- data.frame(id = df$id, binSize = as.factor(df$binSize), Accuracy = df$rfAccuracy, Model = rep("Random Forest", nrow(df)))
rsdf <- rbind(rs1, rs2)
rsdf$Accuracy <- rsdf$Accuracy * 100
# accplot <- ggplot(rsdf[rsdf$id > 66 ,], aes(x=id, y=Accuracy, colour = Model)) + geom_line() + ggtitle("Model Accuracy") + xlab('Run ID Number')
# accplot <- accplot + geom_hline(yintercept = 84, linetype = "longdash") 
# accplot
binplot <- ggplot(rsdf[rsdf$id > 66 ,], aes(x=binSize, y=Accuracy, colour = Model)) + geom_point(size=5) + ggtitle("Model Accuracy (new methods)") + xlab('Number of docs in each Bin') + ylim(55,100)
binplot <- binplot + geom_hline(yintercept = 84, linetype = "longdash") 
binplot

# with old methods
binplot <- ggplot(rsdf[rsdf$id < 66 ,], aes(x=binSize, y=Accuracy, colour = Model)) + geom_point(size=5) + ggtitle("Model Accuracy (old methods)") + xlab('Number of docs in each Bin') + ylim(55,100)
binplot <- binplot + geom_hline(yintercept = 84, linetype = "longdash") 
binplot

