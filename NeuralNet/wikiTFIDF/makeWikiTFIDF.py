from wikitdm2 import *
import pandas as pd

textDir = '/Users/Seth/Documents/DSI/Capstone/DSI-Religion-2017/data_dsicap_single'

wikiIDF = wikidtm(textDir, saveToCsv=False)

docRanks = pd.read_csv('/Users/Seth/Documents/DSI/Capstone/DSI-Religion-2017/refData/docRanks.csv', index_col=1)

print('wikiidf\n' + str(wikiIDF.shape))
print('docranks\n' + str(docRanks.shape))
print('wikiidf\n' + str(wikiIDF.index))
print('docranks\n' + str(docRanks.index))


bigDF = pd.concat([docRanks['rank'], wikiIDF], axis=1, join='inner')
print('bigDF\n' + str(bigDF.shape))
bigDF.to_csv(textDir + '-wikiTFIDF-with-ranks.csv', encoding='utf-8')
#print(filenames)
print('done')

#import pandas as pd
#bigDF = pd.read_csv('/Users/Seth/Documents/DSI/Capstone/DSI-Religion-2017/NeuralNet/wikiTFIDF/data_dsicap_single-wikiTFIDF-with-ranks.csv', index_col=0)
#bigDF[[:5]].head()