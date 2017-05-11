library(ggplot2)

# change this to your root folder
setwd("/Users/Seth/Documents/DSI/Capstone/DSI-Religion-2017")
df <- read.csv("signalFiles/binnedSignals1.csv")
row.names(df) <- paste(df$groupId,df$X,sep="-")
df <- df[,3:(ncol(df)-1)] # gets rid of rank
#df <- df[,3:ncol(df)] # doesn't get rid of rank


#
#setwd("/Users/Seth/Documents/DSI/notes/3-SYS-Machine-Learning/in-class")
#df <- read.csv("wine.data", header = F)
#names(df) <- c("Alcohol","MalicAcid","Ash","Alcalinity","Magnesium","TotalPhenols","Flavanoids","NonflavanoidPhenols","Proanthocyanins","ColorIntensity","Hue","OD280-OD315","Proline")

## Perform PCA
pr.out = prcomp(df, scale = TRUE)
names(pr.out)

## means and standard deviations used for scaling prior to PCA
pr.out$center ### same as the means, i.e. the amount you had to move it to center it
pr.out$scale  ### the standard deviation, i.e. what you divide it by to scale it

## Provides PC loadings.  Each column contains the corresponding PC loading vector:
pr.out$rotation

## x holds the PC scores.  Here we check the dimensions of x:
dim(pr.out$x)

## Make biplot to look at scores and loadings:
biplot(pr.out,scale=0)
pr.out$rotation=-pr.out$rotation # this just flips the sign of everything (which is arbitrary)
pr.out$x=-pr.out$x ################## but you have to flip both x and y or it's wrong.
biplot(pr.out,scale = 0)
pr.out$sdev
pr.var = pr.out$sdev^2
pr.var
pve = pr.var/sum(pr.var)
pve
plot(pve, xlab="Principal Component", ylab = "Proportion of Variance Explained", ylim=c(0,1), type='b')
plot(cumsum(pve),xlab = "Principal Component", ylab = "Cumulative Proportion of Variance Explained", ylim = c(0,1), type='b')

########
########
df2 <- read.csv("signalFiles/binnedSignals1.csv")
row.names(df2) <- paste(df2$groupId,df2$X,sep="-")

dfPCA <- cbind(data.frame(pr.out$x), data.frame(group = df2$groupId, rank = df2$rank))

library(ggplot2)

ggplot(dfPCA, aes(x=PC1, y=PC2, colour=rank)) + geom_point(size=3)
ggplot(dfPCA, aes(x=PC1, y=PC2, colour=group)) + geom_point(size=3)
