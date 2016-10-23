import pandas as pd
import numpy as np
import os

import math
from itertools import repeat



def newDocsToDF(rawPath, bin=5): ### rawPath is where you folders of documemnts are, organized as [groupName]/raw/...
	# get groups in 
	groups = os.listdir(rawPath)

	# remove these red herrings if necessary
	naw = ['.DS_Store', 'test_train']
	[groups.remove(x) for x in groups if x in naw]

	# create list of all files in those directories
	#rawFileList=[]
	#for groupId in groups:
	#	for dirpath, dirnames, filenames in os.walk(rawPath+groupId+'/raw'):
	#		for filename in [f for f in filenames ]:
	#			if '.txt' in filename:
	#				rawFileList.append([groupId,os.path.join(dirpath, filename),'test-'+id_generator()])

	#
	rawFileList=[]
	for groupId in groups:
		for dirpath, dirnames, filenames in os.walk(rawPath+groupId+'/raw'):
			## clean out non .txt files
			filenames = [filename for filename in filenames if ".txt" in filename]
			## create subgroups
			filecount = len(filenames) # how many files are there in this groupId
			bincount = math.ceil(filecount/float(bin)) # how many bins do we need
			subgroups = ['test' + str(num) for num in range(0,int(bincount))] # create bins
			sglist = [x for item in subgroups for x in repeat(item, bin)] # make list of bins (copy each option 5x (or whatever you put in the bin=))
			sglist = sglist[:filecount] # trim to the number of files you have
			np.random.shuffle(sglist) # shuffle them before assigning (CHANGE THIS IF WE MAKE IT TEMPORAL)
			## append to rawFileList
			#for filename in filenames:
			#    rawFileList.append([groupId,os.path.join(dirpath, filename), 't'])
			for i in range(0,filecount):
				rawFileList.append([groupId,os.path.join(dirpath, filenames[i]), sglist[i]])

    # create data frame
	newDocsDF = pd.DataFrame(rawFileList, columns=["group","filepath","subgroup"])
	#print(newDocsDF)
	return newDocsDF
	

#newDocsToDF('./data_dsicap/fake_data/')