import re
import string

pronouns = ['me', 'you', 'i']
keywords = ['holy', 'seal', 'home', 'love']
text = ("you and i. holy me. i love you! take back the world!")
#sentences = re.split('[?.,/!]', text)  

def get_pronoun_sentence_count( text, keywords, pronouns):
sentences= re.split('[?.,/!]', text)
sent_keywords = []
#for key in keywords:        
for sentence in sentences:        
    #print(sentence)
    for key in keywords:
        #print(key)
        if key in sentence:
            #print('yes')
            for pronoun in pronouns:
                if pronoun in sentence:
                    sent_keywords.append(sentence)
                    break
      
     
            #sent_keywords.append(item)
        
get_pronoun_sentence_count(text, keywords)
