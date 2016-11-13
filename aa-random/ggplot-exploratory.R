setwd("~/Documents/DSI/Capstone/DSI-Religion-2017")
library(ggplot2)

aaDF <- read.csv('./pythonOutput/run1/cleanedOutput/coco_3_cv_3_netAng_30_sc_0/run0/masterOutput.csv', stringsAsFactors = F)

for (i in 1:nrow(aaDF)) {
  aaDF$groupName[i] <- unlist(strsplit(aaDF$groupId[i], "_"))[1]
}

#### COMPARE TO NEW TFIDF METHODS
idfDF <- read.csv('./modelOutput/signalOutputcoco_3_cv_3_netAng_30_sc_0-NQRDMF.csv', stringsAsFactors = F)

for (i in 1:nrow(idfDF)) {
  idfDF$groupName[i] <- unlist(strsplit(idfDF$groupId[i], "_"))[1]
}

#### NoPro TFIDF (pronouns removed)
# new groups included
npDF <- read.csv('./modelOutput/signalOutputcoco_3_cv_3_netAng_30_sc_0-TBXLWF.csv', stringsAsFactors = F)
# just old groups
#npDF <- read.csv('./modelOutput/modelPredictions-coco_3_cv_3_netAng_30_sc_0-159PNO.csv', stringsAsFactors = F)

for (i in 1:nrow(npDF)) {
  npDF$groupName[i] <- unlist(strsplit(npDF$groupId[i], "_"))[1]
}



### RANKINGS
ranks <- data.frame(groupName=c('WBC', 'PastorAnderson', 'NaumanKhan', 'DorothyDay', 'JohnPiper', 'Shepherd',
                                'Rabbinic', 'Unitarian', 'MehrBaba','NawDawg','SeaShepherds',
                                'IntegralYoga','Bahai','ISIS'), 
                    groupRank=c(1,2,3,4,4,4,6,7,8,4,2,7,6,1))


# add rankings
aaDF <- merge(aaDF, ranks, by = "groupName")
idfDF <- merge(idfDF, ranks, by = "groupName")
npDF <- merge(npDF, ranks, by = "groupName")
## RANKINGS discrete
aaDF$rankDiscrete <- as.factor(aaDF$groupRank)
idfDF$rankDiscrete <- as.factor(idfDF$groupRank)
npDF$rankDiscrete <- as.factor(npDF$groupRank)

#par(mfrow=c(1,2))
### BY GROUP
ggplot(aaDF, aes(x=avgSD, y =avgEVC, colour = groupName)) + geom_point() + ggtitle("AdjAdv")
ggplot(idfDF, aes(x=avgSD, y =avgEVC, colour = groupName)) + geom_point() + ggtitle("TF-IDF")
ggplot(npDF, aes(x=avgSD, y =avgEVC, colour = groupName)) + geom_point() + ggtitle("TF-IDF")
ggplot(npDF[npDF$groupName=='ISIS' | npDF$groupName=='WBC',], aes(x=avgSD, y =avgEVC, colour = groupName)) + geom_point() + ggtitle("ISIS vs. WBC")

ggplot(aaDF, aes(x=avgSD, y =judgementFrac, colour = groupName)) + geom_point() + ggtitle("AdjAdv")
ggplot(idfDF, aes(x=avgSD, y =judgementFrac, colour = groupName)) + geom_point() + ggtitle("TF-IDF")
ggplot(npDF, aes(x=avgSD, y =judgementFrac, colour = groupName)) + geom_point() + ggtitle("TF-IDF")

## RANKINGS discrete
ggplot(aaDF, aes(x=avgSD, y =judgementFrac, colour = rankDiscrete)) + geom_point() + ggtitle("AdjAdv")
ggplot(idfDF, aes(x=avgSD, y =judgementFrac, colour = rankDiscrete)) + geom_point() + ggtitle("TF-IDF")
ggplot(npDF, aes(x=avgSD, y =judgementFrac, colour = rankDiscrete)) + geom_point() + ggtitle("TF-IDF")


## RANKINGS continuous
mid = 4
## zoomed in
ggplot(aaDF, aes(x=avgSD, y =avgEVC, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + ggtitle("AdjAdv")
ggplot(idfDF, aes(x=avgSD, y =avgEVC, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + ggtitle("TF-IDF")
ggplot(npDF, aes(x=avgSD, y =avgEVC, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + ggtitle("TF-IDF")

## scaled to 0 and 1
ggplot(aaDF, aes(x=avgSD, y =avgEVC, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + xlim(0,1) + ylim(0,1) + ggtitle("AdjAdv")


##### OTHER VARIABLES
## perPos vs. perNeg ######DIFFERENCE!!!!
ggplot(aaDF, aes(x=perPos, y =perNeg, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + ggtitle("AdjAdv")
#PROBLEM!!! #ggplot(idfDF, aes(x=perPos, y =perNeg, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + ggtitle("TF-IDF")

## Judgements ######DIFFERENCE!!!!
ggplot(aaDF, aes(x=judgementCount, y =judgementFrac, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + ggtitle("AdjAdv")
ggplot(idfDF, aes(x=judgementCount, y =judgementFrac, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + ggtitle("TF-IDF")

## Judgements by Group ######DIFFERENCE!!!!
ggplot(aaDF, aes(x=judgementFrac, y =judgementCount, colour = groupName)) + geom_point() + ggtitle("AdjAdv")
ggplot(idfDF, aes(x=judgementFrac, y =judgementCount, colour = groupName)) + geom_point() + ggtitle("TF-IDF")

## Judgements by RANK ######Not really a difference...
ggplot(aaDF, aes(x=judgementFrac, y =judgementCount, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + ggtitle("AdjAdv")
ggplot(idfDF, aes(x=judgementFrac, y =judgementCount, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + ggtitle("TF-IDF")


##### BOXPLOTS
### ADJADV
ggplot(aaDF, aes(x =rankDiscrete, y=perPos)) + geom_boxplot() + ggtitle("AdjAdv")
ggplot(aaDF, aes(x =rankDiscrete, y=judgementCount)) + geom_boxplot() + ggtitle("AdjAdv")
ggplot(aaDF, aes(x =rankDiscrete, y=judgementFrac)) + geom_boxplot() + ggtitle("AdjAdv")
ggplot(aaDF, aes(x =rankDiscrete, y=avgSD)) + geom_boxplot() + ggtitle("AdjAdv")
ggplot(aaDF, aes(x =rankDiscrete, y=avgEVC)) + geom_boxplot() + ggtitle("AdjAdv")

### TFIDF
ggplot(idfDF, aes(x =rankDiscrete, y=perPos)) + geom_boxplot() + ggtitle("TF-IDF")
ggplot(idfDF, aes(x =rankDiscrete, y=judgementCount)) + geom_boxplot() + ggtitle("TF-IDF")
ggplot(idfDF, aes(x =rankDiscrete, y=judgementFrac)) + geom_boxplot() + ggtitle("TF-IDF")
ggplot(idfDF, aes(x =rankDiscrete, y=avgSD)) + geom_boxplot() + ggtitle("TF-IDF")
ggplot(idfDF, aes(x =rankDiscrete, y=avgEVC)) + geom_boxplot() + ggtitle("TF-IDF")

### NoPro
ggplot(npDF, aes(x =rankDiscrete, y=avgSD)) + geom_boxplot() + ggtitle("NoPro")
ggplot(npDF, aes(x =rankDiscrete, y=avgEVC)) + geom_boxplot() + ggtitle("NoPro")
