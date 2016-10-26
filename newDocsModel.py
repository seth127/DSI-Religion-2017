# -*- coding: utf-8 -*-
"""
Created on Tue Jul 19 16:14:43 2016

@author: nmvenuti
"""

# -*- coding: utf-8 -*-
"""
Created on Thu Jun  2 15:23:11 2016

@author: nmvenuti
"""
import time
start=time.time()
import sys, os

os.chdir('/Users/Seth/Documents/DSI/Capstone/DSI-Religion-2017')
#from joblib import Parallel, delayed
#import multiprocessing as mp
import os.path
import numpy as np
import pandas as pd
from datetime import datetime
sys.path.append('./prototype_python/')
#import lingual as la
import lingualPrinting as la
import nltk
nltk.download('punkt')
nltk.download('maxent_treebank_pos_tagger')
nltk.download('averaged_perceptron_tagger')


end=time.time()
#sys.stdout = open("output.txt", "a")
print(str(datetime.now()))
print('finished loading packages after '+str(end-start)+' seconds')
sys.stdout.flush()


stemmer = nltk.stem.snowball.EnglishStemmer()

##### FOR THE MODELING
from sklearn.preprocessing import StandardScaler
from sklearn import svm
from sklearn.ensemble import RandomForestRegressor
import time
#from sknn import mlp

#
import getNewDocs as gnd

#for generating id's for different test runs
import random
import string
def id_generator(size=6, chars=string.ascii_uppercase + string.digits):
    return ''.join(random.choice(chars) for _ in range(size))

################################
### ########
# GETTING SIGNALS (copied from masterOOscript.py)
###########
################################

##########################
#####Define Functions#####
##########################
def textAnalysis(paramList):
    startTime=time.time()
    groupId=paramList[0]
    fileList=paramList[1]
    targetWordCount=paramList[2]
    cocoWindow=paramList[3]
    svdInt=paramList[4]
    cvWindow=paramList[5]
    simCount=paramList[6]
    startCount=paramList[7]
    netAngle=paramList[8]    
    
    #Get list of subfiles
    subFileList=[x[1] for x in fileList if x[0]==groupId[0] and x[2]==groupId[1]]
    
    #Create lingual object
    loTest=la.lingualObject(subFileList)

    #Get coco
    loTest.getCoco(cocoWindow)
    
    #Get DSM
    loTest.getDSM(svdInt)
    
    #Set keywords
    loTest.setKeywords('adjAdv',targetWordCount,startCount)

    #######################            
    ###Semantic analysis###
    #######################
    
    #Get context vectors
    loTest.getContextVectors(cvWindow)
    
    #Get average semantic density
    avgSD=np.mean([x[1] for x in loTest.getSD(simCount)])
    
    ########################################
    ###POS Tagging and Judgement Analysis###
    ########################################
    judgementAvg=list(np.mean(np.array([[x[1],x[2]] for x in loTest.getJudgements()]),axis=0))
    
    ########################
    ###Sentiment Analysis###
    ########################

    sentimentList=loTest.sentimentLookup()
    
    ############################
    ###Network Quantification###
    ############################
    loTest.setNetwork(netAngle)
    
    avgEVC=loTest.evc()
    
    endTime=time.time()
    timeRun=endTime-startTime
    print('finished running'+'_'.join(groupId)+' in '+str(end-start)+' seconds')
    sys.stdout.flush()

    #Append outputs to masterOutput
    return(['_'.join(groupId)]+[len(subFileList),timeRun]+sentimentList+judgementAvg+[avgSD]+[avgEVC])   

