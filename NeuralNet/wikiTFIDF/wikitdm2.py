import os
import sys

import nltk
import nltk.data
from nltk.tag.perceptron import PerceptronTagger
from nltk.probability import FreqDist

#Set tokenizers, tagger and stemmer
tokenizer = nltk.tokenize.treebank.TreebankWordTokenizer()
sentTokenizer = nltk.data.load('tokenizers/punkt/english.pickle')
stemmer = nltk.stem.snowball.EnglishStemmer()
tagger = PerceptronTagger()

import pandas as pd
import string
import re

#os.chdir(sys.path[0]) # by default, sets it to the directory of this file

punctuation = set(string.punctuation)

def rawToTokenList(rawData):
    textList=nltk.word_tokenize(rawData)
    tokenList=[]
    for token in textList:
        try:
            #tokenList.append(str(token))
            #tokenList.append(unicode(token)) #### changed this to get rid of most CODEC ERRORs
            thisToken = unicode(token)
            uselessUnicode = [u'\u2013', u'\u2014', u'\u201d', u'\u201c'] ### don't include these when they are alone
            if thisToken not in uselessUnicode:
                thisToken = thisToken.replace(u'\u201d','') # delete this (unicode quote)
                thisToken = thisToken.replace(u'\u201c','') # delete this (unicode quote)
                tokenList.append(thisToken)
        except:
            tokenList.append('**CODEC_ERROR**')
            # #######################prints word on CODEC ERROR
            print('**CODEC_ERROR**')
            print(token) 
            print('****')
    return tokenList

def cleanTokens(tokenList):
    #Convert all text to lower case
    textList=[word.lower() for word in tokenList]
    
    #Remove punctuation
    textList=[word for word in textList if word not in punctuation]
    textList=["".join(c for c in word if c not in punctuation) for word in textList ]
    
    #convert digits into NUM
    textList=[re.sub("\d+", "NUM", word) for word in textList]  
    
    #Stem words 
    textList=[stemmer.stem(word) for word in textList]
    
    #Remove blanks
    textList=[word for word in textList if word!= ' ']
    textList=[word for word in textList if word!= '']
    
    #Extract tokens
    return textList

def drop_pronouns(textList):
    #print(textList)
    try:
        tags = tagger.tag(textList)
    except:
        print("%%%%%%\n!!!!!!!!!!!\nTAGGER FAILED\n!!!!!!!!!!!\n%%%%%%")
        print(textList)
        return textList
    keep = []
    for i in range(0,len(textList)):
        if (tags[i][1] != 'PRP') & (tags[i][1] != 'PRP$'):
            #pronouns.append(tags[i][0])
            keep = keep + [i]
    return [textList[i] for i in keep]

