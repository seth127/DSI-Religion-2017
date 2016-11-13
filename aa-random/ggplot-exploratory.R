setwd("~/Documents/DSI/Capstone/DSI-Religion-2017")
library(ggplot2)

signalDF <- read.csv('./pythonOutput/run1/cleanedOutput/coco_3_cv_3_netAng_30_sc_0/run0/masterOutput.csv', stringsAsFactors = F)

for (i in 1:nrow(signalDF)) {
  signalDF$groupName[i] <- unlist(strsplit(signalDF$groupId[i], "_"))[1]
}

#### COMPARE TO NEW TFIDF METHODS
newSignalDF <- read.csv('./modelOutput/modelPredictions-coco_3_cv_3_netAng_30_sc_0-NQRDMF.csv', stringsAsFactors = F)

for (i in 1:nrow(newSignalDF)) {
  newSignalDF$groupName[i] <- unlist(strsplit(newSignalDF$groupId[i], "_"))[1]
}

### RANKINGS
ranks <- data.frame(groupName=c('WBC', 'PastorAnderson', 'NaumanKhan', 'DorothyDay', 'JohnPiper', 'Shepherd',
                                'Rabbinic', 'Unitarian', 'MehrBaba','NawDawg','SeaShepherds',
                                'IntegralYoga','Bahai','ISIS'), 
                    groupRank=c(1,2,3,4,4,4,6,7,8,4,2,7,6,1))

ranks <- data.frame(groupName=c('WBC', 'PastorAnderson', 'NaumanKhan', 'DorothyDay', 'JohnPiper', 'Shepherd',
               'Rabbinic', 'Unitarian', 'MehrBaba','NawDawg','SeaShepherds','IntegralYoga','Bahai'), 
               groupRank=c(1,2,3,4,4,4,6,7,8,4,2,7,6))

# add rankings
DF <- merge(signalDF, ranks, by = "groupName")
nDF <- merge(newSignalDF, ranks, by = "groupName")
## RANKINGS discrete
DF$rankDiscrete <- as.factor(DF$groupRank)
nDF$rankDiscrete <- as.factor(nDF$groupRank)


### BY GROUP
ggplot(signalDF, aes(x=avgSD, y =avgEVC, colour = groupName)) + geom_point() + ggtitle("AdjAdv")

ggplot(signalDF, aes(x=avgSD, y =judgementFrac, colour = groupName)) + geom_point() + ggtitle("AdjAdv")


## RANKINGS discrete
ggplot(DF, aes(x=avgSD, y =judgementFrac, colour = rankDiscrete)) + geom_point() + ggtitle("AdjAdv")


## RANKINGS continuous
mid = 4
## zoomed in
ggplot(DF, aes(x=avgSD, y =avgEVC, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + ggtitle("AdjAdv")

## scaled to 0 and 1
ggplot(DF, aes(x=avgSD, y =avgEVC, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + xlim(0,1) + ylim(0,1) + ggtitle("AdjAdv")


##### OTHER VARIABLES
## perPos vs. perNeg ######DIFFERENCE!!!!
ggplot(DF, aes(x=perPos, y =perNeg, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + ggtitle("AdjAdv")

## Judgements ######DIFFERENCE!!!!
ggplot(DF, aes(x=judgementCount, y =judgementFrac, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + ggtitle("AdjAdv")

## Judgements by Group ######DIFFERENCE!!!!
ggplot(DF, aes(x=judgementFrac, y =judgementCount, colour = groupName)) + geom_point() + ggtitle("AdjAdv")

## Judgements by RANK ######Not really a difference...
ggplot(DF, aes(x=judgementFrac, y =judgementCount, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + ggtitle("AdjAdv")

#####RANK ON X AXIS
ggplot(DF, aes(x=perPos, y =groupRank)) + geom_point() + ggtitle("AdjAdv")
ggplot(DF, aes(x=judgementCount, y =groupRank)) + geom_point() + ggtitle("AdjAdv")
ggplot(DF, aes(x=judgementFrac, y =groupRank)) + geom_point() + ggtitle("AdjAdv")
ggplot(DF, aes(x=avgSD, y =groupRank)) + geom_point() + ggtitle("AdjAdv")
ggplot(DF, aes(x=avgEVC, y =groupRank)) + geom_point() + ggtitle("AdjAdv")

##########################################
#### COMPARE TO NEW TFIDF METHODS


### BY GROUP
ggplot(newSignalDF, aes(x=avgSD, y =avgEVC, colour = groupName)) + geom_point() + ggtitle("TF-IDF")

ggplot(newSignalDF, aes(x=avgSD, y =judgementFrac, colour = groupName)) + geom_point() + ggtitle("TF-IDF")



## RANKINGS discrete
nDF$rankDiscrete <- as.factor(nDF$groupRank)
ggplot(nDF, aes(x=avgSD, y =judgementFrac, colour = rankDiscrete)) + geom_point() + ggtitle("TF-IDF")



## RANKINGS continuous
mid = 4
## zoomed in
ggplot(nDF, aes(x=avgSD, y =avgEVC, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + ggtitle("TF-IDF")

## scaled to 0 and 1
ggplot(nDF, aes(x=avgSD, y =avgEVC, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + xlim(0,1) + ylim(0,1) + ggtitle("TF-IDF")


##### OTHER VARIABLES
## perPos vs. perNeg ######DIFFERENCE!!!!
ggplot(nDF, aes(x=perPos, y =perNeg, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + ggtitle("TF-IDF")

## Judgements ######DIFFERENCE!!!!
ggplot(nDF, aes(x=judgementCount, y =judgementFrac, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + ggtitle("TF-IDF")

## Judgements by Group ######DIFFERENCE!!!!
ggplot(nDF, aes(x=judgementFrac, y =judgementCount, colour = groupName)) + geom_point() + ggtitle("TF-IDF")

## Judgements by RANK ######Not really a difference...
ggplot(nDF, aes(x=judgementFrac, y =judgementCount, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + ggtitle("TF-IDF")

#####RANK ON X AXIS
ggplot(nDF, aes(x=perPos, y =groupRank)) + geom_point() + ggtitle("TF-IDF")
ggplot(nDF, aes(x=judgementCount, y =groupRank)) + geom_point() + ggtitle("TF-IDF")
ggplot(nDF, aes(x=judgementFrac, y =groupRank)) + geom_point() + ggtitle("TF-IDF")
ggplot(nDF, aes(x=avgSD, y =groupRank)) + geom_point() + ggtitle("TF-IDF")
ggplot(nDF, aes(x=avgEVC, y =groupRank)) + geom_point() + ggtitle("TF-IDF")

