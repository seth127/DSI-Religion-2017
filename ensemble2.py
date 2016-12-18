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

#########
#
# THE DEFAULT SETTINGS (called manually) ARE
#
# python ensemble2.py data_dsicap 3 3 30 10 tfidfNoPro pronoun 10
#
# rawPath cocoWindow cvWindow netAngle targetWordCount keywordMethod judgementMethod binSize
# 
#########

import time
start=time.time()
import sys, os

# set working directory to directory containing prototype_python/ and the folder with the data, etc.
#os.chdir('/Users/Seth/Documents/DSI/Capstone/DSI-Religion-2017')
os.chdir(sys.path[0]) # by default, sets it to the directory of this file

#from joblib import Parallel, delayed
#import multiprocessing as mp
import os.path
import numpy as np
import pandas as pd
from datetime import datetime
sys.path.append('./prototype_python/')

import nltk
nltk.download('punkt')
nltk.download('maxent_treebank_pos_tagger')
nltk.download('averaged_perceptron_tagger')

import lingual as la

end=time.time()
#sys.stdout = open("output.txt", "a")
print(str(datetime.now()))
print('finished loading packages after '+str(end-start)+' seconds')
sys.stdout.flush()

stemmer = nltk.stem.snowball.EnglishStemmer()

#
import getNewDocs as gnd


##### FOR THE MODELING
from sklearn.preprocessing import StandardScaler
from sklearn import svm
from sklearn.ensemble import RandomForestRegressor
from sklearn.ensemble import RandomForestClassifier
import time
#from sknn import mlp

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
    #loTest.setKeywords('adjAdv',targetWordCount,startCount)


    print('%%%%\nUSING ' + keywordMethod + ' KEYWORDS')
    loTest.setKeywords(keywordMethod,targetWordCount,startCount)
    print(loTest.keywords)
 

    keywordPicks = ', '.join(loTest.keywords) 

    #######################            
    ###Semantic analysis###
    #######################
    
    #Get context vectors
    loTest.getContextVectors(cvWindow)
    
    #Get average semantic density
    avgSD=np.mean([x[1] for x in loTest.getSD(simCount)])
    
    ########################################
    ###POS Tagging and Judgment Analysis###
    ########################################

    # Pronoun Specific Judgments
    PSJudgeWithCount=list(np.mean(np.array([[x[1],x[2]] for x in loTest.pronounSpecificJudgements()]),axis=0))
    PSJudge = PSJudgeWithCount[1]
    print('Printing Pronoun Specific Judgments')
    print(PSJudge)


    #judgementAvg=list(np.mean(np.array([[x[1],x[2]] for x in loTest.getJudgements(judgementMethod)]),axis=0))
    if judgementMethod == 'both':
        toBeAverage=list(np.mean(np.array([[x[1],x[2]] for x in loTest.getJudgements('tobe')]),axis=0))
        pronounAverage=list(np.mean(np.array([[x[1],x[2]] for x in loTest.getJudgements('pronoun')]),axis=0))
        print('toBeAverage')
        print(toBeAverage)
        print('pronounAverage')
        print(pronounAverage)
        # assign fraction score from each
        judgementAvg = [toBeAverage[1]] + [pronounAverage[1]]
    elif judgementMethod == 'bothAll':
        toBeAverage=list(np.mean(np.array([[x[1],x[2]] for x in loTest.getJudgements('tobe')]),axis=0))
        pronounAverage=list(np.mean(np.array([[x[1],x[2]] for x in loTest.getJudgements('pronoun')]),axis=0))
        print('toBeAverage')
        print(toBeAverage)
        print('pronounAverage')
        print(pronounAverage)
        # assign both scores from each
        judgementAvg = toBeAverage + pronounAverage
    elif judgementMethod == 'pronounFrac':
        pronounAverage=list(np.mean(np.array([[x[1],x[2]] for x in loTest.getJudgements('pronoun')]),axis=0))
        print('pronounAverage')
        print([pronounAverage[1]])
        # assign both scores from each
        judgementAvg = [pronounAverage[1]]
    else:   
        judgementAvg=list(np.mean(np.array([[x[1],x[2]] for x in loTest.getJudgements(judgementMethod)]),axis=0))
        print(judgementMethod)
        print(judgementAvg)




    ############################
    ####PRONOUN COUNTS##########
    ############################

    pronounCounts = loTest.getPronouns()


    ##########################################
    #### PRONOUN SPECIFIC JUDGEMENTS #########
    ##########################################

    #pronounSpecificJudgements = loTest.pronounSpecificJudgements()

    # NEED TO PUT IN THE COLUMNS NAMES VECTOR TOO
    

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
    print('finished running'+'_'.join(groupId)+' in '+str(timeRun)+' seconds')
    sys.stdout.flush()

    #Append outputs to masterOutput
    return(['_'.join(groupId)]+[len(subFileList),timeRun]+[keywordPicks]+sentimentList+[PSJudge]+judgementAvg+pronounCounts+[avgSD]+[avgEVC])   