def runMaster(rawPath,runDirectory,paramPath,runID,groupList,groupSize,targetWordCount,startCount,cocoWindow,svdInt,cvWindow,netAngle,simCount):
    ###############################
    #####Raw File List Extract#####
    ###############################

    #rawFileList=[]
    #for groupId in groupList:
    #    for dirpath, dirnames, filenames in os.walk(rawPath+groupId+'/raw'):
    #        for filename in [f for f in filenames ]:
    #            if '.txt' in filename:
    #                rawFileList.append([groupId,os.path.join(dirpath, filename)])

    #Make output directory
    #paramPath = 'coco_'+str(cocoWindow)+'_cv_'+str(cvWindow)+'_netAng_'+str(netAngle)+'_sc_'+str(startCount)
    #runDirectory='./pythonOutput/' + paramPath + '-' + runID
    #runDirectory='./modelOutput/'
    #os.makedirs(runDirectory)
    end=time.time()
    print('finished loading packages after '+str(end-start)+' seconds')
    sys.stdout.flush()
    
                  
    ###############################                
    #####Set up random binning#####
    ###############################
                    
    ##### GET THE FILES SPLITS FOR THE NEW RAW DATA
    #'./pythonOutput/run1/cleanedOutput/coco_3_cv_3_netAng_30_sc_0/run0/fileSplits.csv'   
    #'./data_dsicap/test_train/fileSplits.csv'            
    #fileDF=pd.read_csv('./data_dsicap/test_train/fileSplits.csv') #################### WHERE THE NEW FILES ARE
    fileDF=gnd.newDocsToDF('./data_dsicap/', bin=5) ################################### WHERE THE NEW FILES ARE
    
    fileList=fileDF.values.tolist()

    fileList=[[fileList[i][0],fileList[i][1],fileList[i][2]] for i in range(len(fileList))]
    
    
    #Get set of subgroups
    subgroupList=[ list(y) for y in set((x[0],x[2]) for x in fileList) ]
    
    #Make output directory
    #outputDirectory=runDirectory
    #os.makedirs(outputDirectory)
    print('%%%%%%\nrunID: ' + runID + '\n%%%%%%')
    
    #Print file splits to runDirectory
    fileDF.to_csv(runDirectory+'fileSplits-' + runID + '.csv')

    #end=time.time()
    #print('finished randomly creating subgroups '+str(end-start)+' seconds')
    #sys.stdout.flush()        
    
    ################################
    #####Perform group analysis#####
    ################################
    
    #Create paramList
    paramList=[[x,fileList,targetWordCount,cocoWindow,svdInt,cvWindow,simCount,startCount,netAngle] for x in subgroupList]
    
    #Run calculation 
    masterOutput=[textAnalysis(x) for x in paramList]  
    #Create output file
    outputDF=pd.DataFrame(masterOutput,columns=['groupId','files','timeRun','perPos','perNeg','perPosDoc','perNegDoc','judgementCount','judgementFrac','avgSD','avgEVC'])
    #Output that file 
    outputDF.to_csv(runDirectory+'signalOutput' + paramPath + '-' + runID + '.csv') #### used to save it
    #print(outputDF)
    outputDF['groupId'].replace('train','test1', regex=True, inplace=True) 
    return outputDF

############
######################
#Set inital conditions and run
######################
############

#if __name__ == '__main__':
startTimeTotal=time.time()
rawPath = './data_dsicap/' ###############change this eventually
runDirectory='./modelOutput/'
#groupList=['DorothyDay','JohnPiper','MehrBaba','NaumanKhan','PastorAnderson',
#   'Rabbinic','Shepherd','Unitarian','WBC']
groupList=['DorothyDay','NaumanKhan','Rabbinic','NawDawg','SeaShepherds','IntegralYoga','Bahai']
#cocoWindow=int(sys.argv[1])
#cvWindow=int(sys.argv[2])
#startCount=int(sys.argv[3])
#netAngle=int(sys.argv[4])
cocoWindow=3
cvWindow=3
startCount=0
netAngle=30
groupSize=10
#testSplit=.3
targetWordCount=10
svdInt=50
simCount=1000
print('cocoWindow '+str(cocoWindow))
sys.stdout.flush()
print('cvWindow '+str(cvWindow))
sys.stdout.flush()
print('netAngle '+str(netAngle))
sys.stdout.flush()
print('startCount '+str(startCount))
sys.stdout.flush()

# define the file path with identifying parameters
paramPath = 'coco_'+str(cocoWindow)+'_cv_'+str(cvWindow)+'_netAng_'+str(netAngle)+'_sc_'+str(startCount)
# define the random ID for this run
runID = id_generator()

newTestDF = runMaster(rawPath,runDirectory, paramPath,runID,groupList,groupSize,targetWordCount,startCount,cocoWindow,svdInt,cvWindow,netAngle,simCount)

endTimeTotal=time.time()
print('finished entire run in :'+str((endTimeTotal-startTimeTotal)/60)+' minutes')
sys.stdout.flush()


################################
### ########
# THE MODEL (copied from individualModel.py)
###########
################################

startTime=time.time()

################################
#####Import and clean data######
################################

def addRank(signalDF):  ########## NEED TO ADD ANY NEW GROUPS TO THIS LIST BEFORE YOU TEST THEM
    #Add in group ranking
    groupNameList=['WBC', 'PastorAnderson', 'NaumanKhan', 'DorothyDay', 'JohnPiper', 'Shepherd',
    'Rabbinic', 'Unitarian', 'MehrBaba','NawDawg','SeaShepherds','IntegralYoga','Bahai']
    groupRankList=[1,2,3,4,4,4,6,7,8,4,2,7,6]
    
    groupRankDF=pd.DataFrame([[groupNameList[i],groupRankList[i]] for i in range(len(groupNameList))],columns=['groupName','rank'])
    
    signalDF['groupName']=signalDF['groupId'].map(lambda x: x.split('_')[0]) # splits the name off the groupID column value
    
    signalDF=signalDF.merge(groupRankDF, on='groupName')

    return(signalDF)



