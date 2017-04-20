# Beginning to look at Time Series
# Graphs of Scores over Time by Group
# By: Samantha Garofalo (smg7un)
# DSI-Religion-2017 Capstone

############################################################################################
# Save all plots to one singular PDF
pdf("TS_Graphs.pdf")

# Scores
setwd("~/Downloads")
library(readxl)

# First, download Interns Scoring Doc in xlsx format
WBC <- read_excel("~/Downloads/Interns Scoring.xlsx", sheet = "WBC")
# Bahai <- read_excel("~/Downloads/Interns Scoring.xlsx", sheet = "Bahai")
DorothyDay <- read_excel("~/Downloads/Interns Scoring.xlsx", sheet = "DorothyDay")
ISIS <- read_excel("~/Downloads/Interns Scoring.xlsx", sheet = "ISIS")
JohnPiper <- read_excel("~/Downloads/Interns Scoring.xlsx", sheet = "JohnPiper")
MehrBaba <- read_excel("~/Downloads/Interns Scoring.xlsx", sheet = "MehrBaba")
SeaShepherds <- read_excel("~/Downloads/Interns Scoring.xlsx", sheet = "SeaShepherds")
Unitarian <- read_excel("~/Downloads/Interns Scoring.xlsx", sheet = "Unitarian")

WBC <- WBC[,1:5]
# Bahai <- Bahai[,1:5]
DorothyDay <- DorothyDay[,1:5]
ISIS <- ISIS[,1:5]
JohnPiper <- JohnPiper[,1:5]
MehrBaba <- MehrBaba[,1:5]
SeaShepherds <- SeaShepherds[,1:5]
Unitarian <- Unitarian[,1:5]

WBC <- WBC[!is.na(WBC$Score),]
# Bahai <- Bahai[!is.na(Bahai$Score),]
DorothyDay <- DorothyDay[!is.na(DorothyDay$Score),]
ISIS <- ISIS[!is.na(ISIS$Score),]
JohnPiper <- JohnPiper[!is.na(JohnPiper$Score),]
MehrBaba <- MehrBaba[!is.na(MehrBaba$Score),]
SeaShepherds <- SeaShepherds[!is.na(SeaShepherds$Score),]
Unitarian <- Unitarian[!is.na(Unitarian$Score),]

WBC <- WBC[!is.na(WBC$Date),]
# Bahai <- Bahai[!is.na(Bahai$Date),]
DorothyDay <- DorothyDay[!is.na(DorothyDay$Date),]
ISIS <- ISIS[!is.na(ISIS$Date),]
JohnPiper <- JohnPiper[!is.na(JohnPiper$Date),]
MehrBaba <- MehrBaba[!is.na(MehrBaba$Date),]
SeaShepherds <- SeaShepherds[!is.na(SeaShepherds$Date),]
Unitarian <- Unitarian[!is.na(Unitarian$Date),]

WBC$Date <- as.Date(WBC$Date , format = "%m/%d/%y")
# Bahai$Date <- as.Date(Bahai$Date , format = "%m/%d/%y")
DorothyDay$Date <- as.Date(DorothyDay$Date , format = "%m/%d/%y")
ISIS$Date <- as.Date(ISIS$Date , format = "%m/%d/%y")
JohnPiper$Date <- as.Date(JohnPiper$Date , format = "%m/%d/%y")
MehrBaba$Date <- as.Date(MehrBaba$Date , format = "%m/%d/%y")
SeaShepherds$Date <- as.Date(SeaShepherds$Date , format = "%m/%d/%y")
Unitarian$Date <- as.Date(Unitarian$Date , format = "%m/%d/%y")

plot(WBC$Date, WBC$Score, main = "WBC", xlab = "Date", ylab = "Score", ylim = c(0,9))
# plot(Bahai$Date, Bahai$Score, main = "Bahai", xlab = "Date", ylab = "Score", ylim = c(0,9))
plot(DorothyDay$Date, DorothyDay$Score, main = "DorothyDay", xlab = "Date", ylab = "Score", ylim = c(0,9))
plot(ISIS$Date, ISIS$Score, main = "ISIS", xlab = "Date", ylab = "Score", ylim = c(0,9))
plot(JohnPiper$Date, JohnPiper$Score, main = "JohnPiper", xlab = "Date", ylab = "Score", ylim = c(0,9))
plot(MehrBaba$Date, MehrBaba$Score, main = "MehrBaba", xlab = "Date", ylab = "Score", ylim = c(0,9))
plot(SeaShepherds$Date, SeaShepherds$Score, main = "SeaShepherds", xlab = "Date", ylab = "Score", ylim = c(0,9))
plot(Unitarian$Date, Unitarian$Score, main = "Unitarian", xlab = "Date", ylab = "Score", ylim = c(0,9))

