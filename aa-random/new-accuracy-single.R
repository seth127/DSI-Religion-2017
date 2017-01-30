setwd("~/Desktop/github/DSI-Religion-2017/modelOutputSingleDocs/logs")
library(ggplot2)
library(gridExtra)

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

##### pronoun judgments
# new groups included
pn10 <- read.csv('./modelOutput/modelPredictions-coco_3_cv_3_netAng_30_twc_10_tfidfNoPro_pronoun_bin_10-9VXA7R.csv', stringsAsFactors = F)
# just old groups
pn20 <- read.csv('./modelOutput/modelPredictions-coco_3_cv_3_netAng_30_twc_20_tfidfNoPro_pronoun_bin_10-PCZKXX.csv', stringsAsFactors = F)

for (i in 1:nrow(pn10)) {
  pn10$groupName[i] <- unlist(strsplit(pn10$groupId[i], "_"))[1]
}
for (i in 1:nrow(pn20)) {
  pn20$groupName[i] <- unlist(strsplit(pn20$groupId[i], "_"))[1]
}

##

accuracy(pn10)
accuracy(pn20)

###########
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
single_runs <- read.csv('SingleDocRuns2_7.csv.csv')
full_runs<- read.csv('All SingleDoc Runs.csv')
accuracy(single_runs, returnDF = T)
#randomForest
ggplot(full_runs, aes(x=as.factor(rank), y=(abs(scaledSvm-rank)))) + geom_boxplot()

#svm
ggplot(full_runs, aes(x=as.factor(rank), y=scaledSvm, colour=rank)) + geom_boxplot()

mean(full_runs$svmPred)

scale_pred <- function(pred, scale = 1.8) {
  miss <- pred - mean(full_runs$svmPred)
  scaled_miss <- miss * scale
  return(mean(full_runs$svmPred) + scaled_miss)
}

full_runs$scaledSvm <- scale_pred(full_runs$svmPred, scale = 1.8)