class lingualObject(object):

    def __init__(self, fileName):
        #Define parameters
        self.fileName=fileName

        self.idfFile = 'wiki-IDF/wiki-30k-10-IDF.csv'
        self.idf = pd.read_csv(self.idfFile)
        self.idf = self.idf.set_index('term')


        ######################
        ###Get text objects###
        ######################

        #define rawText, tokens, sentences, and judgements
        self.rawText={}
        self.tokens={}

        #Extract raw text and update for encoding issues            
        rawData=unicode(open(fileName).read(), "utf-8", errors="ignore")

        # tokenize and stem
        tokenList = rawToTokenList(rawData)
        txtString=' '.join(tokenList)
        self.rawText=txtString

        #Extract tokens
        self.tokens=cleanTokens(tokenList)
 

    def getKeywords(self, wordCount):
        startCount = 0
        # get all tokens for the fileName
        all_words = self.tokens

        ## create FreqDF with word frequencies from fileName
        freq = FreqDist(all_words) 
        # convert it to a data frame
        freqDF = pd.DataFrame.from_dict(freq, orient='index')
        freqDF.columns = ['freq']
        
        if noPro == True:
            terms = freqDF.index.tolist()
            keepers = drop_pronouns(terms)
            freqDF = freqDF.loc[keepers]
        
        ## merge freqDF with idf data frame
        freqit = freqDF.join(self.idf[['idf', 'logidf']])
        # replace null values with max
        maxidf = max(freqit['idf'].dropna())
        maxlogidf = max(freqit['logidf'].dropna())
        freqit.loc[pd.isnull(freqit['idf']), 'idf'] = maxidf
        freqit.loc[pd.isnull(freqit['logidf']), 'logidf'] = maxlogidf

        ## create tfidf columns
        freqit['tfidf'] = freqit['freq'] * freqit['idf']
        freqit['logtfidf'] = freqit['freq'] * freqit['logidf']

        ## order by tfidf weight
        freqit = freqit.sort_values(by='tfidf', ascending=False) 

        #filter out codecerror
        keyslist = freqit.iloc[startCount:wordCount+startCount].index.tolist()
        keywords = []
        for word in keyslist:
            if (word != 'codecerror') & (word != ''):
                keywords = keywords + [word]

	    ##
        self.keywords = keywords

    def wikitfidf(self, log = True, noPro = False):
        startCount = 0
        all_words = self.tokens


        ## create FreqDF with word frequencies from fileName
        freq = FreqDist(all_words) 
        # convert it to a data frame
        freqDF = pd.DataFrame.from_dict(freq, orient='index')
        freqDF.columns = ['freq']
        
        if noPro == True:
            terms = freqDF.index.tolist()
            keepers = drop_pronouns(terms)
            freqDF = freqDF.loc[keepers]
        
        ## merge freqDF with idf data frame
        freqit = freqDF.join(self.idf[['idf', 'logidf']])
        # replace null values with max
        maxidf = max(freqit['idf'].dropna())
        maxlogidf = max(freqit['logidf'].dropna())
        freqit.loc[pd.isnull(freqit['idf']), 'idf'] = maxidf
        freqit.loc[pd.isnull(freqit['logidf']), 'logidf'] = maxlogidf

        ## create tfidf columns
        freqit['tfidf'] = freqit['freq'] * freqit['idf']
        freqit['logtfidf'] = freqit['freq'] * freqit['logidf']

        ## order by tfidf weight
        freqit = freqit.sort_values(by='tfidf', ascending=False) 

        if log == True:
            #print(freqit[['logidf']])
            return freqit[['logtfidf']]
        else:
            return freqit[['tfidf']]

def wikitdm(textDir, log = True, saveToCsv = True, printEach = True, noPro = False):
    #
    dflist = []

    # clean out non .txt files
    #filenames = [filename for filename in os.listdir(textDir) if ".txt" in filename] ## OLD WAY
    allfiles = [os.path.join(dp, f) for dp, dn, fn in os.walk(os.path.expanduser(textDir)) for f in fn]
    filenames = [filename for filename in allfiles if ".txt" in filename]

    # print number of files (and names)
    print(str(len(filenames)) + ' documents...')
    if printEach == True:
        print(filenames)

    # loop through each document in the folder
    for filename in filenames:
        # get the tfidf for that doc
        lo = lingualObject(filename)
        docdf = lo.wikitfidf(log = log, noPro = noPro)

        # rename column as filename
        fileColName = filename.split('/')[-1].rstrip('.txt')
        try:
            docdf.rename(columns={'logtfidf':fileColName}, inplace=True)
        except:
            docdf.rename(columns={'tfidf':fileColName.split('/')[-1]}, inplace=True)
        # print top 5 keywords and shape (to see number of total unique words)
        if printEach == True:
            print(docdf.head())
            print(docdf.shape)
        # append to master list of document df's
        dflist.append(docdf)
    # concatenate all document df's into master df
    df = pd.concat(dflist, axis = 1)
    print('$$$$$$\nFINISHED! :: ' + str(df.shape[1]) + ' documents and ' + str(df.shape[0]) + ' terms\n$$$$$$')
    # write to csv file
    if saveToCsv == True:
        df.to_csv(textDir + '-wikiTFIDF.csv', encoding='utf-8')

        print('$$$$$$\nFULL TDM SAVED AS ' + textDir + '-wikiTFIDF.csv' + '\n$$$$$$')
    #
    return df

def wikidtm(textDir, log = True, saveToCsv = True, printEach = True, noPro = False):
    df = wikitdm(textDir, log = log, printEach = printEach, noPro = noPro)
    df = df.transpose()
    print('$$$$$$\nFINISHED! :: ' + str(df.shape[0]) + ' documents and ' + str(df.shape[1]) + ' terms\n$$$$$$')
    # write to csv file
    if saveToCsv == True:
        df.to_csv(textDir + '-wikiTFIDF.csv', encoding='utf-8')
        print('$$$$$$\nFULL TDM SAVED AS ' + textDir + '-wikiTFIDF.csv' + '\n$$$$$$')
    #
    return df

def wikiKeywords(filename, wordCount):
    lo = lingualObject(filename)
    lo.getKeywords(wordCount)
    return lo.keywords