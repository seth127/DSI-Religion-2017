wikiTrim <- function(oldDir, newDir, len, links) {
  start = Sys.time()
  #get list of all files
  files <- list.files(path=oldDir)
  #make new directory to put filtered files in
  if (!dir.exists(newDir)) {
    dir.create(newDir)
  } else {
    warning(paste(newDir, "already exists. Adding files to pre-existing directory. Duplicate files will be overwritten."))
  }
  #
  for (j in 1:length(files)) {
    #load each file
    con <- file(paste(oldDir, files[j], sep="/"))
    wiki <- readLines(con) 
    close(con)
    #test file against len and links
    wiki <- unlist(strsplit(wiki, ":LINKNUM:"))
    if(nchar(wiki[1]) > len & as.numeric(wiki[2]) > links) {
      write(paste(wiki, collapse = " :LINKNUM:"), 
            paste(newDir,files[j], sep="/"))
    }
  }
  print(paste("ALL DONE with", newDir, Sys.time() - start))
}

#setwd("~/Documents/DSI/Capstone/DSI-Religion-2017/wiki-IDF")
#wikiTrim("wiki-articles-test", "wiki-articles-30k300-test", 30000, 300) # cut to 90% on test
setwd('/Volumes/SethBoxMini/Silverchair/A1-taxonomy-project/wikipedia/json-wikipedia')
wikiTrim("wiki-articles", "wiki-articles-30k300", 30000, 300) # cut to 90% on test
wikiTrim("wiki-articles", "wiki-articles-15k200", 15000, 200) # cut to 60% on test
wikiTrim("wiki-articles", "wiki-articles-10k50", 10000, 50) # cut to %30 on test 


#############

wikiTrimNoLink <- function(oldDir, newDir, len, links) {
  start = Sys.time()
  #get list of all files
  files <- list.files(path=oldDir)
  #make new directory to put filtered files in
  if (!dir.exists(newDir)) {
    dir.create(newDir)
  } else {
    warning(paste(newDir, "already exists. Adding files to pre-existing directory. Duplicate files will be overwritten."))
  }
  #
  for (j in 1:length(files)) {
    #load each file
    con <- file(paste(oldDir, files[j], sep="/"))
    wiki <- readLines(con) 
    close(con)
    #test file against len and links
    if(nchar(wiki) > len) {
      write(wiki, paste(newDir,files[j], sep="/"))
    }
  }
  print(paste("ALL DONE with", newDir, Sys.time() - start))
}

#setwd("~/Documents/DSI/Capstone/DSI-Religion-2017/wiki-IDF")
#wikiTrim("wiki-articles-test", "wiki-articles-30k300-test", 30000, 300) # cut to 90% on test
setwd('/Volumes/SethBoxMini/Silverchair/A1-taxonomy-project/wikipedia/json-wikipedia')
wikiTrimNoLink("wiki-articles", "wiki-articles-30k", 30000) # cut to 90% on test
wikiTrimNoLink("wiki-articles", "wiki-articles-15k", 15000) # cut to 60% on test
wikiTrimNoLink("wiki-articles", "wiki-articles-10k", 10000) # cut to %30 on test 
wikiTrimNoLink("wiki-articles", "wiki-articles-7500", 7500) # 
wikiTrimNoLink("wiki-articles", "wiki-articles-5k", 5000) # 

