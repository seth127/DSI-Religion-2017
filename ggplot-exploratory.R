setwd("~/Documents/DSI/Capstone/DSI-Religion-2017")
library(ggplot2)

signalDF <- read.csv('./pythonOutput/run1/cleanedOutput/coco_3_cv_3_netAng_30_sc_0/run0/masterOutput.csv', stringsAsFactors = F)

for (i in 1:nrow(signalDF)) {
  signalDF$groupName[i] <- unlist(strsplit(signalDF$groupId[i], "_"))[1]
}

### BY GROUP
#ggplot(signalDF, aes(x=avgSD, y =avgEVC, colour = groupName)) + geom_point()

ggplot(signalDF, aes(x=avgSD, y =judgementFrac, colour = groupName)) + geom_point()


### RANKINGS
ranks <- data.frame(groupName=c('WBC', 'PastorAnderson', 'NaumanKhan', 'DorothyDay', 'JohnPiper', 'Shepherd',
               'Rabbinic', 'Unitarian', 'MehrBaba','NawDawg','SeaShepherds','IntegralYoga','Bahai'), 
               groupRank=c(1,2,3,4,4,4,6,7,8,4,2,7,6))

DF <- merge(signalDF, ranks, by = "groupName")

## RANKINGS continuous
mid = 4
## zoomed in
ggplot(DF, aes(x=avgSD, y =avgEVC, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" )

## scaled to 0 and 1
ggplot(DF, aes(x=avgSD, y =avgEVC, colour = groupRank)) + geom_point() + scale_color_gradient2(midpoint=mid, low="red", mid="white", high="blue", space ="Lab" ) + xlim(0,1) + ylim(0,1)



## RANKINGS discrete
DF$rankDiscrete <- as.factor(DF$groupRank)
ggplot(DF, aes(x=avgSD, y =judgementFrac, colour = rankDiscrete)) + geom_point()


