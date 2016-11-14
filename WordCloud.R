# Install
install.packages("tm")  # for text mining
install.packages("SnowballC") # for text stemming
install.packages("wordcloud") # word-cloud generator 
install.packages("RColorBrewer") # color palettes

# Load
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")

# Westboro Baptist Church
WBCnoPro <- read.csv("WBC-6D8-KEYWORDS-tfidfNoPro.csv")
WBCtfIdf <- read.csv("WBC-8XE-KEYWORDS-tfidf.csv")
WBCadAdv <- read.csv("WBC-97W-KEYWORDS-adjAdv.csv")

wordcloud(words = WBCnoPro$term, freq = WBCnoPro$logtfidf, min.freq = 1,
          max.words = 100, random.order = FALSE, rot.per=0.00, random.color = TRUE,
          colors = c("darkorange3", "royalblue4"))

wordcloud(words = WBCtfIdf$term, freq = WBCtfIdf$logtfidf, min.freq = 1,
          max.words = 100, random.order = FALSE, rot.per=0.00, random.color = TRUE,
          colors = c("darkorange3", "royalblue4"))

wordcloud(words = WBCadAdv$word, freq = WBCadAdv$count, min.freq = 1,
          max.words = 100, random.order = FALSE, rot.per=0.00, random.color = TRUE,
          colors = c("darkorange3", "royalblue4"))

# Bahai
BahainoPro <- read.csv("Bahai-4Y4-KEYWORDS-tfidfNoPro.csv")
BahaitfIdf <- read.csv("Bahai-1I9-KEYWORDS-tfidf.csv")
BahaiadAdv <- read.csv("Bahai-0U8-KEYWORDS-adjAdv.csv")

wordcloud(words = BahainoPro$term, freq = BahainoPro$logtfidf, min.freq = 1,
          max.words = 100, random.order = FALSE, rot.per=0.00, random.color = TRUE,
          colors = c("darkorange3", "royalblue4"))

wordcloud(words = BahaitfIdf$term, freq = BahaitfIdf$logtfidf, min.freq = 1,
          max.words = 100, random.order = FALSE, rot.per=0.00, random.color = TRUE,
          colors = c("darkorange3", "royalblue4"))

wordcloud(words = BahaiadAdv$word, freq = BahaiadAdv$count, min.freq = 1,
          max.words = 100, random.order = FALSE, rot.per=0.00, random.color = TRUE,
          colors = c("darkorange3", "royalblue4"))
