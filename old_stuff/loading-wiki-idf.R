# {tm} comes with functionality to do the TFIDF internally
# look at the documentation under TermDocumentMatrix and then the weighting parameter

library(tm)
library(slam)
library(filehash)

#### LOAD THE DTM (this take 20-30 mins)
setwd("/Volumes/SethBoxMini/Silverchair/A1-taxonomy-project")

start <- Sys.time()
dtm210k <- read_stm_CLUTO("wikipedia/stm/dtm210k")
dtm210k <- as.DocumentTermMatrix(dtm210k, weighting=weightSMART)
Sys.time() - start
# #Time difference of 33.01673 mins FOR 1.6 Gb DocumentTermMatrix (documents: 210,577, terms: 3,701,042)

#### FILTER OUT SUPER SPARSE TERMS
#these each took a little over 1 minute
# dtm210kNS5 <- removeSparseTerms(dtm210k, 1 - (5/nrow(dtm210k)))
# dtm210kNS10 <- removeSparseTerms(dtm210k, 1 - (10/nrow(dtm210k)))
dtm210kNS20 <- removeSparseTerms(dtm210k, 1 - (20/nrow(dtm210k)))

which( colnames(dtm210kNS20)=="aaliyah" ) # double check (it should be 54)
# [1] 54

#######################
######## CREATE THE IDF
#######################

TDM <- dtm210kNS20
terms <- TDM$dimnames$Terms

start <- Sys.time()
tc <- as.data.frame(table(TDM$j)) # counts how many documents each term is in
Sys.time() - start

idf <- data.frame(term = terms, # match terms to frequencies
                  freq = tc$Freq,
                  stringsAsFactors = F)

M <- TDM$nrow # total document count
idf$idf <- M / idf$freq # raw IDF
idf$logidf <- log(idf$idf) # log IDF

# TAKE A LOOK AT WHAT WE GOT
max(idf$freq)
min(idf$freq)

max(idf$idf)
min(idf$idf)

max(idf$logidf)
min(idf$logidf)

####
### just to double check that it worked right...
# get a sample of terms with low counts
checkum <- idf[idf$freq==min(idf$freq), ][1:2, ]
checkum <- rbind(checkum, checkum <- idf[idf$freq==30, ][1:2, ])
checkum <- rbind(checkum, checkum <- idf[idf$freq==40, ][1:2, ])
checkum <- rbind(checkum, checkum <- idf[idf$freq==50, ][1:2, ])

for (i in 1:nrow(checkum)) {
  thisterm <- as.character(checkum$term[i]) # the term we're looking at
  aa <- as.matrix(TDM[ ,thisterm]) # the original DTM, with only that term
  print(paste(thisterm, '-' , length(aa[aa[,1]>0, ]))) # count of rows with values > 0
}

##### WRITE TO FILE
# setwd('/Users/Seth/Documents/DSI/Capstone/DSI-Religion-2017/pythonOutput')
# write.csv(idf, 'IDF-210kNS20.csv',row.names = F)

for (i in 1:TDM$ncol) {
  
}