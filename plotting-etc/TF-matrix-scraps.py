all_words = ['these', 'are', 'all', 'the', 'words', 'they', 'are', 'words']

from nltk.probability import FreqDist
import pandas as pd

freq = FreqDist(all_words) ## create FreqDist object with word frequencies
#
columns_obj = ["term", "freq"]
freqDF = pd.DataFrame(freq.items(), columns=columns_obj) # convert it to a data frame
freqDF = freqDF.set_index('term')
print('freqDF ' + str(freqDF.shape))
print(freqDF.head(5))