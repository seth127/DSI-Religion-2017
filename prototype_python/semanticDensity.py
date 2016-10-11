# -*- coding: utf-8 -*-
"""
Created on Sun Apr 10 09:42:33 2016

@author: nmvenuti
Context vector code development
"""

import os, glob, time
import sys
import nltk
import string
import re
import numpy as np
from sklearn.decomposition import TruncatedSVD
from sklearn.feature_extraction import DictVectorizer
import random
import math

###################################
######Set up inital parameters#####
###################################

#Set function parameters for package
tokenizer = nltk.tokenize.treebank.TreebankWordTokenizer()

stemmer = nltk.stem.snowball.EnglishStemmer()
punctuation = set(string.punctuation)
stopWords = ['i', 'me', 'my', 'myself', 'we', 'our', 'ours', 'ourselves', 'you', 'your', 'yours',
'yourself', 'yourselves', 'he', 'him', 'his', 'himself', 'she', 'her', 'hers',
'herself', 'it', 'its', 'itself', 'they', 'them', 'their', 'theirs', 'themselves',
'what', 'which', 'who', 'whom', 'this', 'that', 'these', 'those', 'am', 'is', 'are',
'was', 'were', 'be', 'been', 'being', 'have', 'has', 'had', 'having', 'do', 'does',
'did', 'doing', 'a', 'an', 'the', 'and', 'but', 'if', 'or', 'because', 'as', 'until',
'while', 'of', 'at', 'by', 'for', 'with', 'about', 'against', 'between', 'into',
'through', 'during', 'before', 'after', 'above', 'below', 'to', 'from', 'up', 'down',
'in', 'out', 'on', 'off', 'over', 'under', 'again', 'further', 'then', 'once', 'here',
'there', 'when', 'where', 'why', 'how', 'all', 'any', 'both', 'each', 'few', 'more',
'most', 'other', 'some', 'such', 'no', 'nor', 'not', 'only', 'own', 'same', 'so',
'than', 'too', 'very', 's', 't', 'can', 'will', 'just', 'don', 'should', 'now']

#Define tokenize function
def tokenize(fileList):
    tokens={}
    
    for fileName in fileList:
        
        #Try to clean files, otherwise note errors
        try:
            #Clean raw text into token list
            rawText=open(fileName).read()
            
            #Update for encoding issues            
            rawText=unicode(rawText, "utf-8", errors="ignore")
            #Tokenize
            textList=tokenizer.tokenize(rawText)
            
            #Convert all text to lower case
            textList=[word.lower() for word in textList]
            
            #Remove punctuation
            textList=[word for word in textList if word not in punctuation]
            textList=["".join(c for c in word if c not in punctuation) for word in textList ]
            
            #convert digits into NUM
            textList=[re.sub("\d+", "NUM", word) for word in textList]  
            
            #Stem words
            textList=[stemmer.stem(word) for word in textList]
            stemStopwords=[stemmer.stem(word) for word in stopWords]
            
            #Remove blanks
            textList=[word for word in textList if word!= ' ']
             
            #Remove stopwords
#            stemStopwords.append("")
#            textList=[word for word in textList if word not in stemStopwords]
                
            #Add to dictionary if textList len greater than zero
            if len(textList)>0:
                tokens[fileName]=textList    
        except:
            pass
    #Return tokens
    return(tokens)

#Define co-occurence function
def coOccurence(tokens,k):
    
    #Define coOccurence dict
    coCoDict={}
    TF={}
    docTF={}
        
    #Loop through each file
    for fileName in tokens.keys():
        for i in range(len(tokens[fileName])):
            #Adjust window to contain words k in front or k behind
            lowerBound=max(0,i-k)
            upperBound=min(len(tokens[fileName]),i+k)
            coCoList=tokens[fileName][lowerBound:i]+tokens[fileName][i+1:upperBound+1]
            window=tokens[fileName][i]
            
            #Add window to coCoDict if not present
            if window not in coCoDict.keys():
                coCoDict[window]={}
            
            #Add words to coCoDict for window
            for word in coCoList:
                try:
                    coCoDict[window][word]+=1
                except KeyError:
                    coCoDict[window][word]=1
                    
            # Make TF Dictionary
            try:
                TF[window]+=1
            except KeyError:
                TF[window]=1
                
            # Get TF Counts by File
            if fileName in docTF.keys():
                if window in docTF[fileName].keys():
                    docTF[fileName][window]+=1
                else:
                    docTF[fileName][window]=1
            else:
                docTF[fileName]={}
                docTF[fileName][window]=1
    
    #Return CoCoDict
    return(coCoDict, TF, docTF)
    
