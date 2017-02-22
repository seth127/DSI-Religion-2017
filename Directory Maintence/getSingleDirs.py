import os
import re
import pandas as pd 
from distutils.dir_util import copy_tree
import shutil

def getSingleDocDirs(filepath, olddir, newdir, newcopy, workingdir):


    #########################
    #####Organize doc scores#
    #########################

    #Read in Score Excel Sheet
    intern_scoring = pd.ExcelFile(filepath)

    #Create list of excel sheet names
    sheets = pd.ExcelFile(filepath).sheet_names

    #Create Empty DataFrame

    df_all = pd.DataFrame()

    #Read in individual Excel sheets and append to make one large data frame

    for sheet in sheets:
        df = intern_scoring.parse(sheet)
        df_all = df_all.append(df)

    #Remove columns except "Filename" and "Score"
    df_clean = df_all[['Filename','Score']]

    #Remove documents that do not have scores

    df_scored = df_clean.dropna()

    ##################
    ###Organize Files#
    ##################

    #Make new directory to store all the files
    os.mkdir(newdir)

    #Make a copy of the directory will all the files

    copy_tree(olddir,newcopy)

    groups = os.listdir(newcopy)

    # remove these red herrings if necessary
    naw = ['.DS_Store', 'test_train', 'norun', 'fake_data', 'ref']
    [groups.remove(x) for x in groups if x in naw]

    #Move all documents into a new directory

    for groupId in groups:
        files = os.listdir(newcopy + '/' + groupId + '/raw')
        naw = ['.DS_Store', 'test_train', 'norun', 'fake_data', 'ref']
        [files.remove(x) for x in files if x in naw]
        for doc in files:
            rawFilePath = (newcopy + '/' + groupId + '/raw/' + doc)
            os.rename(rawFilePath, newdir + '/' + doc)

    #Make a list of all the filenames of documents with scored_docs

    scored_docs = list(df_scored.Filename)
    scored_docs


    #Make Individual Directories for each file
    #Drop '.txt' from filename in order to use this to create directories
    scored_dir = []
    for item in scored_docs:
        item = re.sub('.txt', '', item)
        scored_dir.append(item)

    #Make new directories called the filename of each document
    os.chdir(newdir)
    for doc in scored_dir:
        os.mkdir(doc)

    #Make subdirectory in each folder called 'raw'

    for directory in scored_dir:
        new_path = workingdir + newdir + '/' + directory
        os.chdir(new_path)
        os.mkdir('raw')

    clean_files = []
    for file in scored_docs:
        file = re.sub('.txt', '', file)
        clean_files.append(file)
    
    #Move appropriate files into correct directory
    for doc in clean_files:
        currentPath = (workingdir + newdir + '/' + doc + '.txt')
        os.rename(currentPath, workingdir + newdir + '/' + doc + '/raw/' + doc + '.txt')

    #Delete Extra files

    all_files = os.listdir(workingdir + newdir)
    os.chdir(workingdir + newdir)
    for docs in all_files:
        if '.txt' in docs:
            os.remove(docs)
    
    #Remove copied dir
    os.chdir(workingdir)
    shutil.rmtree(newcopy)
    #Write out clean, scored file
    os.chdir(workingdir)
    df_scored.to_csv('./refData/docRanks.csv')