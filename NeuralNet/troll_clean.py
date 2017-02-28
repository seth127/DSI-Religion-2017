import pandas as pd
import numpy as np
import csv
import os

import lingualTF as la

# Text Data
from bs4 import BeautifulSoup
import re
import nltk
from nltk import pos_tag
#from nltk.stem import WordNetLemmatizer
from nltk.corpus import wordnet #, stopwords
#from sklearn.feature_extraction.text import TfidfVectorizer
#from io import StringIO


# ## Stopwords
# Include 
import nltk

#nltk.download("stopwords")
nltk.download("wordnet")
nltk.download("maxent_treebank_pos_tagger")


  
# Function for POS tagging

def get_wordnet_pos(tagged):
    treebank_tag = nltk.pos_tag(tagged)
    if treebank_tag[0][1].startswith('J'):
        return '_pos_' + wordnet.ADJ
    elif treebank_tag[0][1].startswith('V'):
        return '_pos_' + wordnet.VERB
    elif treebank_tag[0][1].startswith('N'):
        return '_pos_' + wordnet.NOUN
    elif treebank_tag[0][1].startswith('R'):
        return '_pos_' + wordnet.ADV
    else:
        #return '_pos_' + wordnet.NOUN
        return '_pos_UNK'

def pos_with_val(self):
    print('nothing happens yet, havent write the function')