#Define function to perform SVD on co-occurences
def DSM(coCoDict,k):

    coCoDictList = []
    for key in coCoDict.keys():
        coCoDictList.append(coCoDict[key])
        
    v = DictVectorizer(sparse=True)
    dsm = v.fit_transform(coCoDictList)
    
    svd = TruncatedSVD(n_components=k, random_state=42)
    coCoSVD = svd.fit_transform(dsm)
    
    #Convert back to dictionary
    svdDict={}
    for i in range(len(v.get_feature_names())):
        svdDict[v.get_feature_names()[i]]={}
        for j in range(k):
            svdDict[v.get_feature_names()[i]][j]=coCoSVD[i][j]

    #Return DSM
    return(svdDict)

#Define function to create context vectors
def contextVectors(tokens,dsm,wordList,k):
    
    #Define coOccurence dict
    cvDict={}
    
    #Loop through each file
    for fileName in tokens.keys():
        cvDict[fileName]={}
        for i in range(len(tokens[fileName])):
            #Adjust window to contain words k in front or k behind
            lowerBound=max(0,i-k)
            upperBound=min(len(tokens[fileName]),i+k) # FIXED BUG HERE, SAME AS ABOVE ADD [FILENAME]
            cvList=tokens[fileName][lowerBound:i]+tokens[fileName][i+1:upperBound+1]
            window=tokens[fileName][i]
            
            #Check if window in wordlist
            if window in wordList:            
                #Add entry for cvDict if window not yet present
                if window not in cvDict[fileName].keys():
                    cvDict[fileName][window]={}
                
                #Create context vector            
                contextVector={}
                
                for word in cvList:
                    for key in dsm[word].keys():                    
                        #Update context vector
                        try:
                            contextVector[key]=contextVector[key]+dsm[word][key]
                        except:
                            contextVector[key]=dsm[word][key]
                
                #Add context vector to cvDict
                cvIndex=len(cvDict[fileName][window])+1
                cvDict[fileName][window][cvIndex]=contextVector
    
    #Return context vector dictionary
    return(cvDict)

#Define context vector function
def get_cosine(vec1,vec2):
    intersection = set(vec1.keys()) & set(vec2.keys())
    numerator = sum([vec1[x] * vec2[x] for x in intersection])
    
    sum1 = sum([vec1[x]**2 for x in vec1.keys()])
    sum2 = sum([vec2[x]**2 for x in vec2.keys()])
    denominator = math.sqrt(sum1) * math.sqrt(sum2)
    return float(numerator/denominator)


#Define context vector simulation
def averageCosine(cvDict,fileList,wordList,sim):
    subCV={}
    cosineResults=[]
    for fileName in fileList:
        for word in cvDict[fileName].keys():
            #Add word if not in keys
            if word not in subCV.keys():
                subCV[word]={}
            for i in range(len(cvDict[fileName][word])):
                subCV[word][len(subCV[word])+1]=cvDict[fileName][word][i+1]
    for searchWord in wordList:
        try: 
            if len(subCV[searchWord])>1:
                consineSim=np.zeros(sim)
                for i in range(sim):
                    x=random.randrange(0, len(subCV[searchWord]))
                    y=random.randrange(0, len(subCV[searchWord]))
                
                    consineSim[i]=get_cosine(subCV[searchWord][x+1],subCV[searchWord][y+1])
                approx_avg_cosine=np.average(consineSim)
            else:
                approx_avg_cosine=-1
        except KeyError:
            approx_avg_cosine = np.NaN
        cosineResults.append([searchWord,approx_avg_cosine])
    return cosineResults

