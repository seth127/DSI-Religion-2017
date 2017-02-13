# To clean up group's document names
# Make sure you put all of the .txt files into a folder in the group's name in a folder called raw
# By: Samantha Garofalo (smg7un)

##############################################################################################

# AEU
setwd("~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/AEU/raw")
startingDir <- "~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/AEU/raw"
files <- list.files(startingDir, pattern = ".txt")
head(files)
new_names <- paste("AEU", formatC(seq(length(files)), width = 3, flag = "0"), ".txt", sep = "")
file.rename(from = files, to = new_names)

# DorothyDay
setwd("~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/DorothyDay/raw")
startingDir <- "~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/DorothyDay/raw"
files <- list.files(startingDir, pattern = ".txt")
head(files)
new_names <- paste("DorothyDay", formatC(seq(length(files)), width = 3, flag = "0"), ".txt", sep = "")
file.rename(from = files, to = new_names)

# Ghandi
setwd("~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/Ghandi/raw")
startingDir <- "~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/Ghandi/raw"
files <- list.files(startingDir, pattern = ".txt")
head(files)
new_names <- paste("Ghandi", formatC(seq(length(files)), width = 3, flag = "0"), ".txt", sep = "")
file.rename(from = files, to = new_names)

# ISIS
setwd("~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/ISIS/raw")
startingDir <- "~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/ISIS/raw"
files <- list.files(startingDir, pattern = ".txt")
head(files)
new_names <- paste("ISIS", formatC(seq(length(files)), width = 3, flag = "0"), ".txt", sep = "")
file.rename(from = files, to = new_names)

# JohnPiper
setwd("~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/JohnPiper/raw")
startingDir <- "~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/JohnPiper/raw"
files <- list.files(startingDir, pattern = ".txt")
head(files)
new_names <- paste("JohnPiper", formatC(seq(length(files)), width = 3, flag = "0"), ".txt", sep = "")
file.rename(from = files, to = new_names)

# LiberalJudaism
setwd("~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/LiberalJudaism/raw")
startingDir <- "~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/LiberalJudaism/raw"
files <- list.files(startingDir, pattern = ".txt")
head(files)
new_names <- paste("LiberalJudaism", formatC(seq(length(files)), width = 3, flag = "0"), ".txt", sep = "")
file.rename(from = files, to = new_names)

# MalcolmX
setwd("~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/MalcolmX/raw")
startingDir <- "~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/MalcolmX/raw"
files <- list.files(startingDir, pattern = ".txt")
head(files)
new_names <- paste("MalcolmX", formatC(seq(length(files)), width = 3, flag = "0"), ".txt", sep = "")
file.rename(from = files, to = new_names)

# MehrBaba
setwd("~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/MehrBaba/raw")
startingDir <- "~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/MehrBaba/raw"
files <- list.files(startingDir, pattern = ".txt")
head(files)
new_names <- paste("MehrBaba", formatC(seq(length(files)), width = 3, flag = "0"), ".txt", sep = "")
file.rename(from = files, to = new_names)

# NaumanKahn
setwd("~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/NaumanKhan/raw")
startingDir <- "~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/NaumanKhan/raw"
files <- list.files(startingDir, pattern = ".txt")
head(files)
new_names <- paste("NaumanKhan", formatC(seq(length(files)), width = 3, flag = "0"), ".txt", sep = "")
file.rename(from = files, to = new_names)

# PastorAnderson
setwd("~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/PastorAnderson/raw")
startingDir <- "~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/PastorAnderson/raw"
files <- list.files(startingDir, pattern = ".txt")
head(files)
new_names <- paste("PastorAnderson", formatC(seq(length(files)), width = 3, flag = "0"), ".txt", sep = "")
file.rename(from = files, to = new_names)

# PeterGomes
setwd("~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/PeterGomes/raw")
startingDir <- "~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/PeterGomes/raw"
files <- list.files(startingDir, pattern = ".txt")
head(files)
new_names <- paste("PeterGomes", formatC(seq(length(files)), width = 3, flag = "0"), ".txt", sep = "")
file.rename(from = files, to = new_names)

# Rabbinic
setwd("~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/Rabbinic/raw")
startingDir <- "~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/Rabbinic/raw"
files <- list.files(startingDir, pattern = ".txt")
head(files)
new_names <- paste("Rabbinic", formatC(seq(length(files)), width = 3, flag = "0"), ".txt", sep = "")
file.rename(from = files, to = new_names)

# Schizophrenia
setwd("~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/Schizophrenia/raw")
startingDir <- "~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/Schizophrenia/raw"
files <- list.files(startingDir, pattern = ".txt")
head(files)
new_names <- paste("Schizophrenia", formatC(seq(length(files)), width = 3, flag = "0"), ".txt", sep = "")
file.rename(from = files, to = new_names)

# SeaShepherds
setwd("~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/SeaShepherds/raw")
startingDir <- "~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/SeaShepherds/raw"
files <- list.files(startingDir, pattern = ".txt")
head(files)
new_names <- paste("SeaShepherds", formatC(seq(length(files)), width = 3, flag = "0"), ".txt", sep = "")
file.rename(from = files, to = new_names)

# Shepherd
setwd("~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/Shepherd/raw")
startingDir <- "~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/Shepherd/raw"
files <- list.files(startingDir, pattern = ".txt")
head(files)
new_names <- paste("Shepherd", formatC(seq(length(files)), width = 3, flag = "0"), ".txt", sep = "")
file.rename(from = files, to = new_names)

# Stalin
setwd("~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/Stalin/raw")
startingDir <- "~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/Stalin/raw"
files <- list.files(startingDir, pattern = ".txt")
head(files)
new_names <- paste("Stalin", formatC(seq(length(files)), width = 3, flag = "0"), ".txt", sep = "")
file.rename(from = files, to = new_names)

# Unabomber
setwd("~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/Unabomber/raw")
startingDir <- "~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/Unabomber/raw"
files <- list.files(startingDir, pattern = ".txt")
head(files)
new_names <- paste("Unabomber", formatC(seq(length(files)), width = 3, flag = "0"), ".txt", sep = "")
file.rename(from = files, to = new_names)

# Unitarian
setwd("~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/Unitarian/raw")
startingDir <- "~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/Unitarian/raw"
files <- list.files(startingDir, pattern = ".txt")
head(files)
new_names <- paste("Unitarian", formatC(seq(length(files)), width = 3, flag = "0"), ".txt", sep = "")
file.rename(from = files, to = new_names)

# WBC
setwd("~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/WBC/raw")
startingDir <- "~/Documents/Data Science/Capstone/DSI-Religion-2017/data_dsicap_FULL/WBC/raw"
files <- list.files(startingDir, pattern = ".txt")
head(files)
new_names <- paste("WBC", formatC(seq(length(files)), width = 3, flag = "0"), ".txt", sep = "")
file.rename(from = files, to = new_names)


