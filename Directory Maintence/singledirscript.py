import os

os.chdir('./Desktop/DSI_Religion/Megan_Capstone/')



import getSingleDirs as gsd 

os.chdir('./DSI-Religion-2017/')
filepath = 'Interns Scoring.xlsx'
olddir = './data_dsicap_FULL/'
newdir = 'data_dsicap_testagain'
newcopy = './data_dsicap_FULL_2/'
workingdir = '/Users/meganstiles/Desktop/DSI_Religion/Megan_Capstone/DSI-Religion-2017/'

gsd.getSingleDocDirs(filepath, olddir, newdir, newcopy, workingdir)

