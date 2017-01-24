import os
import re
import pandas as pd
os.chdir('/Users/meganstiles/Desktop/DSI_Religion/Megan_Capstone')

#Read in Document Score Excel Sheets

intern_scoring = pd.ExcelFile('Interns Scoring.xlsx')
file = 'Interns Scoring.xlsx'

#Create list of names of excel sheets
sheets = pd.ExcelFile(file).sheet_names

#Create Empty Data Frame
df_all = pd.DataFrame()

#Read in Sheets and append to make one large data frame
for sheet in sheets:
    df = intern_scoring.parse(sheet)
    df_all = df_all.append(df)
    
#Remove columns except "Filename" and "Score"
df_clean = df_all[['Filename', 'Score']]

#Remove Documents that are not scored
df_scored = df_clean.dropna()
#################
#Organize files##
#################


###Make new Folder to store all single docs

os.chdir('/Users/meganstiles/Desktop/DSI_Religion/Megan_Capstone/')
os.mkdir('data_dsicap_single')
#def makeSingleDirectory(rawPath): ### rawPath is where you folders of documemnts are, organized as [groupName]/raw/...
	# get groups in 
rawPath = '/Users/meganstiles/Desktop/DSI_Religion/Megan_Capstone/data_dsicap_FULL'
groups = os.listdir(rawPath)

# remove these red herrings if necessary
naw = ['.DS_Store', 'test_train', 'norun', 'fake_data', 'ref']
[groups.remove(x) for x in groups if x in naw]

#Move all documents into a new directory
for groupId in groups:
    files = os.listdir(rawPath+ '/' + groupId + '/raw')
    naw = ['.DS_Store', 'test_train', 'norun', 'fake_data', 'ref']
    [files.remove(x) for x in files if x in naw]
    for doc in files:
        rawFilePath = (rawPath + '/' + groupId + '/raw/' + doc)
        os.rename(rawFilePath, '/Users/meganstiles/Desktop/DSI_Religion/Megan_Capstone/data_dsicap_single/' + doc)



#Compare all files to list of files that have scores
All_docs = os.listdir('/Users/meganstiles/Desktop/DSI_Religion/Megan_Capstone/data_dsicap_single')

#3856 Total Documents

len(df_scored) #151 documents have scores

#Make a list of all the filenames of documents with scored_docs
scored_docs = list(df_scored.Filename)
scored_docs


#path = '/Users/meganstiles/Desktop/DSI_Religion/DSI-Religion-2017/data_dsicap_single'

#Make Individual Directories for each file
#Drop '.txt' from filename in order to use this to create directories
scored_dir = []
for file in scored_docs:
    file = re.sub('.txt', '', file)
    scored_dir.append(file)


#Drop '.txt' from filename in order to use this to create directories
clean_files = []
for file in scored_docs:
    file = re.sub('.txt', '', file)
    clean_files.append(file)

#clean_files.remove('.DS_Store')

#Make new directories called the filename of each document
os.chdir('/Users/meganstiles/Desktop/DSI_Religion/Megan_Capstone/data_dsicap_single')
for file in scored_dir:
    os.mkdir(file)

#Create list of all files and directories
path = '/Users/meganstiles/Desktop/DSI_Religion/Megan_Capstone/data_dsicap_single'
all_files = os.listdir(path)

#Drop files from list so we just have directories
clean_directories = []
for file in all_files:
    if '.txt' not in file:
        clean_directories.append(file)

#clean_directories.remove('ACLU Document Key.xlsx')        
#clean_directories.remove('WestboroBaptist_Sermon_20150927.pdf')
#Make subdirectory in each folder called 'raw'

for directory in clean_directories:
    new_path = path + '/' + directory
    os.chdir(new_path)
    os.mkdir('raw')

#Remove document score b/c I am missing the document

path = '/Users/meganstiles/Desktop/DSI_Religion/Megan_Capstone/data_dsicap_single/'
#Move appropriate files into correct directory
for file in clean_files:
    currentPath = (path + file + '.txt')
    os.rename(currentPath, '/Users/meganstiles/Desktop/DSI_Religion/Megan_Capstone/data_dsicap_single/' + file + '/raw/' + file + '.txt')

os.chdir('/Users/meganstiles/Desktop/DSI_Religion/Megan_Capstone/data_dsicap_single/')

#Delete Extra files

all_files = os.listdir('/Users/meganstiles/Desktop/DSI_Religion/Megan_Capstone/data_dsicap_single/')
all_files
for file in all_files:
    if '.txt' in file:
        os.remove(file)

os.chdir('/Users/meganstiles/Desktop/DSI_Religion/Megan_Capstone/')
df_scored.to_csv('docRanks.csv')