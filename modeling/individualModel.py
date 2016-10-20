# -*- coding: utf-8 -*-
"""
Created on Tue May 31 16:32:44 2016

@author: nmvenuti

Modeling grid search
"""

#Import packages
import pandas as pd
import numpy as np

from sklearn.preprocessing import StandardScaler
from sklearn import svm
from sklearn.ensemble import RandomForestRegressor
import time

#from sknn import mlp


startTime=time.time()

################################
#####Import and clean data######
################################

def addRank(signalDF):
    #Add in group ranking
    groupNameList=['WBC', 'PastorAnderson', 'NaumanKhan', 'DorothyDay', 'JohnPiper', 'Shepherd',
    'Rabbinic', 'Unitarian', 'MehrBaba']
    groupRankList=[1,2,3,4,4,4,6,7,8]
    
    groupRankDF=pd.DataFrame([[groupNameList[i],groupRankList[i]] for i in range(len(groupNameList))],columns=['groupName','rank'])
    
    signalDF['groupName']=signalDF['groupId'].map(lambda x: x.split('_')[0])
    
    signalDF=signalDF.merge(groupRankDF, on='groupName')
    return(signalDF)



#Get data frame for each cut
#signalDF=pd.read_csv('./github/nmvenuti/DSI_Religion/pythonOutput/coco_3_cv_3_netAng_30_sc_0/run0/masterOutput.csv')
#signalDF=pd.read_csv('/Users/Seth/Documents/DSI/Capstone/2016-group/cloneOf2016Code/pythonOutput/run1/cleanedOutput/coco_3_cv_3_netAng_30_sc_0/run0/masterOutput.csv')
signalDF=pd.read_csv('signalsOutput/masterOutput.csv')

signalDF=addRank(signalDF)

#Set up modeling parameters
xList=['perPos','perNeg','perPosDoc','perNegDoc','judgementFrac','judgementCount','avgSD', 'avgEVC']
yList=['rank']
signalDF=signalDF[signalDF['files']>5]
signalDF=signalDF.dropna()

#Set up test train splits
trainIndex=[x for x in signalDF['groupId'] if 'train' in x]
testIndex=[x for x in signalDF['groupId'] if 'test' in x]

signalTrainDF=signalDF[signalDF['groupId'].isin(trainIndex)]
signalTestDF=signalDF[signalDF['groupId'].isin(testIndex)]

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
signalTestDF.to_csv('modelPredictions.csv')
