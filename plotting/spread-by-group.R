setwd('/Users/Seth/Documents/DSI/Capstone/DSI-Religion-2017')

library(dplyr)
library(tidyr)
library(ggplot2)

runs <- read.csv('modelOutputSingleDocs/logs/Single Runs.csv', stringsAsFactors = F)

ranks <- read.csv('refData/groupRanks.csv', stringsAsFactors = F)

runs$docName <- runs$groupName
runs$groupName <- gsub("[0-9]", "", runs$groupName)

# summarise by svm (SIDENOTE)
svmOrdered <- runs %>%
  group_by(groupName) %>%
  summarise(avgSvm = mean(svmPred)) %>%
  arrange(avgSvm)

###

#svm <- runs[,c("groupName","rank","svmPred")]

# ACLU            AEU          Bahai     DorothyDay           ISIS      JohnPiper 
# 20             18             23             34             24             34 
# LiberalJudaism       MalcolmX       MehrBaba PastorAnderson   SeaShepherds       Shepherd 
# 19             29             19             22             15             18 
# Unitarian            WBC             YV 
# 17             16             46 

#
ranks <- rename(ranks, groupRank=rank)
# get rid of annoying different spellings
ranks$groupName <- gsub(' ', "", ranks$groupName)
ranks$groupName <- gsub('texts', "", ranks$groupName)
ranks$groupName <- gsub('AmericanEthicalUnion', "AEU", ranks$groupName)
ranks$groupName <- gsub("Bahai'i", "Bahai", ranks$groupName)
ranks$groupName <- gsub('FaithfulWordBaptistChurch', "PastorAnderson", ranks$groupName)
ranks$groupName <- gsub('MeherBaba', "MehrBaba", ranks$groupName)
ranks$groupName <- gsub('SeaShepherd', "SeaShepherds", ranks$groupName)
ranks$groupName <- gsub('SteveShepherd', "Shepherd", ranks$groupName)
ranks$groupName <- gsub('WestboroBaptistChurch', "WBC", ranks$groupName)
ranks$groupName <- gsub('Yogaville/IntegralYoga', "YV", ranks$groupName)

# merge to add groupRank 
df <- left_join(runs, ranks, by='groupName')
# add column for legend labels
df$Group <- paste(df$groupRank, ":", df$groupName)

## PLOTTING
#Individual Docs Ranks vs. Group
ggplot(df, aes(x=groupRank, y = rank, colour=Group)) + geom_boxplot() + ggtitle('Individual Docs Ranks vs. Group')

#Group Rank vs. SVM and RF
ggplot(df, aes(x=groupRank, y = svmPred, colour=Group)) + geom_boxplot() + ggtitle('Group Rank vs. SVM')

ggplot(df, aes(x=groupRank, y = rfPred, colour=Group)) + geom_boxplot() + ggtitle('Group Rank vs. Random Forest')

# Indiv Rank vs. SVM and RF
ggplot(df, aes(x=as.factor(rank), y = svmPred, colour=Group)) + geom_boxplot() + ggtitle('Group Rank vs. SVM')

ggplot(df, aes(x=as.factor(rank), y = rfPred, colour=Group)) + geom_boxplot() + ggtitle('Group Rank vs. Random Forest')

#### ISIS

tg <- df[df$groupName=='DorothyDay', ]

gtg <- gather(tg, model, pred, c(rfPred,svmPred,rfClassPred,svmClassPred))

ggplot(gtg[grep('Class', gtg$model), ], aes(x=as.factor(rank), y=pred, colour=model)) + geom_boxplot()