def retainRelevantDocs(tokensDict, targetWordList):
    newTokens = {}
    for key in tokensDict.keys():
        #print(key)
        targetWordFlag = 0
        for word in tokensDict[key]:
            if targetWordFlag == 0:
                if word in targetWordList:
                    #print(word)
                    targetWordFlag = 1

            else:
                break
        if targetWordFlag == 1:
            newTokens[key] = tokensDict[key]
    return newTokens


#Create context vector similarity simulation
def knnContextVector(cvDict,fileList,contextList,windowList,sim,k):
    
    #Define search dict for average context vectors
    searchDict={}
    
    #Ensure contextList contains all windows (also good to ensure windows are matching correcting)
    contextList=list(set(contextList+windowList))
    
    #Loop through each word contextList
    for word in contextList:
        
        #Loop through each file and perform consolidation
        for fileName in fileList:
            
            #Check if word present for this filename
            if word in cvDict[fileName].keys():
                
                #if present loop through each context vecors for word in filename
                for i in cvDict[fileName][word].keys():
                    #Add each context vector for word
                    try:
                        searchDict[word]={key:searchDict[word][key]+cvDict[fileName][word][i][key] for key in searchDict[word].keys()}
                    except:
                        searchDict[word]=cvDict[fileName][word][i]
        
        #If word was added update len to unit vector
        if word in searchDict.keys():                
            #After creating total context vector for word, normalize to unit vector
            vectorFraction=(1/np.sum([value for value in searchDict[word].values()]))
            
            #Update each value
            searchDict[word].update((k,v*vectorFraction) for k,v in searchDict[word].items())
        
        
    #Since search space if small find k+1 closest neighbors by cosine similarity
    #+1 is used because each window is present in search space as backcheck
    
    #Define size upfront as empty list
    outputList=[]
    
    #Loop through each window word
    for i in range(len(windowList)):
        window=windowList[i]
        
        if window in searchDict.keys():
        
            #Loop through each context in list
            #Get cosine similarity and add to simList
            simList=[[window,context,get_cosine(searchDict[window],searchDict[context])] for context in contextList if context in searchDict.keys()]           
                
            #Sort by max cosine simliary in place
            simList.sort(key=lambda x: x[2], reverse=True)
            
            #Add k+1 values to ouputlist
            outputList.append(simList[:k+1])
     
    #Fix format in output list
    outputList=[x for y in outputList for x in y if y !=None]     
     
    #Return output list
    return(outputList)

#Get TF for each period
def getPeriodTF(docTF, periodFiles):
    periodTF = {}
    for file in docTF.keys():
        if file in periodFiles:
            for word in docTF[file].keys():
                try:    
                    periodTF[word]=periodTF[word]+docTF[file][word]
                except KeyError:
                    periodTF[word]=docTF[file][word]
    return periodTF

##################################
######Testing function on WBC#####
##################################
#
##Get file list
#wbPath = '/home/nmvenuti/Desktop/nmvenuti_sandbox/Capstone/webscraping westboro/sermons'
#wbFileList=[infile for infile in glob.glob( os.path.join(wbPath, '*.*') )]
#
##Get tokens for wbc
#wbTokens=tokenize(wbFileList)
#            
##Get word coCo for wbc
#start=time.time()            
#wbCoCo=coOccurence(wbTokens,10)
#print(time.time()-start)
##10012.3053741 seconds
#
##
###Get DSM
#start=time.time()
##wbDSM=DSM(wbCoCo,10)
#print(time.time()-start)
#
##Remove coCo
#del wbCoCo
#
##Get context vectors
#wbCVDict=contextVectors(wbTokens,wbDSM,100)
#
##Remove tokens and DSM
#del wbTokens
#del wbDSM
#
#fileList=list(wbCVDict.keys())
##Test cosine similairty function on 'God'
#averageCosine(wbCVDict,fileList,['god','home'],1000)
