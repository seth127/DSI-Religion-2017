import os
import pandas as pd
import re

os.chdir('/Users/meganstiles/Desktop/github/DSI-Religion-2017/modelOutput/logs/')

signals = pd.read_csv('signalOutput-coco_3_cv_3_netAng_30_twc_10_tfidfNoPro_pronoun_bin_10-X7UCES.csv')

signals = signals.drop(signals.columns [[0,2,3,4,]], axis=1)


#Read in Rank filte
os.chdir('/Users/meganstiles/Desktop/github/DSI-Religion-2017/refData/')
ranks = pd.read_csv('groupRanksBinned.csv') 



#Remove test/train from GroupID
for i in range(0,len(signals)):
    name = signals['groupId'][i]
    name = re.sub('_train[0-9]*', '', str(name))
    name = re.sub('_test[0-9]*', '', name)
    signals['groupId'][i] = name


#Merge Group Ranks
clean = pd.merge(signals, ranks, how = 'inner', on='groupId') 

#Change Dir 

os.chdir('/Users/meganstiles/Desktop/github/DSI-Religion-2017/signalFiles/')

clean.to_csv('binnedSignals3.csv')