def runMaster(rawPath,writeDirectory,paramPath,runID,binSize,targetWordCount,startCount,cocoWindow,svdInt,cvWindow,netAngle,simCount):
    ###############################
    #####Raw File List Extract#####
    ###############################
                    
    ##### GET THE FILES SPLITS FOR THE NEW RAW DATA (set bin to desired bin size or 1 for single docs)
    fileDF=gnd.newDocsToDF(rawPath, bin=binSize, tt='tt') ########################### WHERE THE NEW FILES ARE
    
    #print randomly generated ID for later reference
    print('%%%%%%\nrunID: ' + runID + '\n' + paramPath + '\n%%%%%%')
    
    #Write file splits to writeDirectory
    fileDF.to_csv(writeDirectory+'logs/fileSplits-' + runID + '.csv')

    # create fileList and subgroupList
    fileList=fileDF.values.tolist()

    fileList=[[fileList[i][0],fileList[i][1],fileList[i][2]] for i in range(len(fileList))]
    
    #Get set of subgroups
    subgroupList=[ list(y) for y in set((x[0],x[2]) for x in fileList) ]
    print('$$$ subgroupList $$$')
    print(subgroupList)
    
    
    ################################
    #####Perform group analysis#####
    ################################
    
    #Create paramList
    paramList=[[x,fileList,targetWordCount,cocoWindow,svdInt,cvWindow,simCount,startCount,netAngle] for x in subgroupList]
    
    #Run calculation 
    masterOutput=[textAnalysis(x) for x in paramList]  
    #Create output file
    outputDF=pd.DataFrame(masterOutput,columns=['groupId','files','timeRun','keywords','perPos','perNeg','perPosDoc','perNegDoc', 'PSJudge'] + judgementCols + pronounCols + ['avgSD','avgEVC'])
    #Write that file for reference
    #outputDF.to_csv(writeDirectory+'logs/signalOutput-' + paramPath + '-' + runID + '.csv', encoding = 'utf-8') 
    #print(outputDF)
    return outputDF




################################
#####Import and clean data######
################################

def addRank(signalDF):  ########## NEED TO ADD ANY NEW GROUPS TO THIS LIST BEFORE YOU TEST THEM
    #Add in group ranking
    #groupNameList=['WBC', 'PastorAnderson', 'NaumanKhan', 'DorothyDay', 'JohnPiper', 'Shepherd',
    #'Rabbinic', 'Unitarian', 'MehrBaba','NawDawg','SeaShepherds','IntegralYoga','Bahai']
    #groupRankList=[1,2,3,4,4,4,6,7,8,4,2,7,6]
    ##
    #groupRankDF=pd.DataFrame([[groupNameList[i],groupRankList[i]] for i in range(len(groupNameList))],columns=['groupName','rank'])
    groupRankDF=pd.read_csv('./refData/groupRanks.csv')


    signalDF['groupName']=signalDF['groupId'].map(lambda x: x.split('_')[0]) # splits the name off the groupID column value
    
    signalDF=signalDF.merge(groupRankDF, on='groupName')

    return(signalDF)


############
######################
#Set inital conditions and run
######################
############