############################################################################################
# Signals
setwd("~/Documents/Data Science/Capstone/DSI-Religion-2017/modelOutputSingleDocs/307 Signals")

# Import the signals dataframe
signals <- read.csv("SingleDocSignals.csv")
signals$Filename <- paste(signals$groupId, ".txt", sep = "")

# Rename the column (got deleted for some reason)
colnames(MehrBaba)[1] <- "Group"
df <- rbind(WBC, DorothyDay, ISIS, JohnPiper, MehrBaba, SeaShepherds, Unitarian)
# Merge the 2 datasets, but do a right outer join so that all the documents that have dates 
# are accounted for
new.df <- merge(x = signals, y = df, by = "Filename", all.y = TRUE)
# Remove any NA's in the date
new.df <- new.df[!is.na(new.df$Date),]

# Rename the dataframe for ease
df <- new.df
df <- df[,c("Filename", "perPos", "perNeg", "PSJudge", "judgementFrac", "nous", "vous", 
            "je", "ils", "il", "elle", "le", "UniqueWordCount", "avgSD", "avgEVC", 
            "Group", "Date", 'Score')]

# Split the dataframes based on groups so that we can graph by each group
mylist <- split(df, df$Group)
WBC <- as.data.frame(mylist$`Westboro Baptist Church`)
DorothyDay <- as.data.frame(mylist$`Dorothy Day`)
ISIS <- as.data.frame(mylist$ISIS)
JohnPiper <- as.data.frame(mylist$`John Piper`)
MehrBaba <- as.data.frame(mylist$`Mehr Baba`)
SeaShepherds <- as.data.frame(mylist$SeaShepherds)
Unitarian <- as.data.frame(mylist$Unitarian)

# Plot the time series by signal
library(ggplot2)
library(reshape2)

####################################
# Westboro
WBC <- WBC[,c("perPos", "perNeg", "PSJudge", "judgementFrac", "nous", "vous", 
             "je", "ils", "il", "elle", "le", "UniqueWordCount", "avgSD", "avgEVC", "Date", 'Score')]
WBC.upper <- WBC[,c("UniqueWordCount", "avgSD", "avgEVC", "Date", "PSJudge", "judgementFrac")]
d <- melt(WBC.upper, id.vars = "Date", variable.name = "series")
ggplot(d, aes(Date, value)) + geom_line(aes(colour = series)) + ggtitle("WBC")
WBC.lower <- WBC[,c("perPos", "perNeg", "nous", "vous", "je", "ils", "il", "elle", "le", "Date")]
d <- melt(WBC.lower, id.vars = "Date", variable.name = "series")
ggplot(d, aes(Date, value)) + geom_line(aes(colour = series)) + ggtitle("WBC")

####################################
# Dorothy Day
DorothyDay <- DorothyDay[,c("perPos", "perNeg", "PSJudge", "judgementFrac", "nous", "vous", 
              "je", "ils", "il", "elle", "le", "UniqueWordCount", "avgSD", "avgEVC", "Date", 'Score')]
DorothyDay.upper <- DorothyDay[,c("UniqueWordCount", "avgSD", "avgEVC", "Date", "PSJudge", "judgementFrac")]
d <- melt(DorothyDay.upper, id.vars = "Date", variable.name = "series")
ggplot(d, aes(Date, value)) + geom_line(aes(colour = series)) + ggtitle("Dorothy Day")
DorothyDay.lower <- DorothyDay[,c("perPos", "perNeg", "nous", "vous", "je", "ils", "il", "elle", "le", "Date")]
d <- melt(DorothyDay.lower, id.vars = "Date", variable.name = "series")
ggplot(d, aes(Date, value)) + geom_line(aes(colour = series)) + ggtitle("Dorothy Day")

####################################
# ISIS
ISIS <- ISIS[,c("perPos", "perNeg", "PSJudge", "judgementFrac", "nous", "vous", 
              "je", "ils", "il", "elle", "le", "UniqueWordCount", "avgSD", "avgEVC", "Date", 'Score')]