#Get data frame for each cut
#signalDF=pd.read_csv('./github/nmvenuti/DSI_Religion/pythonOutput/coco_3_cv_3_netAng_30_sc_0/run0/masterOutput.csv')
#signalDF=pd.read_csv('/Users/Seth/Documents/DSI/Capstone/2016-group/cloneOf2016Code/pythonOutput/run1/cleanedOutput/coco_3_cv_3_netAng_30_sc_0/run0/masterOutput.csv')
signalDF=pd.read_csv('./pythonOutput/run1/cleanedOutput/coco_3_cv_3_netAng_30_sc_0/run0/masterOutput.csv', index_col=0)

### MAKES THEM ALL TRAINING
signalDF['groupId'].replace('test','train1', regex=True, inplace=True) 

######## NOW COMINE WITH NEW TESTING DF (signalDFL and newTestDF)
signalDF = signalDF.append(newTestDF)

print('tests pre-addRank')
print(signalDF[signalDF['groupId'].str.contains("test")].shape)

#add rankings # NOTE: if a group isn't included in the addRank() def above, the observation is DELETED
signalDF=addRank(signalDF)

print('tests post-addRank pre-setup')
print(signalDF[signalDF['groupId'].str.contains("test")].shape)


#Set up modeling parameters
xList=['perPos','perNeg','perPosDoc','perNegDoc','judgementFrac','judgementCount','avgSD', 'avgEVC']
yList=['rank']
#remove groups with less than 5 files #### WE CANCELLED THIS TO TEST SINGLE DOCS
#signalDF=signalDF[signalDF['files']>5]
signalDF=signalDF.dropna()

print('tests post-setup')
print(signalDF[signalDF['groupId'].str.contains("test")].shape)


#Set up test train splits
trainIndex=[x for x in signalDF['groupId'] if 'train' in x]
testIndex=[x for x in signalDF['groupId'] if 'test' in x]


signalTrainDF=signalDF[signalDF['groupId'].isin(trainIndex)]
print('%%%%%%\nsignalTrainDF\n%%%%%%')
print(signalTrainDF.shape)

signalTestDF=signalDF[signalDF['groupId'].isin(testIndex)]
print('%%%%%%\nsignalTestDF\n%%%%%%')
print(signalTestDF.shape)


yActual=signalTestDF['rank'].tolist()

                        

#Random Forest Regressor
rfModel=RandomForestRegressor(n_estimators=10,max_depth=10,
                              min_samples_split=1, max_features='auto',
                              random_state=0,n_jobs=-1)

rfModel.fit(signalTrainDF[xList],signalTrainDF[yList])

#Predict New Data
yPred=rfModel.predict(signalTestDF[xList])

# save predictions in TestDF
signalTestDF.loc[:,'rfPred'] = yPred.tolist()

#Get accuracy
rfAccuracy=float(len([i for i in range(len(yPred)) if abs(yActual[i]-yPred[i])<1])/float(len(yPred)))
rfMAE=np.mean(np.abs(yActual-yPred))        
#Perform same analysis with scaled data
#Scale the data
sc = StandardScaler()
sc=sc.fit(signalTrainDF[xList])
signalStdTrainDF= pd.DataFrame(sc.transform(signalTrainDF[xList]),columns=xList)
signalStdTestDF = pd.DataFrame(sc.transform(signalTestDF[xList]),columns=xList)
signalSVR=svm.SVR(C=3,epsilon=0.1,kernel='rbf',max_iter=100000)
signalSVR.fit(signalStdTrainDF[xList],signalTrainDF[yList])

#Predict New Data
yPred=signalSVR.predict(signalStdTestDF[xList])

#Get accuracy
svmAccuracy=float(len([i for i in range(len(yPred)) if abs(yActual[i]-yPred[i])<1])/float(len(yPred)))
svmMAE=np.mean(np.abs(yActual-yPred))
            
# create output csv
signalTestDF.loc[:,'svmPred'] = yPred.tolist()
outputName = runDirectory + 'modelPredictions-' + paramPath + '-' + runID + '.csv'
print('%%%%%%\nALL DONE!\n' + outputName + '\n' + str(signalTestDF.shape) + '\n%%%%%%')
signalTestDF.to_csv(outputName)