if __name__ == '__main__':
    startTimeTotal=time.time()
    #rawPath = './data_dsicap/' ###############change this eventually
    rawPath = './' + sys.argv[1] + '/'
    writeDirectory='./modelOutput/'

    # set parameters 
    if sys.argv[2] == 'auto':
        cocoWindow=3
        cvWindow=3
        netAngle=30
        targetWordCount=10
        keywordMethod = 'tfidfNoPro' # options are 'adjAdv' 'tfidf' 'tfidfNoPro'
        judgementMethod = 'pronoun' # options are 'both' 'bothAll' 'pronoun' 'pronounFrac' 'tobe'
        binSize = 10 # the number of docs per bin, set to 1 for individual docs

    else:
        cocoWindow=int(sys.argv[2])
        cvWindow=int(sys.argv[3])
        netAngle=int(sys.argv[4])
        targetWordCount=int(sys.argv[5])
        keywordMethod=sys.argv[6]
        judgementMethod=sys.argv[7]
        binSize=int(sys.argv[8])

    #testSplit=.3
    startCount=0
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
    paramPath = 'coco_'+str(cocoWindow)+'_cv_'+str(cvWindow)+'_netAng_'+str(netAngle)+'_twc_'+str(targetWordCount)\
        +'_'+keywordMethod+'_'+judgementMethod+'_bin_'+str(binSize)
    # define the random ID for this run
    runID = id_generator()
    #
    if judgementMethod == 'both':
        judgementCols = ['toBeFrac','pronounFrac']
    elif judgementMethod == 'bothAll':
        judgementCols = ['toBeFrac', 'toBeCount','pronounFrac', 'pronounCount']
    elif judgementMethod == 'pronounFrac':
        judgementCols = ['pronounFrac']
    else:   
        judgementCols = ['judgementCount','judgementFrac']

    pronounCols = ['nous', 'vous', 'je', 'ils', 'il', 'elle', 'le']
    #newTestDF = runMaster(rawPath,writeDirectory, paramPath,runID,targetWordCount,startCount,cocoWindow,svdInt,cvWindow,netAngle,simCount)
    signalDF = runMaster(rawPath,writeDirectory,paramPath,runID,binSize,targetWordCount,startCount,cocoWindow,svdInt,cvWindow,netAngle,simCount)

    endTimeTotal=time.time()
    print('finished entire run in :'+str((endTimeTotal-startTimeTotal)/60)+' minutes')
    sys.stdout.flush()

    ################################
    ### ########
    # THE MODEL (copied from individualModel.py)
    ###########
    ################################

    startTime=time.time()


#######################
### THE OLD WAY
#######################

#    #Get data frame for each cut
#    #signalDF=pd.read_csv('./github/nmvenuti/DSI_Religion/pythonOutput/coco_3_cv_3_netAng_30_sc_0/run0/masterOutput.csv')
#    #signalDF=pd.read_csv('/Users/Seth/Documents/DSI/Capstone/2016-group/cloneOf2016Code/pythonOutput/run1/cleanedOutput/coco_3_cv_3_netAng_30_sc_0/run0/masterOutput.csv')
#    signalDF=pd.read_csv('./pythonOutput/run1/cleanedOutput/' + paramPath + '/run0/masterOutput.csv', index_col=0)
#
#    ### MAKES THEM ALL TRAINING
#    signalDF['groupId'].replace('test','train1', regex=True, inplace=True) 
#
#    ######## NOW COMINE WITH NEW TESTING DF (signalDFL and newTestDF)
#    signalDF = signalDF.append(newTestDF)

