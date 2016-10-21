import pandas as pd
import numpy as np
import os

def newDocsToDF(rawPath): ### rawPath is where you folders of documemnts are, organized as [groupName]/raw/...
	# get groups in 
	groups = os.listdir(rawPath)

	# remove these red herrings if necessary
	naw = ['.DS_Store', 'test_train']
	[groups.remove(x) for x in groups if x in naw]

	# create list of all files in those directories
	rawFileList=[]
	for groupId in groups:
		for dirpath, dirnames, filenames in os.walk(rawPath+groupId+'/raw'):
			for filename in [f for f in filenames ]:
				if '.txt' in filename:
					rawFileList.append([groupId,os.path.join(dirpath, filename),'test-'+id_generator()])

    # create data frame
	newDocsDF = pd.DataFrame(rawFileList, columns=["group","filepath","subgroup"])
	#print(newDocsDF)
	return newDocsDF
	

#newDocsToDF('./data_dsicap/fake_data/')