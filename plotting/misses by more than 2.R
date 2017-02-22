library(ggplot2)

setwd('/Users/Seth/Documents/DSI/Capstone/DSI-Religion-2017/modelOutputSingleDocs/logs')


########### JUST ONE RUN
df <- read.csv('modelPredictions-coco_3_cv_3_netAng_30_twc_10_tfidfNoPro_pronoun_bin_1-72KLUE.csv', stringsAsFactors = F)

# SVM
ggplot(df[abs(df$rank - df$svmPred) > 2, ], aes(x=as.factor(rank), y = svmPred, colour = groupId)) + geom_point(size=5) + ggtitle('SVM misses by more than 2')

# RF
ggplot(df[abs(df$rank - df$rfPred) > 2, ], aes(x=as.factor(rank), y = rfPred, colour = groupId)) + geom_point(size=5) + ggtitle('RF misses by more than 2')



################## BOXPLOTS OF ALL RUNS


df <- read.csv('Single Runs.csv', stringsAsFactors = F)

# SVM
ggplot(df[abs(df$rank - df$svmPred) > 2, ], aes(x=as.factor(rank), y = svmPred, colour = groupName)) + geom_boxplot() + ggtitle('SVM misses by more than 2')

# RF
ggplot(df[abs(df$rank - df$rfPred) > 2, ], aes(x=as.factor(rank), y = rfPred, colour = groupName)) + geom_boxplot() + ggtitle('RF misses by more than 2')


##### SPECIFIC GROUPS
#ISIS
gdf <- df[grep('YV', df$groupName),]
# SVM 
ggplot(gdf[abs(gdf$rank - gdf$svmPred) > 2, ], aes(x=as.factor(rank), y = svmPred, colour = groupName)) + geom_boxplot() + ggtitle('SVM misses by more than 2')

# RF
ggplot(gdf[abs(gdf$rank - gdf$rfPred) > 2, ], aes(x=as.factor(rank), y = rfPred, colour = groupName)) + geom_boxplot() + ggtitle('RF misses by more than 2')



