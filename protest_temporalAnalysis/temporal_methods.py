
# coding: utf-8

# # Temporal Methods

# Methods designed for use at the document level
# 
# 
# Python 3.5

# In[2]:

import pandas as pd
import xml.etree.ElementTree as ET
import os, sys
import numpy as np
import pandas as pd
import re
import random
import nltk
tokenizer = nltk.tokenize.treebank.TreebankWordTokenizer()
import string
import datetime
import imp

# Sklearn
from sklearn.metrics import accuracy_score
from sklearn.metrics import confusion_matrix


# In[3]:

punctuation = set(string.punctuation)


# In[4]:

# os.chdir('../prototype_python')


# In[5]:

import semanticDensity as sd


# In[88]:

def parse_xml(file, key, columnTitles):
    #create empty dictionary
    productRow = {}

    #create list that will store the single dataframe rows
    rows = []

    #read in file noting when tags begin or end
    for event, element in ET.iterparse(file, events=("start", "end")):

    #get current product
        if event == "start" and element.tag == key:
            productRow = {} # dictionary on current row

        for title in columnTitles: #for each tag in the xml
            if event == "end" and element.tag == title: #if a <\TITLE> is present, then add
                productRow[title] = element.text #add to dictionary

    #done adding values - now append
        if event == "end" and element.tag == columnTitles[len(columnTitles)-1]:
            rows.append(productRow) #append to list of rows

    #create pandas dataframe with column names of tags
    frame = pd.DataFrame.from_records(rows, columns=columnTitles)
    return frame


# In[1]:

def getTermFreq(tokenList):
    TF = {}

    for word in tokenList:
        # print(word)
        if word in TF:
            TF[word] += 1
        else:
            TF[word] = 1
    return TF


# In[11]:

#Define function to create context vectors
def contextVectors(tokenList,dsm,wordlist,k):
    
    #Define coOccurence dict
    cvDict={}

    for i in range(len(tokenList)):
        targetword=tokenList[i] # Changed window to targetword for more clarity
        
        if targetword in wordlist:
            # print(targetword)
            #Adjust window to contain words k in front or k behind
            lowerBound=max(0,i-k)
            upperBound=min(len(tokenList),i+k)
            cvList=tokenList[lowerBound:i]+tokenList[i+1:upperBound+1]
    

            if targetword not in cvDict.keys():
                cvDict[targetword]={}

            #Create context vector            
            contextVector={}

            for word in cvList:
                if word in dsm.keys():
                    
                    for key in dsm[word].keys(): # Need to Catch for Words in Window, but not in DSM                 
                        #Update context vector
                        try:
                            contextVector[key]=contextVector[key]+dsm[word][key]
                        except: # What is this except for?
                            contextVector[key]=dsm[word][key]
                else:
                    for i in range(0,len(dsm[list(dsm.keys())[0]])):
                        contextVector[i] = 1

            #Add context vector to cvDict
            cvIndex=len(cvDict[targetword])+1
            cvDict[targetword][cvIndex]=contextVector
    
    #Return context vector dictionary
    return(cvDict)


# In[1]:

def tokenize34(path2File, file):
    tokens={}
    # print(path2File+file)
    #Clean raw text into token list
    rawText=open(path2File+file, errors='ignore').read()
    # rawText=unicode(rawText, "utf-8", errors="ignore")
    #Update for encoding issues            
    # rawText=unicode(rawText, "utf-8", errors="ignore")
    
    #Tokenize
    tokenList=tokenizer.tokenize(rawText)
    
    return tokenList


# In[18]:

def tokenize(path2File, file):
    tokens={}
    # print(path2File+file)
    #Clean raw text into token list
    rawText=open(path2File+file).read()
    rawText=unicode(rawText, "utf-8", errors="ignore")
    #Update for encoding issues            
    # rawText=unicode(rawText, "utf-8", errors="ignore")
    
    #Tokenize
    tokenList=tokenizer.tokenize(rawText)
    
    return tokenList


# In[13]:

#Define tokenize function
def clean_text(tokenList):
    
    #Convert all text to lower case
    tokenList=[word.lower() for word in tokenList]

    #Remove punctuation
    tokenList=[word for word in tokenList if word not in punctuation]
    # tokenList=["".join(c for c in word if c not in punctuation) for word in tokenList ]
    tokenList = [word if word[len(word)-1] not in punctuation else word[0:len(word)-1] for word in tokenList] # Mod-ing to only remove puncutation if at the end of the word

    #convert digits into NUM
    #tokenList=[re.sub("\d+", "NUM", word) for word in tokenList] 
    tokenList = ['NUM' if word.isdigit() else word for word in tokenList] # Mod-ing so that only tokens that are entirely numbers get replaced with 'Num'

    #Stem words
    #tokenList=[stemmer.stem(word) for word in tokenList]
    #stemStopwords=[stemmer.stem(word) for word in stopWords]

    #Remove blanks
    tokenList=[word for word in tokenList if word!= ' ']

    #Remove stopwords
#            stemStopwords.append("")
#            tokenList=[word for word in tokenList if word not in stemStopwords]

    #Return tokens
    return(tokenList)


# In[14]:

def count_words(tokenList):
    count = 0
    for token in tokenList:
        count += 1
    return count


# In[15]:

def count_specific_words(tokenList, word):
    count = 0
    for token in tokenList:
        if token == word:
            count += 1
    return count


# In[16]:

