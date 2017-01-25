
# coding: utf-8

##################################################
# THIS PROGRAM TAKES A FOLDER FULL OF .txt FILES #
# AND CONVERTS IT TO A .csv WHICH CONTAINS IDF   #
# COUNTS FOR EVERY TERM IN THAT "CORPUS"         #
#                                                #
# Beware: it is not particularly optimized and   #
# can take a long time to run on any corpus      #
# larger than a few hundred documents. A more    #
# efficient version is in the works.             #
##################################################

# In[1]:

from sklearn.feature_extraction.text import CountVectorizer
import os
import sys


import numpy as np
import pandas as pd
import nltk
nltk.download('punkt')
#nltk.download('maxent_treebank_pos_tagger')
#nltk.download('averaged_perceptron_tagger')
import re
import string
import time

stemmer = nltk.stem.snowball.EnglishStemmer()

bigStart=time.time()

#########
# THE PARAMETERS
#########
#os.chdir('/Users/Seth/Documents/DSI/Capstone/DSI-Religion-2017/wiki-IDF')
#wikiPath = './wiki-i15-30k300-test'
wikiPath = './' + sys.argv[1]
threshold = int(sys.argv[2])

# ## WHERE I GOT STUFF
# 
# #### the custom function
# http://slendermeans.org/ml4h-ch4.html
# 
# #### the documentation for CountVectorizer
# http://scikit-learn.org/stable/modules/generated/sklearn.feature_extraction.text.CountVectorizer.html
# 

# In[2]:

def sklearn_tdm_df(docs, **kwargs):
    '''
    Create a term-document matrix (TDM) in the form of a pandas DataFrame
    Uses sklearn's CountVectorizer function.

    Parameters
    ----------
    docs: a sequence of documents (files, filenames, or the content) to be
        included in the TDM. See the `input` argument to CountVectorizer.
    **kwargs: keyword arguments for CountVectorizer options.

    Returns
    -------
    tdm_df: A pandas DataFrame with the term-document matrix. Columns are terms,
        rows are documents.
    '''
    # Initialize the vectorizer and get term counts in each document.
    vectorizer = CountVectorizer(**kwargs)
    word_counts = vectorizer.fit_transform(docs)

    # .vocabulary_ is a Dict whose keys are the terms in the documents,
    # and whose entries are the columns in the matrix returned by fit_transform()
    vocab = vectorizer.vocabulary_

    # Make a dictionary of Series for each term; convert to DataFrame
    count_dict = {w: pd.Series(word_counts.getcol(vocab[w]).data) for w in vocab}
    tdm_df = pd.DataFrame(count_dict).fillna(0)
    #return tdm_df
    return count_dict


# In[3]:

# Call the function on e-mail messages. The token_pattern is set so that terms are only
# words with two or more letters (no numbers or punctuation)

# message_tdm = sklearn_tdm_df(train_df['message'],
#                             stop_words = 'english',
#                             charset_error = 'ignore',
#                             token_pattern = '[a-zA-Z]{2,}')


# In[4]:

wikiFiles = os.listdir('./'+wikiPath)
print('first 5 files in ' + wikiPath)
print(wikiFiles[:5])


# In[ ]:




# ## the non-tokenized version

# In[5]:

#VEC = CountVectorizer(input='filename')
#os.chdir('/Users/Seth/Documents/DSI/Capstone/DSI-Religion-2017/wiki-IDF/wiki-i15-30k300-test')
#tdm = VEC.fit_transform(wikiFiles)
#tdm.shape


# ## THE REAL THING

# In[6]:

def tokeNstem(files):
    #import re
    #import string
    #import time
    #
    punctuation = set(string.punctuation)
    start=time.time()
    tokens = {}
    count = 0
    totalFiles = len(files)
    #
    for fileName in files:
        # increment count for updates
        count += 1
        if (count % 500 == 0):
            print('$$$$ FINISHED ' + str(count) + ' of ' + str(totalFiles) + ' docs in ' + str(time.time()-start) + ' seconds')
        #Extract raw text and update for encoding issues            
        rawData=unicode(open(fileName).read(), "utf-8", errors="ignore")
        textList=nltk.word_tokenize(rawData)
        tokenList=[]
        for token in textList:
            try:
                tokenList.append(str(token))
            except:
                tokenList.append('**CODEC_ERROR**')
        
        #Convert all text to lower case
        textList=[word.lower() for word in tokenList]

        #Remove punctuation
        #textList=[word for word in textList if word not in punctuation]
        #textList=["".join(c for c in word if c not in punctuation) for word in textList ]

        #convert digits into NUM
        textList=[re.sub("\d+", "NUM", word) for word in textList]  

        #Stem words
        textList=[stemmer.stem(word) for word in textList]

        #Remove blanks
        textList=[word for word in textList if word!= ' ']
            
        #Extract tokens
        tokens[fileName]=textList
    #
    end=time.time()
    print('** finished with ' + str(len(tokens.keys())) + ' documents in ' + str(end-start) + ' seconds')
    #
    return tokens