#######################
#######################

    #add rankings # NOTE: if a group isn't included in the addRank() def above, the observation is DELETED
    signalDF=addRank(signalDF)

    #Set up modeling parameters
    allCols = signalDF.columns.tolist()
    nawCols = ['groupId', 'files', 'timeRun', 'keywords','rank', 'groupName', 
                    #'ils',
                    'Unnamed: 0']
    xList = [x for x in allCols if x not in nawCols]
    print('printing xList')
    print(xList)
    #xList=['perPos','perNeg','perPosDoc','perNegDoc','PSJudge'] + judgementCols + pronounCols + ['avgSD', 'avgEVC']
    yList=['rank']

    ################
    # CROSS-VALIDATION
    ################

    # shuffle the indexes
    shuf = random.sample(signalDF.index,signalDF.shape[0])
    # compute the breaks
    breaks = int(len(shuf)/5)

    # set the number of folds and then break up the shuffled indexes into that many folds
    folds = 5
    cv = []
    for i in range(0,folds):
        if i == folds-1:
            cv.append(shuf[i*breaks:]) # for the last fold, go all the way to the end
        else:
            cv.append(shuf[i*breaks:(i+1)*breaks]) # otherwise, use breaks

    #### RUN THE CROSS-VALIDATION
    for cv1 in cv:
        print('%%%%%%%%%%')
        print(cv1)
        signalTestDF = signalDF.iloc[cv1]
        cv1trainInd = [x for x in shuf if x not in cv1]
        signalTrainDF = signalDF.iloc[cv1trainInd]

        # set the response
        yActual=signalTestDF['rank'].tolist()

        ################
        # SET MODELING PARAMETERS
        ################
        #RF
        trees = 300
        depth = None
        features = 0.8
        #SVM
        svmC = 3                     

        ###########
        #Random Forest REGRESSOR
        ###########
        rfModel=RandomForestRegressor(n_estimators=trees,
                                        max_depth=depth, 
                                        max_features=features,
                                        min_samples_split=1,
                                        #random_state=0,
                                        n_jobs=-1)

        rfModel.fit(signalTrainDF[xList],signalTrainDF[yList])


        #Predict New Data
        yPred=rfModel.predict(signalTestDF[xList])

        # save predictions in TestDF
        signalTestDF.loc[:,'rfPred'] = yPred.tolist()

        #Get accuracy
        rfAccuracy=float(len([i for i in range(len(yPred)) if abs(yActual[i]-yPred[i])<1])/float(len(yPred)))
        print("rfAccuracy: " + str(rfAccuracy))
        #rfMAE=np.mean(np.abs(yActual-yPred))  

        ###########
        #Random Forest CLASSIFIER
        ###########
        rfClassModel=RandomForestClassifier(n_estimators=trees,
                                        max_depth=depth, 
                                        max_features=features,
                                        min_samples_split=1,
                                        #random_state=0,
                                        n_jobs=-1)

        rfClassModel.fit(signalTrainDF[xList],signalTrainDF[yList])


        #Predict New Data
        yPred=rfClassModel.predict(signalTestDF[xList])

        # save predictions in TestDF
        signalTestDF.loc[:,'rfClassPred'] = yPred.tolist()

        #Get accuracy
        rfClassAccuracy=float(len([i for i in range(len(yPred)) if abs(yActual[i]-int(yPred[i]))<=1])/float(len(yPred)))
        print("rfClassAccuracy: " + str(rfClassAccuracy))
        #rfClassMAE=np.mean(np.abs(yActual-yPred))  
        #getting exact classification accuracy
        #rfClassExact=float(len([i for i in range(len(yPred)) if (yActual[i]-int(yPred[i]))==0])/float(len(yPred)))
        

        #Perform same analysis with scaled data
        #Scale the data
        sc = StandardScaler()
        sc=sc.fit(signalTrainDF[xList])
        signalStdTrainDF= pd.DataFrame(sc.transform(signalTrainDF[xList]),columns=xList)
        signalStdTestDF = pd.DataFrame(sc.transform(signalTestDF[xList]),columns=xList)

        ###########
        # SVM REGRESSION
        ###########
        signalSVR=svm.SVR(C=svmC,epsilon=0.1,kernel='rbf',max_iter=100000)
        signalSVR.fit(signalStdTrainDF[xList],signalTrainDF[yList])

        #Predict New Data
        yPred=signalSVR.predict(signalStdTestDF[xList])

        #Get accuracy
        svmAccuracy=float(len([i for i in range(len(yPred)) if abs(yActual[i]-yPred[i])<1])/float(len(yPred)))
        print("svmAccuracy: " + str(svmAccuracy))
        #svmMAE=np.mean(np.abs(yActual-yPred))

        # save predictions
        signalTestDF.loc[:,'svmPred'] = yPred.tolist()
     
        ###########
        # SVM CLASSIFICATION
        ###########
        signalSVC=svm.SVC(C=svmC,kernel='rbf',max_iter=100000)
        signalSVC.fit(signalStdTrainDF[xList],signalTrainDF[yList])

        #Predict New Data
        yPred=signalSVC.predict(signalStdTestDF[xList])

        #Get accuracy
        svmClassAccuracy=float(len([i for i in range(len(yPred)) if abs(yActual[i]-yPred[i])<=1])/float(len(yPred)))
        print("svmClassAccuracy: " + str(svmClassAccuracy))
        #svmClassMAE=np.mean(np.abs(yActual-yPred))
        #getting exact classification accuracy
        #svmClassExact=float(len([i for i in range(len(yPred)) if (yActual[i]-yPred[i])==0])/float(len(yPred)))
        

        # save predictions
        signalTestDF.loc[:,'svmClassPred'] = yPred.tolist()
     
        #### SAVE ALL THE PREDICTIONS
        if (cv1[0] == cv[0][0]):
            masterSignalDF = signalTestDF.copy()
        else:
            masterSignalDF = masterSignalDF.append(signalTestDF)

        print('finished CV run, masterSignalDF:')
        print(masterSignalDF.shape)
        print('%%%%%%%%%%')


    ###################
    #Write the master file for reference
    masterSignalDF.to_csv(writeDirectory+'logs/signalOutput-' + paramPath + '-' + runID + '.csv', encoding = 'utf-8') 
    

    #Set up test train splits
    trainIndex=[x for x in masterSignalDF['groupId'] if 'train' in x]
    testIndex=[x for x in masterSignalDF['groupId'] if 'test' in x]


    masterSignalTrainDF=masterSignalDF[masterSignalDF['groupId'].isin(trainIndex)]
    print('%%%%%%\nmasterSignalTrainDF\n%%%%%%')
    print(masterSignalTrainDF.shape)

    masterSignalTestDF=masterSignalDF[masterSignalDF['groupId'].isin(testIndex)]
    print('%%%%%%\nmasterSignalTestDF\n%%%%%%')
    print(masterSignalTestDF.shape)

    xEnsembleList = ['rfPred', 'rfClassPred','svmPred', 'svmClassPred']

    #####################################
    # SVM ###ENSEMBLE### CLASSIFICATION #
    #####################################
    ensembleSVC=svm.SVC(C=svmC,kernel='rbf',max_iter=100000)
    ensembleSVC.fit(masterSignalTrainDF[xEnsembleList],masterSignalTrainDF[yList])

    #Predict New Data
    yPred=ensembleSVC.predict(masterSignalTestDF[xEnsembleList])

    # set the response
    yActual=masterSignalTestDF['rank'].tolist()

    #Get accuracy
    ensemble2Accuracy=float(len([i for i in range(len(yPred)) if abs(yActual[i]-yPred[i])<=1])/float(len(yPred)))
    ensemble2MAE=np.mean(np.abs(yActual-yPred))
    #getting exact classification accuracy
    ensemble2Exact=float(len([i for i in range(len(yPred)) if (yActual[i]-yPred[i])==0])/float(len(yPred)))
    print('$$$$$$$$\nensemble2Accuracy')
    print(ensemble2Accuracy)

    # save predictions
    masterSignalTestDF.loc[:,'ensemble2pred'] = yPred.tolist()
 

    ##################
    #Save model stats
    ##################

    binCount = masterSignalTrainDF.shape[0] + masterSignalTestDF.shape[0]
    paramStats = [runID, binCount, binSize, cocoWindow, cvWindow, netAngle, targetWordCount, keywordMethod, judgementMethod]
    #accuracyStats = [rfAccuracy, rfMAE, rfClassAccuracy, rfClassMAE, rfClassExact, svmAccuracy, svmMAE, svmClassAccuracy, svmClassMAE, svmClassExact]
    #accStatsNames = ["rfAccuracy", "rfMAE", "rfClassAccuracy", "rfClassMAE", "rfClassExact", "svmAccuracy", "svmMAE", "svmClassAccuracy", "svmClassMAE", "svmClassExact"]
    accuracyStats = [ensemble2Accuracy, ensemble2MAE, ensemble2Exact]
    accStatsNames = ["ensemble2Accuracy", "ensemble2MAE", "ensemble2Exact"]
    
    varsStats = rfModel.feature_importances_
    #
    statsNames = ["runID", "binCount", "binSize", "cocoWindow", "cvWindow", "netAngle", "targetWordCount", "keywordMethod", "judgementMethod"] + accStatsNames + xList
    print(statsNames)
    newStats = paramStats + accuracyStats + varsStats.tolist()
    print(newStats)
    #
    try:
        modelStats = pd.read_csv(writeDirectory + 'modelStats.csv')
        modelStats = modelStats.append(pd.DataFrame([tuple(newStats)], columns = statsNames))
        print("added row to modelStats.csv")
    except:
        modelStats = pd.DataFrame([tuple(newStats)], columns = statsNames)
        print("created modelStats.csv file")
    #
    modelStats.to_csv(writeDirectory + 'modelStats.csv', index=False)
                
    # create output csv
    outputName = writeDirectory + 'logs/ensembleModelPredictions-' + paramPath + '-' + runID + '.csv'
    print('%%%%%%\nALL DONE!\n' + outputName + '\n' + str(masterSignalTestDF.shape) + '\n%%%%%%')
    masterSignalTestDF.to_csv(outputName, encoding = 'utf-8')

