# -*- coding: utf-8 -*-
"""
Created on Fri Jun  3 10:11:13 2016

@author: nmvenuti
Judgements Syntactic Parsing Development
"""

#Import packages
import nltk
import nltk.data
import string
import pandas as pd
from nltk.tag.perceptron import PerceptronTagger
tagger = PerceptronTagger()

#Set up inital parameters
tokenizer = nltk.data.load('tokenizers/punkt/english.pickle')

#try:
#    tokenizer = nltk.data.load('tokenizers/punkt/english.pickle')
#except:
#    nltk.download('punkt')
#    tokenizer = nltk.data.load('tokenizers/punkt/english.pickle')
nounList=['NN','NNS','NNP','NNPS']
adjList=['JJ','JJR','JJS']
toBeList=["is","was","am","are","were","been","be","being"]
tagFilterList=['JJ','JJR','JJS','RB','RBR','RBS','WRB']


#Define packages

def readText(filepath):
    rawText=unicode(open(filepath).read(), "utf-8", errors="ignore")
    tokens=nltk.word_tokenize(rawText)
    tokenList=[]
    for token in tokens:
        try:
            tokenList.append(str(token))
        except:
            tokenList.append('**CODEC_ERROR**')
    return(' '.join(tokenList))

def judgements(txtString):
    judgementCount=0
    sentList=list(tokenizer.tokenize(txtString))
    for sent in sentList:
        tagList=tagger.tag(nltk.word_tokenize(sent))
        
        #Look for combination of noun-adj-to_be verb in order        
        nounFlag=False
        adjFlag=False

        for tag in tagList:
            #Check if noun flag activated
            if nounFlag:
                #If noun flag activated check if adj flag activated
                if adjFlag:
                    #If adjective flag activated check if word is to-be verb
                    if tag[0] in toBeList:
                        #If true, count as judgement, exit loop
                        judgementCount=judgementCount+1
                        break
                #if adj flag not activated check if tag is adjective
                else:
                    if tag[1] in adjList:
                        adjFlag=True
            #if noun flag not activated check if tag is noun
            else:
                if tag[1] in nounList:
                    nounFlag=True

    judgementPercent=float(judgementCount)/len(sentList)
    #Return metrics
    return([judgementCount,judgementPercent])

def targetWords(txtString,wordCount,startCount=0):
    tagList=tagger.tag(nltk.word_tokenize(txtString))
    targetDict={}
    for tag in tagList:
        if tag[1] in tagFilterList:
            word=str.lower(''.join([c for c in tag[0] if c not in string.punctuation]))
            #Filter out codecerrors
            if word != 'codecerror':
                try:
                    targetDict[word]=targetDict[word]+1
                except:
                    targetDict[word]=1
    targetDF=pd.DataFrame([[k,v] for k,v in targetDict.items()],columns=['word','count'])
    targetDF.sort(['count'],inplace=True,ascending=False)
    sortedTargetList=list(targetDF['word'])[startCount:wordCount+startCount]
    return(sortedTargetList)

#Test
#rawTextfile='./github/nmvenuti/DSI_Religion/data_dsicap/DorothyDay/raw/2.html.txt'
#rawText=readText(rawTextfile)
#sentList=list(tokenizer.tokenize(rawText))
#judge=judgements(rawText)