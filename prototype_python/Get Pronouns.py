import nltk
from nltk.tag import pos_tag
from nltk.tokenize import word_tokenize
from collections import Counter

def get_pronouns(text):
    pronouns= []
    tokens = nltk.word_tokenize(text.lower())
    text = nltk.Text(tokens)
    tags = nltk.pos_tag(text)
    for i in range(1,len(text)):
        if tags[i][1] == 'PRP':
            pronouns.append(tags[i][0])
        elif tags[i][1] == 'PRP$':
            pronouns.append(tags[i][0])
    print(Counter(pronouns))

text= 'My you I help me.'
get_pronouns(text)
  