ISIS.upper <- ISIS[,c("UniqueWordCount", "avgSD", "avgEVC", "Date", "PSJudge", "judgementFrac")]
d <- melt(ISIS.upper, id.vars = "Date", variable.name = "series")
ggplot(d, aes(Date, value)) + geom_line(aes(colour = series)) + ggtitle("ISIS")
ISIS.lower <- ISIS[,c("perPos", "perNeg", "nous", "vous", "je", "ils", "il", "elle", "le", "Date")]
d <- melt(ISIS.lower, id.vars = "Date", variable.name = "series")
ggplot(d, aes(Date, value)) + geom_line(aes(colour = series)) + ggtitle("ISIS")

####################################
# John Piper
JohnPiper <- JohnPiper[,c("perPos", "perNeg", "PSJudge", "judgementFrac", "nous", "vous", 
              "je", "ils", "il", "elle", "le", "UniqueWordCount", "avgSD", "avgEVC", "Date", 'Score')]
JohnPiper.upper <- JohnPiper[,c("UniqueWordCount", "avgSD", "avgEVC", "Date", "PSJudge", "judgementFrac")]
d <- melt(JohnPiper.upper, id.vars = "Date", variable.name = "series")
ggplot(d, aes(Date, value)) + geom_line(aes(colour = series)) + ggtitle("John Piper")
JohnPiper.lower <- JohnPiper[,c("perPos", "perNeg", "nous", "vous", "je", "ils", "il", "elle", "le", "Date")]
d <- melt(JohnPiper.lower, id.vars = "Date", variable.name = "series")
ggplot(d, aes(Date, value)) + geom_line(aes(colour = series)) + ggtitle("John Piper")

####################################
# Mehr Baba
MehrBaba <- MehrBaba[,c("perPos", "perNeg", "PSJudge", "judgementFrac", "nous", "vous", 
              "je", "ils", "il", "elle", "le", "UniqueWordCount", "avgSD", "avgEVC", "Date", 'Score')]
MehrBaba.upper <- MehrBaba[,c("UniqueWordCount", "avgSD", "avgEVC", "Date", "PSJudge", "judgementFrac")]
d <- melt(MehrBaba.upper, id.vars = "Date", variable.name = "series")
ggplot(d, aes(Date, value)) + geom_line(aes(colour = series)) + ggtitle("Mehr Baba")
MehrBaba.lower <- MehrBaba[,c("perPos", "perNeg", "nous", "vous", "je", "ils", "il", "elle", "le", "Date")]
d <- melt(MehrBaba.lower, id.vars = "Date", variable.name = "series")
ggplot(d, aes(Date, value)) + geom_line(aes(colour = series)) + ggtitle("Mehr Baba")

####################################
# Sea Shepards
SeaShepherds <- SeaShepherds[,c("perPos", "perNeg", "PSJudge", "judgementFrac", "nous", "vous", 
              "je", "ils", "il", "elle", "le", "UniqueWordCount", "avgSD", "avgEVC", "Date", 'Score')]
SeaShepherds.upper <- SeaShepherds[,c("UniqueWordCount", "avgSD", "avgEVC", "Date", "PSJudge", "judgementFrac")]
d <- melt(SeaShepherds.upper, id.vars = "Date", variable.name = "series")
ggplot(d, aes(Date, value)) + geom_line(aes(colour = series)) + ggtitle("Sea Shepherds")
SeaShepherds.lower <- SeaShepherds[,c("perPos", "perNeg", "nous", "vous", "je", "ils", "il", "elle", "le", "Date")]
d <- melt(SeaShepherds.lower, id.vars = "Date", variable.name = "series")
ggplot(d, aes(Date, value)) + geom_line(aes(colour = series)) + ggtitle("SeaShepherds")

####################################
# Unitarian
Unitarian <- Unitarian[,c("perPos", "perNeg", "PSJudge", "judgementFrac", "nous", "vous", 
              "je", "ils", "il", "elle", "le", "UniqueWordCount", "avgSD", "avgEVC", "Date", 'Score')]
Unitarian.upper <- Unitarian[,c("UniqueWordCount", "avgSD", "avgEVC", "Date", "PSJudge", "judgementFrac")]
d <- melt(Unitarian.upper, id.vars = "Date", variable.name = "series")
ggplot(d, aes(Date, value)) + geom_line(aes(colour = series)) + ggtitle("Unitarian")
Unitarian.lower <- Unitarian[,c("perPos", "perNeg", "nous", "vous", "je", "ils", "il", "elle", "le", "Date")]
d <- melt(Unitarian.lower, id.vars = "Date", variable.name = "series")
ggplot(d, aes(Date, value)) + geom_line(aes(colour = series)) + ggtitle("Unitarian")

# Turn PDF graph collection off
dev.off()
