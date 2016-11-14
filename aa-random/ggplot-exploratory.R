setwd("~/Documents/DSI/Capstone/DSI-Religion-2017")
library(ggplot2)
library(gridExtra)

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
npDFnew <- read.csv('./modelOutput/signalOutputcoco_3_cv_3_netAng_30_sc_0-TBXLWF.csv', stringsAsFactors = F)
# just old groups
npDF <- read.csv('./modelOutput/signalOutputcoco_3_cv_3_netAng_30_sc_0-159PNO.csv', stringsAsFactors = F)

for (i in 1:nrow(npDF)) {
  npDF$groupName[i] <- unlist(strsplit(npDF$groupId[i], "_"))[1]
}
for (i in 1:nrow(npDFnew)) {
  npDFnew$groupName[i] <- unlist(strsplit(npDFnew$groupId[i], "_"))[1]
}



### RANKINGS
ranks <- data.frame(groupName=c('WBC', 'PastorAnderson', 'NaumanKhan', 'DorothyDay', 'JohnPiper', 'Shepherd',
                                'Rabbinic', 'Unitarian', 'MehrBaba','SeaShepherds',
                                'IntegralYoga','Bahai','ISIS'), 
                    groupRank=c(1,2,3,4,4,4,6,7,8,2,7,6,1))


# add rankings
aaDF <- merge(aaDF, ranks, by = "groupName")
idfDF <- merge(idfDF, ranks, by = "groupName")
npDF <- merge(npDF, ranks, by = "groupName")
npDFnew <- merge(npDFnew, ranks, by = "groupName")
## RANKINGS discrete
aaDF$rankDiscrete <- as.factor(aaDF$groupRank)
idfDF$rankDiscrete <- as.factor(idfDF$groupRank)
npDF$rankDiscrete <- as.factor(npDF$groupRank)
npDFnew$rankDiscrete <- as.factor(npDFnew$groupRank)


#par(mfrow=c(1,2))
### BY GROUP
g1 <- ggplot(aaDF, aes(x=avgSD, y =avgEVC, colour = groupName)) + geom_point() + ggtitle("AdjAdv") + theme(legend.position="none") + xlim(.54,.85) + ylim(.38,.93)
ggplot(idfDF, aes(x=avgSD, y =avgEVC, colour = groupName)) + geom_point() + ggtitle("TF-IDF") + theme(legend.position="none") + xlim(.54,.85) + ylim(.38,.93)
g2 <- ggplot(npDF, aes(x=avgSD, y =avgEVC, colour = groupName)) + geom_point() + ggtitle("TF-IDF NoPro") + theme(legend.position="none") + xlim(.54,.85) + ylim(.38,.93)
grid.arrange(g1,g2,ncol=2)

