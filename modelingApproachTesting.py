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
# SOME DEFAULT SETTINGS:
#
# the old docs
# python modelingApproachTesting.py signalOutput-coco_3_cv_3_netAng_30_twc_20_tfidfNoPro_both_bin_10-2YZAOL.csv 10 10 auto
# or with the good settings
# python modelingApproachTesting.py signalOutput-coco_3_cv_3_netAng_30_twc_20_tfidfNoPro_both_bin_10-2YZAOL.csv 300 None .8
#
# the new docs
# python modelingApproachTesting.py signalOutput-coco_3_cv_3_netAng_30_twc_20_tfidf_pronounFrac_bin_10-QWTZPL.csv 10 10 auto
# 
# the best so far on the new docs (62% on rf, 96% on svmClass!!!)
# python modelingApproachTesting.py signalOutput-coco_3_cv_3_netAng_30_twc_20_tfidf_pronounFrac_bin_10-QWTZPL.csv 300 None .8
#
# now with 5 and 3 binSize
# python modelingApproachTesting.py signalOutput-coco_3_cv_3_netAng_30_twc_20_tfidfNoPro_both_bin_5-ILRYRH.csv 300 None .8
# python modelingApproachTesting.py signalOutput-coco_3_cv_3_netAng_30_twc_20_tfidfNoPro_both_bin_3-JK3E53.csv 300 None .8
#
#########

import time
start=time.time()
import sys, os
from sys import argv

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
#####Import and clean data######
################################

def addRank(signalDF):  ########## NEED TO ADD ANY NEW GROUPS TO THIS LIST BEFORE YOU TEST THEM
    #Add in group ranking
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
    
    runDirectory='./modelOutput/'
    '''
    #rawPath = './data_dsicap/' ###############change this eventually
    rawPath = './' + sys.argv[1] + '/'

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
    #newTestDF = runMaster(rawPath,runDirectory, paramPath,runID,targetWordCount,startCount,cocoWindow,svdInt,cvWindow,netAngle,simCount)
    signalDF = runMaster(rawPath,runDirectory,paramPath,runID,binSize,targetWordCount,startCount,cocoWindow,svdInt,cvWindow,netAngle,simCount)
    '''
    signalFile = sys.argv[1]
    paramPath = signalFile.split('-')[1]

    signalDF = pd.read_csv(runDirectory + 'logs/' + signalFile, index_col=0)


    ################################
    ### ########
    # THE MODEL (copied from individualModel.py)
    ###########
    ################################

    ### THE PARAMETERS TO THE RANDOM FOREST
    # number of trees
    trees=int(argv[2])
    # max depth
    if argv[3] == 'None':
        depth=None
    else:
        depth=int(argv[3])
    # max features
    if argv[4] == 'None':
        features=None
    elif (argv[4] == 'auto') | (argv[4] == 'sqrt') | (argv[4] == 'log2'):
        features=argv[4]
    else:
        if float(argv[4]) > 1:
            features=int(argv[4])
        else:
            features=float(argv[4])

    svmC = 3 #### could make this an argument if you wanted to test it

    startTime=time.time()

    #add rankings # NOTE: if a group isn't included in the addRank() def above, the observation is DELETED
    signalDF=addRank(signalDF)

    #Set up modeling parameters
    allCols = signalDF.columns.tolist()
    print(allCols)
    nawCols = ['groupId', 'files', 'timeRun', 'keywords','rank', 'groupName', 
                    #'ils',
                    'Unnamed: 0']
    xList = [x for x in allCols if x not in nawCols]
    #xList = ['avgSD','avgEVC', 'PSJudge'] # TESTING HOW IT WOULD WORK WITH JUST THESE 3 (not good)
    print(xList)

    yList=['rank']

    signalDF=signalDF.dropna()

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
    rfMAE=np.mean(np.abs(yActual-yPred))  

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
    rfClassMAE=np.mean(np.abs(yActual-yPred))  
    #getting exact classification accuracy
    rfClassExact=float(len([i for i in range(len(yPred)) if (yActual[i]-int(yPred[i]))==0])/float(len(yPred)))
    

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
    svmMAE=np.mean(np.abs(yActual-yPred))

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
    svmClassMAE=np.mean(np.abs(yActual-yPred))
    #getting exact classification accuracy
    svmClassExact=float(len([i for i in range(len(yPred)) if (yActual[i]-yPred[i])==0])/float(len(yPred)))
    

    # save predictions
    signalTestDF.loc[:,'svmClassPred'] = yPred.tolist()
 

    #Save model stats
    # print feature importance

    binCount = signalTrainDF.shape[0] + signalTestDF.shape[0]
    paramStats = [paramPath, binCount, trees, depth, features]
    accuracyStats = [rfAccuracy, rfMAE, rfClassAccuracy, rfClassMAE, rfClassExact, svmAccuracy, svmMAE, svmClassAccuracy, svmClassMAE, svmClassExact]
    varsStats = rfModel.feature_importances_
    #
    statsNames = ["runID", "binCount", "trees", "depth", "features", "rfAccuracy", "rfMAE", "rfClassAccuracy", "rfClassMAE", "rfClassExact", "svmAccuracy", "svmMAE", "svmClassAccuracy", "svmClassMAE", "svmClassExact"] + xList
    print(statsNames)
    newStats = paramStats + accuracyStats + varsStats.tolist()
    print(newStats)
    #
    try:
        modelStats = pd.read_csv(runDirectory + 'rfStats.csv')
        modelStats = modelStats.append(pd.DataFrame([tuple(newStats)], columns = statsNames))
        print("added row to rfStats.csv")
    except:
        modelStats = pd.DataFrame([tuple(newStats)], columns = statsNames)
        print("created rfStats.csv file")
    #
    modelStats.to_csv(runDirectory + 'rfStats.csv', index=False)
                

    endTimeTotal=time.time()
    print('finished entire run in :'+str((endTimeTotal-startTimeTotal)/60)+' minutes')
    print("$$$$$\nRANDOM FOREST REGRESSOR ACCURACY\n$$$$$")    
    print(rfAccuracy)  
    print("$$$$$\nRANDOM FOREST CLASSIFIER ACCURACY\n$$$$$")    
    print(rfClassAccuracy) 
    print("$$$$$\nRANDOM FOREST CLASSIFIER EXACT ACCURACY\n$$$$$")    
    print(rfClassExact) 
    print("$$$$$\nSVM ACCURACY\n$$$$$")    
    print(svmAccuracy) 
    print("$$$$$\nSVM CLASSIFIER ACCURACY\n$$$$$")    
    print(svmClassAccuracy) 
    print("$$$$$\nSVM CLASSIFIER EXACT ACCURACY\n$$$$$")    
    print(svmClassExact) 
    sys.stdout.flush()
                
    # create output csv
    #outputName = runDirectory + 'modelPredictions-' + paramPath + '-' + runID + '.csv'
    #print('%%%%%%\nALL DONE!\n' + outputName + '\n' + str(signalTestDF.shape) + '\n%%%%%%')
    outputName = runDirectory + 'RFTESTING-output.csv'
    print('%%%%%%\nALL DONE!\n' + outputName + '\n' + str(signalTestDF.shape) + 
                '\nNOTE: file is overwritten each time' + '\n%%%%%%')
    signalTestDF[['groupName','rank','rfPred','rfClassPred','svmPred', 'svmClassPred']].to_csv(outputName, encoding = 'utf-8')