# In[7]:

os.chdir(wikiPath)
testTokens = tokeNstem(wikiFiles)


# In[8]:

#testTokens['Bulgaria.txt']


# #### got this below from
# http://stackoverflow.com/questions/35867484/pass-tokens-to-countvectorizer/38986703

# In[9]:

#VEC = CountVectorizer(input='filename')

VEC = CountVectorizer(
      # so we can pass it strings
      input='content',
      # turn off preprocessing of strings to avoid corrupting our keys
      lowercase=False,
      preprocessor=lambda x: x,
      # use our token dictionary
      tokenizer=lambda key: testTokens[key])



# In[10]:

#tdm = VEC.fit_transform(wikiFiles)
tdm = VEC.fit_transform(testTokens.keys())


# In[11]:

#print(tdm.shape)


# In[12]:

vocab = VEC.vocabulary_
# Make a dictionary of Series for each term; convert to DataFrame
count_dict = {w: pd.Series(tdm.getcol(vocab[w]).data) for w in vocab}
#print(count_dict.keys())


# In[13]:

#####
def makeFreqDict(count_dict):
    import string
    import time
    #
    print('%%%%%%\nRUNNING makeFreqDict\n%%%%%%')
    start=time.time()
    freqDict = {}
    count = 0
    totalTerms = len(count_dict.keys())
    #
    for key in count_dict.keys():
        # increment count for updates
        count += 1
        if (count % 1000 == 0):
            print('$$$$ FINISHED ' + str(count) + ' of ' + str(totalTerms) + ' docs in ' + str(time.time()-start) + ' seconds')
        freqDict[key] = len(count_dict[key])
    #
    end=time.time()
    print('*** finished with ' + str(totalTerms) + ' terms in ' + str(end-start) + ' seconds')
    #
    return freqDict

freqDict = makeFreqDict(count_dict)


## THE OLD THING
#freqDict = {}
#for key in count_dict.keys():
#    freqDict[key] = len(count_dict[key])

#print(freqDict) ## I double checked this by searching a few keys in the finder and it looked good


# In[14]:

countDF = pd.DataFrame(freqDict.items(), columns=['term', 'freq'])
countDF = countDF.set_index('term')
#print(countDF.head())


# In[15]:

#print(countDF[countDF['freq'] > 1].shape)
DF = countDF[countDF['freq'] >= threshold]


# In[16]:

print(DF.shape)


# In[17]:

M = len(wikiFiles)
DF['idf'] = M / DF['freq']


# In[18]:

import math

#### use this approach and hard code the log base is you want something other than e
def getLog(num):
    return math.log(num, 2) # put in log base here (where the 2 is)

#countDF['logidf'] = countDF['idf'].apply(getLog) 

#### or just use this if you just want natural log
DF['logidf'] = DF['idf'].apply(math.log) 


# In[ ]:




# In[20]:

#print(DF.sort_values(by='idf').head(20))


# In[21]:
print('THE RAREST WORDS:')
print(DF.sort_values(by='idf', ascending=False).head(20))


# In[ ]:

print('%%%%%%\nFINISHED, with ' + str(DF.shape[0]) + ' terms in ' + str(time.time()-bigStart) + ' seconds')


# In[23]:

#DF.to_csv('/Users/Seth/Documents/DSI/Capstone/DSI-Religion-2017/wiki-IDF/wiki-IDF.csv', encoding='utf-8')
wps = wikiPath.split('-') # split the wikiPath to get the parameter id
DF.to_csv('wiki-' + wps[len(wps)-1] + '-' + str(threshold) +  '-IDF.csv', encoding='utf-8')


# In[ ]:



