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

# files <- c("modelOutput/modelPredictions-coco_3_cv_3_netAng_30_twc_15_tfidf_pronounFrac_bin_10-Y6DDDX.csv",
#            "modelOutput/modelPredictions-coco_3_cv_3_netAng_30_twc_20_tfidf_pronounFrac_bin_10-7J7LBO.csv",
#            "modelOutput/modelPredictions-coco_3_cv_3_netAng_30_twc_20_tfidfNoPro_pronounFrac_bin_10-7B7C2E.csv",
#            "modelOutput/modelPredictions-coco_3_cv_3_netAng_30_twc_30_tfidf_pronounFrac_bin_10-BZ2OB7.csv",
#            "modelOutput/modelPredictions-coco_3_cv_3_netAng_30_twc_30_tfidfNoPro_pronounFrac_bin_10-XYVISL.csv"
# )

#signalDF <- read.csv("modelOutput/logs/RFTESTING-98.csv", stringsAsFactors = T)


#signalDF <- read.csv("modelOutput/RFTESTING-output.csv", stringsAsFactors = T)
# for (file in files) {
#   newDF <- read.csv(file, stringsAsFactors = T)
#   signalDF <- rbind(signalDF, newDF)
#   print(file)
#   print(dim(newDF))
# }
# dim(signalDF)

signalDF <- read.csv("modelOutput/RFTESTING-output.csv", stringsAsFactors = T)
#signalDF <- read.csv("modelOutput/logs/RFTESTING-new-sample.csv", stringsAsFactors = T)

signalDF$rfResid <- signalDF$rfPred - signalDF$rank
signalDF$rfClassResid <- signalDF$rfClassPred - signalDF$rank
signalDF$svmResid <- signalDF$svmPred - signalDF$rank
signalDF$svmClassResid <- signalDF$svmClassPred - signalDF$rank


#######
# NEW GROUPS residuals
rp <- ggplot(signalDF, aes(x=rank)) + ggtitle("Residuals (NEW groups)") + ylab("|ei|")
rp <- rp + geom_point(aes(x=rank-0.1, y=abs(rfResid), colour="RF"), size = 3)
rp <- rp + geom_point(aes(x=rank-0.2, y=abs(rfClassResid), colour="RFClass"), size = 3)
rp <- rp + geom_point(aes(x=rank+0.1, y=abs(svmResid), colour="SVM"), size = 3)
rp <- rp + geom_point(aes(x=rank+0.2, y=abs(svmClassResid), colour="SVMClass"), size = 3)
rp <- rp + geom_hline(yintercept = 1, linetype = "longdash") 
rp

# ONLY OLD GROUPS
oldDF <- read.csv("modelOutput/logs/RFTESTING-98.csv", stringsAsFactors = T)
oldDF$rfResid <- oldDF$rfPred - oldDF$rank
oldDF$rfClassResid <- oldDF$rfClassPred - oldDF$rank
oldDF$svmResid <- oldDF$svmPred - oldDF$rank

# 
op <- ggplot(oldDF, aes(x=rank)) + ggtitle("Residuals (2016 groups)") + ylab("|ei|")
op <- op + geom_point(aes(x=rank-0.1, y=abs(rfResid), colour="RF"), size = 3)
op <- op + geom_point(aes(x=rank, y=abs(rfClassResid), colour="RFClass"), size = 3)
op <- op + geom_point(aes(x=rank+0.1, y=abs(svmResid), colour="SVM"), size = 3)
op <- op + geom_hline(yintercept = 1, linetype = "longdash") 
op

### BACK TO NEW GROUPS
# svm by group
rp <- ggplot(signalDF, aes(x=rank)) + ggtitle("SVM Residuals (NEW groups)") + ylab("|ei|")
rp <- rp + geom_point(aes(y=abs(svmResid), colour=groupName), size = 5)
rp <- rp + geom_hline(yintercept = 1, linetype = "longdash") 
rp
# random forest by group
rp <- ggplot(signalDF, aes(x=rank)) + ggtitle("RF Residuals (NEW groups)") + ylab("|ei|")
rp <- rp + geom_point(aes(y=abs(rfResid), colour=groupName), size = 5)
rp <- rp + geom_hline(yintercept = 1, linetype = "longdash") 
rp
# random forest CLASS by group
rp <- ggplot(signalDF, aes(x=rank)) + ggtitle("RF Class Residuals (NEW groups)") + ylab("|ei|")
rp <- rp + geom_point(aes(y=abs(rfClassResid), colour=groupName), size = 5)
rp <- rp + geom_hline(yintercept = 1, linetype = "longdash") 
rp

# rf vs svm
ggplot(signalDF, aes(x=abs(rfResid), y=abs(svmResid))) + ggtitle("SVM vs RF (NEW groups)") + geom_point(aes(colour=groupName), size=5) + ylab("SVM") + xlab("Random Forest") + geom_hline(yintercept = 1, linetype = "longdash")  + geom_vline(xintercept = 1, linetype = "longdash") 
#by rank
d <- ggplot(signalDF, aes(x=abs(rfResid), y=abs(svmResid))) + ggtitle("SVM vs RF (NEW groups)") + geom_point(aes(colour=rank), size=5) + ylab("SVM") + xlab("Random Forest") + geom_hline(yintercept = 1, linetype = "longdash")  + geom_vline(xintercept = 1, linetype = "longdash") 
d + scale_color_gradient2("rank", low = "red", mid = "lightgrey", high = "blue", midpoint = 4.5)

# misses
ggplot(signalDF[abs(signalDF$svmResid)>=1 & abs(signalDF$rfResid)>=1,], aes(x=abs(rfResid), y=abs(svmResid))) + ggtitle("BOTH MODEL MISSES (2016 groups)") + geom_point(aes(colour=groupName), size=5) + ylab("SVM") + xlab("Random Forest")


# rf vs rfClass
ggplot(signalDF, aes(x=abs(rfResid), y=abs(rfClassResid))) + ggtitle("RF vs RF Class (NEW groups)") + geom_point(aes(colour=groupName), size=5) + ylab("RF Class") + xlab("Random Forest") + geom_hline(yintercept = 1, linetype = "longdash")  + geom_vline(xintercept = 1, linetype = "longdash") 


# rf vs svm CLASSIFICATION
ggplot(signalDF, aes(x=abs(rfClassResid), y=abs(svmClassResid))) + ggtitle("SVM vs RF CLASSIFICATION") + geom_jitter(aes(colour=groupName), size=5, width=.2, height=.2) + ylab("SVM") + xlab("Random Forest") + geom_hline(yintercept = 1, linetype = "longdash")  + geom_vline(xintercept = 1, linetype = "longdash") 
#by rank
d <- ggplot(signalDF, aes(x=abs(rfClassResid), y=abs(svmClassResid))) + ggtitle("SVM vs RF (NEW groups)") + geom_jitter(aes(colour=rank), size=5, width=.2, height=.2) + ylab("SVM") + xlab("Random Forest") + geom_hline(yintercept = 1, linetype = "longdash")  + geom_vline(xintercept = 1, linetype = "longdash") 
d + scale_color_gradient2("rank", low = "red", mid = "lightgrey", high = "blue", midpoint = 4.5)

# misses
ggplot(signalDF[abs(signalDF$svmResid)>=1 & abs(signalDF$rfResid)>=1,], aes(x=abs(rfResid), y=abs(svmResid))) + ggtitle("BOTH MODEL MISSES (2016 groups)") + geom_point(aes(colour=groupName), size=5) + ylab("SVM") + xlab("Random Forest")
