import os
import sys
import random

threshold = sys.argv[1]

#os.remove()
rawPath = '/Users/Seth/Documents/DSI/Capstone/DSI-Religion-2017/data_dsicap_EVEN/'

# get groups in 
groups = os.listdir(rawPath)

# remove these red herrings if necessary
naw = ['.DS_Store', 'test_train', 'norun', 'fake_data', 'ref']
[groups.remove(x) for x in groups if x in naw]
print(groups)
#
#rawFileList=[]
for groupId in groups:
    for dirpath, dirnames, filenames in os.walk(rawPath+groupId+'/raw'):
        ## clean out non .txt files
        filenames = [filename for filename in filenames if ".txt" in filename]
        print(groupId + ' ' + str(len(filenames)) + ' files')
        # if more than 50 docs, randomly delete a bunch
        if len(filenames) > threshold:
            print('TOO MANY')
            keepers = random.sample(filenames, threshold)
            print(keepers)
            #losers = [x for x in filenames if x not in keepers]
            #print(len(losers))
            for thisFile in filenames:
                if thisFile not in keepers:
                    os.remove(rawPath+groupId+'/raw/'+thisFile)
