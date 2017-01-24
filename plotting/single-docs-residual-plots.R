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

# files <- c("modelOutput/logs/modelPredictions-coco_3_cv_3_netAng_30_twc_15_tfidf_pronounFrac_bin_10-Y6DDDX.csv",
#            "modelOutput/logs/modelPredictions-coco_3_cv_3_netAng_30_twc_20_tfidf_pronounFrac_bin_10-7J7LBO.csv",
#            "modelOutput/logs/modelPredictions-coco_3_cv_3_netAng_30_twc_20_tfidfNoPro_pronounFrac_bin_10-7B7C2E.csv",
#            "modelOutput/logs/modelPredictions-coco_3_cv_3_netAng_30_twc_30_tfidf_pronounFrac_bin_10-BZ2OB7.csv",
#            "modelOutput/logs/modelPredictions-coco_3_cv_3_netAng_30_twc_30_tfidfNoPro_pronounFrac_bin_10-XYVISL.csv"
# )

signalDF <- read.csv("modelOutputSingleDocs/logs/modelPredictions-coco_3_cv_3_netAng_30_twc_10_tfidfNoPro_pronoun_bin_1-OBUSSX.csv", stringsAsFactors = T)
# for (file in files) {
#   newDF <- read.csv(file, stringsAsFactors = T)
#   signalDF <- rbind(signalDF, newDF)
#   print(file)
#   print(dim(newDF))
# }
# dim(signalDF)

signalDF$rfResid <- signalDF$rfPred - signalDF$rank
signalDF$svmResid <- signalDF$svmPred - signalDF$rank

#######
# residuals
rp <- ggplot(signalDF, aes(x=rank)) + ggtitle("Residuals: Single Docs") + ylab("|ei|")
rp <- rp + geom_point(aes(x=rank-0.1, y=abs(rfResid), colour="RF"), size = 3)
rp <- rp + geom_point(aes(x=rank+0.1, y=abs(svmResid), colour="SVM"), size = 3)
rp <- rp + geom_hline(yintercept = 1, linetype = "longdash") 
rp

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

# rf vs svm
ggplot(signalDF, aes(x=abs(rfResid), y=abs(svmResid))) + ggtitle("SVM vs RF") + geom_point(aes(colour=groupName), size=5) + ylab("SVM") + xlab("Random Forest") + geom_hline(yintercept = 1, linetype = "longdash")  + geom_vline(xintercept = 1, linetype = "longdash") 
#by rank
d <- ggplot(signalDF, aes(x=abs(rfResid), y=abs(svmResid))) + ggtitle("SVM vs RF (2016 groups)") + geom_point(aes(colour=rank), size=5) + ylab("SVM") + xlab("Random Forest") + geom_hline(yintercept = 1, linetype = "longdash")  + geom_vline(xintercept = 1, linetype = "longdash") 
d + scale_color_gradient2("rank", low = "red", mid = "lightgrey", high = "blue", midpoint = 4.5)

########


