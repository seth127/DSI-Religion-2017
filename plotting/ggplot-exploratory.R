setwd("~/Documents/DSI/Capstone/DSI-Religion-2017")
library(ggplot2)
library(gridExtra)

### RANKINGS
ranks <- data.frame(groupName=c('WBC', 'PastorAnderson', 'NaumanKhan', 'DorothyDay', 'JohnPiper', 'Shepherd',
                                'Rabbinic', 'Unitarian', 'MehrBaba','SeaShepherds',
                                'IntegralYoga','Bahai','ISIS'), 
                    groupRank=c(1,2,3,4,4,4,6,7,8,2,7,6,1))

### PLOTIFY THE DATAFRAME
plotify <- function(df) {
  df$groupId <- as.character(df$groupId)
  for (i in 1:nrow(df)) {
    df$groupName[i] <- unlist(strsplit(df$groupId[i], "_"))[1]
  }
  df <- merge(df, ranks, by = "groupName")
  df$rankDiscrete <- as.factor(df$groupRank)
  df
}

### THE 2016 group data (just a random sample from their optimal model runs)
aaDF <- plotify(read.csv('./pythonOutput/run1/cleanedOutput/coco_3_cv_3_netAng_30_sc_0/run0/masterOutput.csv'))

#### COMPARE TO NEW TFIDF METHODS
idfDF <- plotify(read.csv('./modelOutput/signalOutputcoco_3_cv_3_netAng_30_sc_0-NQRDMF.csv'))

#### NoPro TFIDF (pronouns removed)
# new groups included
npDFnew <- plotify(read.csv('./modelOutput/signalOutputcoco_3_cv_3_netAng_30_sc_0-TBXLWF.csv'))
# just old groups
npDF <- plotify(read.csv('./modelOutput/signalOutputcoco_3_cv_3_netAng_30_sc_0-159PNO.csv'))

#### with pronoun judgements
pn10 <- plotify(read.csv('modelOutput/signalOutput-coco_3_cv_3_netAng_30_twc_10_tfidfNoPro_pronoun_bin_10-9VXA7R.csv'))

pn20 <- plotify(read.csv('modelOutput/signalOutput-coco_3_cv_3_netAng_30_twc_20_tfidfNoPro_pronoun_bin_10-PCZKXX.csv'))


######### PLOTTING


#par(mfrow=c(1,2))
### BY GROUP
g1 <- ggplot(pn10, aes(x=avgSD, y =avgEVC, colour = groupName)) + geom_point() + ggtitle("10 keywords") + theme(legend.position="none") + xlim(.54,.85) + ylim(.38,.93)
g2 <- ggplot(pn20, aes(x=avgSD, y =avgEVC, colour = groupName)) + geom_point() + ggtitle("20 keywords") + theme(legend.position="none") + xlim(.54,.85) + ylim(.38,.93)
grid.arrange(g1,g2,ncol=2)

# ## ISIS vs. WBC vs. 
# ggplot(npDFnew[npDFnew$groupName %in% c('ISIS','WBC'),], aes(x=avgSD, y =avgEVC, colour = groupName)) + geom_point() + ggtitle("ISIS vs. WBC")
# g1 <- ggplot(npDFnew[npDFnew$groupName %in% c('ISIS','WBC','Unitarian'),], aes(x=avgSD, y =avgEVC, colour = groupName)) + geom_point() + ggtitle("ISIS vs. WBC vs. Unitarian")
# g2 <- ggplot(npDFnew[npDFnew$groupName %in% c('ISIS','WBC','DorothyDay'),], aes(x=avgSD, y =avgEVC, colour = groupName)) + geom_point() + ggtitle("ISIS vs. WBC vs. Dorothy Day")
# grid.arrange(g1,g2,ncol=2)

###
g1 <- ggplot(pn10, aes(x=avgSD, y =judgementFrac, colour = groupName)) + geom_point() + ggtitle("10 keywords") + theme(legend.position="none") + xlim(.54,.85) + ylim(.38,.93)
g2 <- ggplot(pn20, aes(x=avgSD, y =judgementFrac, colour = groupName)) + geom_point() + ggtitle("20 keywords") + theme(legend.position="none") + xlim(.54,.85) + ylim(.38,.93)
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
g1 <- ggplot(pn10, aes(x=avgSD, y =avgEVC, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + ggtitle("10") + theme(legend.position="none") + xlim(.54,.85) + ylim(.38,.93)
g2 <- ggplot(pn20, aes(x=avgSD, y =avgEVC, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + ggtitle("20") + theme(legend.position="none") + xlim(.54,.85) + ylim(.38,.93)
grid.arrange(g1,g2,ncol=2)

## scaled to 0 and 1
ggplot(aaDF, aes(x=avgSD, y =avgEVC, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + xlim(0,1) + ylim(0,1) + ggtitle("AdjAdv")


##### OTHER VARIABLES
## perPos vs. perNeg ######DIFFERENCE!!!!
g1 <- ggplot(pn10, aes(x=perPos, y =perNeg, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + ggtitle("Sentiment") + theme(legend.position="none") 
#PROBLEM!!! #ggplot(idfDF, aes(x=perPos, y =perNeg, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + ggtitle("TF-IDF")

## Judgements by RANK  ######DIFFERENCE!!!!
g2 <- ggplot(pn10, aes(x=judgementCount, y =judgementFrac, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + ggtitle("Judgements") + theme(legend.position="none") 
#ggplot(idfDF, aes(x=judgementCount, y =judgementFrac, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + ggtitle("TF-IDF")
grid.arrange(g1,g2,ncol=2)

## Judgements by Group ######DIFFERENCE!!!!
ggplot(pn10, aes(x=judgementFrac, y =judgementCount, colour = groupName)) + geom_point() + ggtitle("10")
ggplot(pn20, aes(x=judgementFrac, y =judgementCount, colour = groupName)) + geom_point() + ggtitle("20")


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
