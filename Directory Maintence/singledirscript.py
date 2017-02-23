import os
import re
os.chdir('/Users/meganstiles/Desktop/DSI_Religion/Megan_Capstone/DSI-Religion-2017/Directory Maintence/')



import getSingleDirs as gsd 

os.chdir('/Users/meganstiles/Desktop/DSI_Religion/Megan_Capstone/DSI-Religion-2017/')
filepath = 'Interns Scoring.xlsx'
olddir = './data_dsicap_FULL/'
newdir = 'data_dsicap_testagain'
newcopy = './data_dsicap_FULL_2/'
workingdir = '/Users/meganstiles/Desktop/DSI_Religion/Megan_Capstone/DSI-Religion-2017/'

gsd.getSingleDocDirs(filepath, olddir, newdir, newcopy, workingdir)

df = pd.read_csv('./refData/docRanks.csv')

for i in range(0,len(df)):
    file = re.sub('.txt', '', df['Filename'][i])
    df['Filename'][i] = file

df.to_csv('docRanks.csv')