## ISIS vs. WBC vs. 
ggplot(npDFnew[npDFnew$groupName %in% c('ISIS','WBC'),], aes(x=avgSD, y =avgEVC, colour = groupName)) + geom_point() + ggtitle("ISIS vs. WBC")
g1 <- ggplot(npDFnew[npDFnew$groupName %in% c('ISIS','WBC','Unitarian'),], aes(x=avgSD, y =avgEVC, colour = groupName)) + geom_point() + ggtitle("ISIS vs. WBC vs. Unitarian")
g2 <- ggplot(npDFnew[npDFnew$groupName %in% c('ISIS','WBC','DorothyDay'),], aes(x=avgSD, y =avgEVC, colour = groupName)) + geom_point() + ggtitle("ISIS vs. WBC vs. Dorothy Day")
grid.arrange(g1,g2,ncol=2)

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
g1 <- ggplot(aaDF, aes(x=avgSD, y =avgEVC, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + ggtitle("AdjAdv") + theme(legend.position="none") + xlim(.54,.85) + ylim(.38,.93)
ggplot(idfDF, aes(x=avgSD, y =avgEVC, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + ggtitle("TF-IDF") + theme(legend.position="none") + xlim(.54,.85) + ylim(.38,.93)
g2 <- ggplot(npDF, aes(x=avgSD, y =avgEVC, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + ggtitle("TF-IDF NoPro") + theme(legend.position="none") + xlim(.54,.85) + ylim(.38,.93)
grid.arrange(g1,g2,ncol=2)

## scaled to 0 and 1
ggplot(aaDF, aes(x=avgSD, y =avgEVC, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + xlim(0,1) + ylim(0,1) + ggtitle("AdjAdv")


##### OTHER VARIABLES
## perPos vs. perNeg ######DIFFERENCE!!!!
g1 <- ggplot(aaDF, aes(x=perPos, y =perNeg, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + ggtitle("Sentiment") + theme(legend.position="none") 
#PROBLEM!!! #ggplot(idfDF, aes(x=perPos, y =perNeg, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + ggtitle("TF-IDF")

## Judgements by RANK  ######DIFFERENCE!!!!
g2 <- ggplot(aaDF, aes(x=judgementCount, y =judgementFrac, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + ggtitle("Judgements") + theme(legend.position="none") 
ggplot(idfDF, aes(x=judgementCount, y =judgementFrac, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + ggtitle("TF-IDF")
grid.arrange(g1,g2,ncol=2)

## Judgements by Group ######DIFFERENCE!!!!
ggplot(aaDF, aes(x=judgementFrac, y =judgementCount, colour = groupName)) + geom_point() + ggtitle("AdjAdv")
ggplot(idfDF, aes(x=judgementFrac, y =judgementCount, colour = groupName)) + geom_point() + ggtitle("TF-IDF")


##### BOXPLOTS
aa <- aaDF
aa$Method <- "AdjAdv"
idf <- subset(idfDF, select = -c(keywords))
idf$Method <- "IDF raw"
np <- subset(npDF, select = -c(keywords))
np$Method <- "IDF NoPro"

master <- rbind(aa,idf,np)

ggplot(master, aes(x =rankDiscrete, y=avgSD, colour=Method)) + geom_boxplot() + ggtitle("Semantic Density") + xlab("")
ggplot(master[master$Method != "IDF raw",], aes(x =rankDiscrete, y=avgSD, colour=Method)) + geom_boxplot() + ggtitle("Semantic Density") + xlab("")


### ADJADV
g1 <- ggplot(aaDF, aes(x =rankDiscrete, y=perPos)) + geom_boxplot() + ggtitle("Sentiment") + xlab("")
#ggplot(aaDF, aes(x =rankDiscrete, y=judgementCount)) + geom_boxplot() + ggtitle("Judgements") + xlab("")
g2 <- ggplot(aaDF, aes(x =rankDiscrete, y=judgementFrac)) + geom_boxplot() + ggtitle("Judgements") + xlab("")
g3 <- ggplot(aaDF, aes(x =rankDiscrete, y=avgSD)) + geom_boxplot() + ggtitle("Semantic Density") + xlab("")
g4 <- ggplot(aaDF, aes(x =rankDiscrete, y=avgEVC)) + geom_boxplot() + ggtitle("EV Centrality") + xlab("")
grid.arrange(g1,g2,g3,g4,ncol=2)

### TFIDF
ggplot(idfDF, aes(x =rankDiscrete, y=perPos)) + geom_boxplot() + ggtitle("TF-IDF")
ggplot(idfDF, aes(x =rankDiscrete, y=judgementCount)) + geom_boxplot() + ggtitle("TF-IDF")
ggplot(idfDF, aes(x =rankDiscrete, y=judgementFrac)) + geom_boxplot() + ggtitle("TF-IDF")
ggplot(idfDF, aes(x =rankDiscrete, y=avgSD)) + geom_boxplot() + ggtitle("TF-IDF")
ggplot(idfDF, aes(x =rankDiscrete, y=avgEVC)) + geom_boxplot() + ggtitle("TF-IDF")

### NoPro
ggplot(npDF, aes(x =rankDiscrete, y=avgSD)) + geom_boxplot() + ggtitle("NoPro")
ggplot(npDF, aes(x =rankDiscrete, y=avgEVC)) + geom_boxplot() + ggtitle("NoPro")
