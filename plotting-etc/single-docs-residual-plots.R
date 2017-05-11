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

statsDF <- read.csv("modelOutputSingleDocs/modelStats.csv", stringsAsFactors = F)
#only the ones with 10 keywords
statsDF <- statsDF[statsDF$targetWordCount==10,]
# get the ids
ids <- statsDF$runID

# here's one that had 67% accuracy
#signalDF <- read.csv("modelOutputSingleDocs/logs/modelPredictions-coco_3_cv_3_netAng_30_twc_10_tfidfNoPro_pronoun_bin_1-OBUSSX.csv", stringsAsFactors = T)

# get a sample
numberToSample <- 1
sampleIDs <- sample(ids,numberToSample)
##
# get first one
signalDF <- read.csv(paste("modelOutputSingleDocs/logs/modelPredictions-coco_3_cv_3_netAng_30_twc_10_tfidfNoPro_pronoun_bin_1-", sampleIDs[1], ".csv", sep = ""), stringsAsFactors = T)
# get the rest
for (i in 2:numberToSample) {
  newDF <- read.csv(paste("modelOutputSingleDocs/logs/modelPredictions-coco_3_cv_3_netAng_30_twc_10_tfidfNoPro_pronoun_bin_1-", sampleIDs[i], ".csv", sep = ""), stringsAsFactors = T)
  signalDF <- rbind(signalDF, newDF)
  print(sampleIDs[i])
  print(dim(newDF))
}
dim(signalDF)
# get stats on our sample
sampleStatsDF <- statsDF[statsDF$runID %in% sampleIDs,]

signalDF$rfResid <- signalDF$rfPred - signalDF$rank
signalDF$svmResid <- signalDF$svmPred - signalDF$rank
signalDF$rfClassResid <- signalDF$rfClassPred - signalDF$rank
signalDF$svmClassResid <- signalDF$svmClassPred - signalDF$rank


#######
# residuals
titlestring <- paste("Residuals, sample of",numberToSample, "runs\nRF accuracy:", 
                     paste(round(mean(sampleStatsDF$rfAccuracy),2)*100, "%", sep=""),
                     "::: SVM accuracy:",
                     paste(round(mean(sampleStatsDF$svmAccuracy),2)*100, "%", sep=""))
rp <- ggplot(signalDF, aes(x=rank)) + ggtitle(titlestring) + ylab("|ei|")
rp <- rp + geom_point(aes(x=rank-0.1, y=abs(rfResid), colour="RF"), size = 3)
rp <- rp + geom_point(aes(x=rank+0.1, y=abs(svmResid), colour="SVM"), size = 3)
rp <- rp + geom_hline(yintercept = 1, linetype = "longdash") 
rp

# rf vs svm, by rank
d <- ggplot(signalDF, aes(x=abs(rfResid), y=abs(svmResid))) + ggtitle("SVM vs RF (Single Docs)") + geom_point(aes(colour=rank), size=5) + ylab("SVM") + xlab("Random Forest") + geom_hline(yintercept = 1, linetype = "longdash")  + geom_vline(xintercept = 1, linetype = "longdash") 
d + scale_color_gradient2("rank", low = "red", mid = "lightgrey", high = "blue", midpoint = 4.5)


###################
### EVERYTHING ####
###################
sampleIDs <- sample(ids,length(ids))
##
# get first one
signalDF <- read.csv(paste("modelOutputSingleDocs/logs/modelPredictions-coco_3_cv_3_netAng_30_twc_10_tfidfNoPro_pronoun_bin_1-", sampleIDs[1], ".csv", sep = ""), stringsAsFactors = T)
# get the rest
for (i in 2:numberToSample) {
  newDF <- read.csv(paste("modelOutputSingleDocs/logs/modelPredictions-coco_3_cv_3_netAng_30_twc_10_tfidfNoPro_pronoun_bin_1-", sampleIDs[i], ".csv", sep = ""), stringsAsFactors = T)
  signalDF <- rbind(signalDF, newDF)
  print(sampleIDs[i])
  print(dim(newDF))
}

# make boxplot DF (manual wide to long)
bprf <- data.frame(rank = signalDF$rank,
                   resid = signalDF$rfResid,
                   model = rep("RF",nrow(signalDF)))
bpsvm <- data.frame(rank = signalDF$rank,
                   resid = signalDF$svmResid,
                   model = rep("SVM",nrow(signalDF)))
bpDF <- rbind(bprf,bpsvm)
# BOXPLOT
titlestring <- paste("Residuals, sample of",nrow(statsDF), "runs\nRF accuracy:", 
                     paste(round(mean(statsDF$rfAccuracy),2)*100, "%", sep=""),
                     "::: SVM accuracy:",
                     paste(round(mean(statsDF$svmAccuracy),2)*100, "%", sep=""))
rph <- ggplot(bpDF, aes(x=rank)) + ggtitle(titlestring) + ylab("|ei|")
rph <- rph + geom_boxplot(aes(x=as.factor(rank), y=abs(resid), colour=model))
#rph <- rph + geom_boxplot(aes(x=as.factor(rank), y=abs(svmResid)))
rph <- rph + geom_hline(yintercept = 1, linetype = "longdash") 
rph

#SVM
titlestring <- paste("Residuals, sample of",numberToSample, "runs\nSVM accuracy:", 
                     paste(round(mean(sampleStatsDF$svmAccuracy),2)*100, "%", sep=""))
rph <- ggplot(signalDF, aes(x=rank)) + ggtitle(titlestring) + ylab("|ei|")
#rph <- rph + geom_boxplot(aes(x=as.factor(rank), y=abs(rfResid), colour="RF"))
rph <- rph + geom_boxplot(aes(x=as.factor(rank), y=abs(svmResid)))
rph <- rph + geom_hline(yintercept = 1, linetype = "longdash") 
rph

#RF
titlestring <- paste("Residuals, sample of",numberToSample, "runs\nRF accuracy:", 
                     paste(round(mean(statsDF$rfAccuracy),2)*100, "%", sep=""))
rph <- ggplot(signalDF, aes(x=rank)) + ggtitle(titlestring) + ylab("|ei|")
rph <- rph + geom_boxplot(aes(x=as.factor(rank), y=abs(rfResid)))
#rph <- rph + geom_boxplot(aes(x=as.factor(rank), y=abs(svmResid), colour="SVM"))
rph <- rph + geom_hline(yintercept = 1, linetype = "longdash") 
rph

#######

# rank vs. prediction
rp <- ggplot(signalDF, aes(x=rank)) + ggtitle("Predictions: Single Docs") + ylab("Prediction")
rp <- rp + geom_point(aes(x=rank-0.1, y=abs(rfPred), colour="RF"), size = 3)
rp <- rp + geom_point(aes(x=rank+0.1, y=abs(svmPred), colour="SVM"), size = 3)
#rp <- rp + geom_hline(yintercept = 1, linetype = "longdash") 
rp


# svm
rp <- ggplot(signalDF, aes(x=rank)) + ggtitle("SVM Residuals)") + ylab("|ei|")
rp <- rp + geom_jitter(aes(y=abs(svmResid)), size = 5)
rp <- rp + geom_hline(yintercept = 1, linetype = "longdash") 
rp
# random forest 
rp <- ggplot(signalDF, aes(x=rank)) + ggtitle("RF Residuals") + ylab("|ei|")
rp <- rp + geom_jitter(aes(y=abs(rfResid)), size = 2)
rp <- rp + geom_hline(yintercept = 1, linetype = "longdash") 
rp


########


