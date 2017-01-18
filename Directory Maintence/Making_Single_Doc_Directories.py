import os
import re
os.chdir('./Desktop/DSI_Religion/DSI-Religion-2017/data_dsicap_single/')

path = '/Users/meganstiles/Desktop/DSI_Religion/DSI-Religion-2017/data_dsicap_single'

#List files in directory
files = os.listdir(path)
files

#Drop '.txt' from filename in order to use this to create directories
clean_files = []
for file in files:
    file = re.sub('.txt', '', file)
    clean_files.append(file)

clean_files.remove('.DS_Store')

#Make new directories called the filename of each document
for file in clean_files:
    os.mkdir(file)

#Create list of all files and directories
all_files = os.listdir(path)

#Drop files from list so we just have directories

clean_directories = []
for file in all_files:
    if '.txt' not in file:
        clean_directories.append(file)

clean_directories.remove('.DS_Store')        

#Make subdirectory in each folder called 'raw'

for directory in clean_directories:
    new_path = path + '/' + directory
    os.chdir(new_path)
    os.mkdir('raw')
