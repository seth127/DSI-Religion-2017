setwd("~/Documents/DSI/Capstone/DSI-Religion-2017")
library(ggplot2)
library(gridExtra)


#### COMPARE NEW TFIDF METHODS
idfDF <- read.csv('./modelOutput/modelPredictions-coco_3_cv_3_netAng_30_sc_0-NQRDMF.csv', stringsAsFactors = F)

for (i in 1:nrow(idfDF)) {
  idfDF$groupName[i] <- unlist(strsplit(idfDF$groupId[i], "_"))[1]
}

#### NoPro TFIDF (pronouns removed)
# new groups included
npDFnew <- read.csv('./modelOutput/modelPredictions-coco_3_cv_3_netAng_30_sc_0-TBXLWF.csv', stringsAsFactors = F)
# just old groups
npDF <- read.csv('./modelOutput/modelPredictions-coco_3_cv_3_netAng_30_sc_0-159PNO.csv', stringsAsFactors = F)

for (i in 1:nrow(npDF)) {
  npDF$groupName[i] <- unlist(strsplit(npDF$groupId[i], "_"))[1]
}
for (i in 1:nrow(npDFnew)) {
  npDFnew$groupName[i] <- unlist(strsplit(npDFnew$groupId[i], "_"))[1]
}

##########
accuracy <- function(df, returnDF = F) {
  RFscores <- logical(nrow(df))
  SVMscores <- logical(nrow(df))
  for (i in 1:nrow(df)) {
    RFscores[i] <- df$rank[i] >= (df$rfPred[i] - .5) & df$rank[i] <= (df$rfPred[i] + .5)
    SVMscores[i] <- df$rank[i] >= (df$svmPred[i] - .5) & df$rank[i] <= (df$svmPred[i] + .5)
  }
  # return data frame
  if (returnDF == T) {
    data.frame(df$groupId, RFscores, SVMscores)
  } else {
    scores <- c((sum(RFscores)/length(RFscores)), (sum(SVMscores)/length(SVMscores)))
    scores
  }
}

######
accuracy(idfDF)
accuracy(npDF) # good!
accuracy(npDFnew) # bad

accuracy(npDFnew, returnDF=T) # bad