#Define context vector simCountulation
def averageCosine(cvDict,simCount):
    cosineResults=[]
    for searchWord in cvDict.keys():
        if len(cvDict[searchWord])>1:
            consinesim=np.zeros(simCount)
            for i in range(simCount):
                x=random.randrange(0, len(cvDict[searchWord]))
                y=random.randrange(0, len(cvDict[searchWord]))

                consinesim[i]=sd.get_cosine(cvDict[searchWord][x+1],cvDict[searchWord][y+1])
            approx_avg_cosine=np.average(consinesim)
            cosineResults.append([searchWord,approx_avg_cosine,len(cvDict[searchWord])])
        else:
            cosineResults.append([searchWord,-1,len(cvDict[searchWord])])
    return cosineResults


# In[ ]:

# Get sentimentWord dict and remove duplicates. Store in lists
posFilePath='/refData/positive-words.txt'
negFilePath='/refData/negative-words.txt'
posWords=list(set(tokenize34('.',posFilePath)))
negWords=list(set(tokenize34('.',negFilePath)))


# In[2]:

def sentimentLookup(tokens):
    fileSentiment=[]
    #Get sentiment for each document
    # for filename in tokens.keys():
        
    #initialize counters
    wordCount=0.0
    posCount=0.0
    negCount=0.0

    #Get counts
    for token in tokens:
        #Add to word count
        wordCount=wordCount+1        

        #Check if positive
        if token in posWords:
            posCount=posCount+1

        #Check if negative
        if token in negWords:
            negCount=negCount+1

    #Calculate percentages and append to list
    posPer=posCount/wordCount
    negPer=negCount/wordCount
    fileSentiment.append([posPer,negPer])
    
    #Calculate average sub-group level word sentiment percent
    #wordSentiment=np.mean(np.array(fileSentiment),axis=0)
    
    #Calculate sub-group level doc sentiment percent
    #posDocCount=float(len([x for x in fileSentiment if x[0]>x[1]]))
    #posDocPer=posDocCount/len(fileSentiment)
    #negDocPer=1-posDocPer
    #output=[wordSentiment[0],wordSentiment[1],posDocPer,negDocPer]   
    
    return(fileSentiment)


# In[ ]:

def getRawText(path2File, file):
    tokens={}
    # print(path2File+file)
    #Clean raw text into token list
    rawText=open(path2File+file, encoding='latin1').read()
    #rawText=str(unicode(rawText, "utf-8", errors="ignore"))
    return rawText


# ## Function to Load Metadata from Files (Dorothy, WBC, and simple)

# In[1]:

def getDorothyDaymetadata(dataloc):

    files = os.listdir(dataloc)

    files = [file for file in files if '.txt' in file]

    fileData = pd.DataFrame(files, columns = ['fileName'])

    firstlines = []
    for file in fileData.fileName:
        text = rawText=open(dataloc+"/"+file, encoding = 'latin1').read()
        lineone = text[0:text[1:len(text)].find('\n')+1]
        lineone = re.sub('\nThe Catholic Worker, ','',lineone)
        firstlines.append(lineone)

    fileData['firstline'] = firstlines

    # Building Parsing for Dates in DD Files
    date_est = []
    for i in range(0,len(fileData)):
        if fileData.loc[i,'firstline'][0] == '\n':
            # print(fileData.loc[i,'firstline'][0])
            # print("Drop")
            date_est.append('unclear date')
        else:
            # print(fileData.loc[i,'firstline'][0])
            # print("Keep")
            pieces = fileData.loc[i,'firstline'].split(" ")
            if len(pieces[1]) != 5:
                date_est.append('unclear date')
            else:
                date_est.append(pieces[0]+', '+pieces[1][0:4])
                # print(pieces)

    fileData['date_est'] = date_est

    datelist = []
    for date in date_est:
        try:
            datelist.append(datetime.datetime.strptime(date, '%B, %Y'))
        except ValueError:
            temp = re.split('[-,/]',date)
            temp = temp[0]+','+temp[len(temp)-1]
            try: 
                temp = datetime.datetime.strptime(temp, '%B, %Y')
                datelist.append(temp)
            except ValueError:
                try: 
                    temp = datetime.datetime.strptime(temp, '%b, %Y')
                    datelist.append(temp)
                except ValueError:
                    datelist.append("unclear date")

    fileData['date_clean'] = datelist
    
    fileData[fileData.date_clean == 'unclear date'] = np.NaN
    fileData = fileData.dropna()
    fileData = fileData[fileData.date_clean > datetime.datetime(1900, 1, 1, 0, 0)]
    del fileData['date_est']
    del fileData['firstline']
    fileData.reset_index(inplace=True, drop=True)
    
    fileData.sort_values(by='date_clean', ascending=True, inplace=True)
    
    return fileData


# In[ ]:

def getSimplemetadata(dataloc):
    'Loads File Metadata when Date is 1st Item in FileName e.g. 2 March 2017'
    files = os.listdir(dataloc)
    files = [file for file in files if '.txt' in file]
    fileData = pd.DataFrame(files, columns = ['fileName'])
    temp = [file.split('_')[0] for file in files]
    fileData['date'] = temp
    # Convert Str Dates to Date-Time Objects
    dates_clean = [datetime.datetime.strptime(date,'%d %B %Y') for date in fileData.date]
    fileData['date_clean'] = dates_clean
    fileData.sort_values(by='date_clean', ascending=True, inplace=True)
    return fileData


# In[ ]:

def getWBCmetadata(dataloc):
    files = os.listdir(dataloc)
    files = [file for file in files if '.txt' in file]
    fileData = pd.DataFrame(files, columns = ['fileName'])
    temp = [file.split('_')[2][0:8] for file in files]
    fileData['date'] = temp
    # Convert Str Dates to Date-Time Objects
    dates_clean = [datetime.datetime.strptime(date,'%Y%m%d') for date in fileData.date]
    fileData['date_clean'] = dates_clean
    fileData.sort_values(by='date_clean', ascending=True, inplace=True)
    return fileData

