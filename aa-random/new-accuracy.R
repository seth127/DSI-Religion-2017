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
    #RFscores[i] <- df$rank[i] >= (df$rfPred[i] - .5) & df$rank[i] <= (df$rfPred[i] + .5)
    #SVMscores[i] <- df$rank[i] >= (df$svmPred[i] - .5) & df$rank[i] <= (df$svmPred[i] + .5)
    RFscores[i] <- abs(df$rank[i] - df$rfPred[i]) <= 1 
    SVMscores[i] <- abs(df$rank[i] - df$svmPred[i]) <= 1 
    
  }
  scores <- c((sum(RFscores)/length(RFscores)), (sum(SVMscores)/length(SVMscores)))
  # return data frame
  if (returnDF == T) {
    print(scores)
    data.frame(df$groupId, RFscores, SVMscores)
  } else {
    print(scores)
  }
}

######
accuracy(idfDF)
#[1] 0.8468468 0.8468468
# on 0.5 #[1] 0.7387387 0.6036036

accuracy(npDF) # good!
#[1] 0.9279279 0.8468468
# on 0.5 #[1] 0.8828829 0.6846847

accuracy(npDFnew) 
#[1] 0.8135593 0.6949153
# on 0.5 #[1] 0.6610169 0.5508475 # bad

newGroups <- c("ISIS", "SeaShepherds", "Bahai","IntegralYoga")
accuracy(npDFnew[npDFnew$groupName %in% newGroups, ], returnDF=T)
# [1] 0.5714286 0.2857143
#           df.groupId  RFscores SVMscores
# 1 IntegralYoga_test0     TRUE     FALSE
# 2 IntegralYoga_test1     TRUE     FALSE
# 3 SeaShepherds_test0    FALSE     FALSE
# 4         ISIS_test1    FALSE     FALSE
# 5         ISIS_test0    FALSE     FALSE
# 6        Bahai_test1     TRUE      TRUE
# 7        Bahai_test0     TRUE      TRUE


# ONLY PERFORMATIVE
#accuracy(read.csv('./modelOutput/modelPredictions-coco_3_cv_3_netAng_30_sc_0-RCEVQJ.csv'))

# with a few new groups
perf1 <- read.csv('./modelOutput/modelPredictions-coco_3_cv_3_netAng_30_sc_0-RCEVQJ.csv')
accuracy(perf1,returnDF=T)
#[1] 0.4915254 0.5593220

perf2 <- read.csv('./modelOutput/modelPredictions-coco_3_cv_3_netAng_30_sc_0-H3Z53F.csv', stringsAsFactors = F)
accuracy(perf2,returnDF=T)

for (i in 1:nrow(perf2)) {
  perf2$groupName[i] <- unlist(strsplit(perf2$groupId[i], "_"))[1]
}

#randomForest
ggplot(perf2, aes(x=rank, y=rfPred, colour=groupName)) + geom_point()

#svm
ggplot(perf2, aes(x=rank, y=svmPred, colour=groupName)) + geom_point()

