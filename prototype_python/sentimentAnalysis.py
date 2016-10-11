# -*- coding: utf-8 -*-
"""
Created on Mon Jun  6 11:38:46 2016

@author: nmvenuti
Sentiment Analysis
"""

#Import packages
import sys
import numpy as np
sys.path.append('./prototype_python/')
#import syntacticParsing as sp
import semanticDensity as sd

#Get sentimentWord dict and remove duplicates. Store in lists
posFilePath='./refData/positive-words.txt'
negFilePath='./refData/negative-words.txt'
sentDict=sd.tokenize([posFilePath,negFilePath])
posWords=list(set(sentDict[posFilePath]))
negWords=list(set(sentDict[negFilePath]))

#Define packages

def sentimentLookup(tokens):
    fileSentiment=[]
    #Get sentiment for each document
    for filename in tokens.keys():
        
        #initialize counters
        wordCount=0.0
        posCount=0.0
        negCount=0.0
        
        #Get counts
        for token in tokens[filename]:
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
    wordSentiment=np.mean(np.array(fileSentiment),axis=0)
    
    #Calculate sub-group level doc sentiment percent
    posDocCount=float(len([x for x in fileSentiment if x[0]>x[1]]))
    posDocPer=posDocCount/len(fileSentiment)
    negDocPer=1-posDocPer
    output=[wordSentiment[0],wordSentiment[1],posDocPer,negDocPer]   
    
    return(output)