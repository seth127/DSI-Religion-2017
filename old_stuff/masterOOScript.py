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

os.chdir('./github/nmvenuti/DSI_Religion/')
#from joblib import Parallel, delayed
#import multiprocessing as mp
import os.path
import numpy as np
import pandas as pd
from datetime import datetime
sys.path.append('./prototype_python/')
import lingual as la
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

def runMaster(rawPath,groupList,crossValidate,groupSize,targetWordCount,startCount,cocoWindow,svdInt,cvWindow,netAngle,simCount):
    ###############################
    #####Raw File List Extract#####
    ###############################

    rawFileList=[]
    for groupId in groupList:
        for dirpath, dirnames, filenames in os.walk(rawPath+groupId+'/raw'):
            for filename in [f for f in filenames ]:
                if '.txt' in filename:
                    rawFileList.append([groupId,os.path.join(dirpath, filename)])

    #Make output directory
    runDirectory='./pythonOutput/coco_'+str(cocoWindow)+'_cv_'+str(cvWindow)+'_netAng_'+str(netAngle)+'_sc_'+str(startCount)
    os.makedirs(runDirectory)
    end=time.time()
    print('finished loading packages after '+str(end-start)+' seconds')
    sys.stdout.flush()
    
    
    #Perform analysis for each fold in cross validation
    for fold in range(crossValidate):                
        ###############################                
        #####Set up random binning#####
        ###############################
                        
        fileDF=pd.read_csv('./data_dsicap/test_train/fileSplit_'+str(fold)+'.csv')
        
        fileList=fileDF.values.tolist()
        fileList=[[fileList[i][1],fileList[i][2],fileList[i][3]] for i in range(len(fileList))]
        
        
        #Get set of subgroups
        subgroupList=[ list(y) for y in set((x[0],x[2]) for x in fileList) ]
        
        #Make output directory
        outputDirectory=runDirectory+'/run'+str(fold)
        os.makedirs(outputDirectory)
        
        #Print file splits to runDirectory
        fileDF.to_csv(outputDirectory+'/fileSplits.csv')

        end=time.time()
        print('finished randomly creating subgroups '+str(end-start)+' seconds')
        sys.stdout.flush()        
        
        ################################
        #####Perform group analysis#####
        ################################
        
        #Create paramList
        paramList=[[x,fileList,targetWordCount,cocoWindow,svdInt,cvWindow,simCount,startCount,netAngle] for x in subgroupList]
        
        #Run calculation 
        masterOutput=[textAnalysis(x) for x in paramList]  
        #Create output file
        outputDF=pd.DataFrame(masterOutput,columns=['groupId','files','timeRun','perPos','perNeg','perPosDoc','perNegDoc','judgementCount','judgementFrac','avgSD','avgEVC'])
        outputDF.to_csv(outputDirectory+'/masterOutput.csv')

#Set inital conditions and run
if __name__ == '__main__':
    startTimeTotal=time.time()
    rawPath = './data_dsicap/'
    groupList=['DorothyDay','JohnPiper','MehrBaba','NaumanKhan','PastorAnderson',
       'Rabbinic','Shepherd','Unitarian','WBC']
#    cocoWindow=int(sys.argv[1])
#    cvWindow=int(sys.argv[2])
#    startCount=int(sys.argv[3])
#    netAngle=int(sys.argv[4])
    cocoWindow=3
    cvWindow=3
    startCount=0
    netAngle=30
    crossValidate=1
    groupSize=10
#    testSplit=.3
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
    
    runMaster(rawPath,groupList,crossValidate,groupSize,targetWordCount,startCount,cocoWindow,svdInt,cvWindow,netAngle,simCount)
        
    endTimeTotal=time.time()
    print('finished entire run in :'+str((endTimeTotal-startTimeTotal)/60)+' minutes')
    sys.stdout.flush()

