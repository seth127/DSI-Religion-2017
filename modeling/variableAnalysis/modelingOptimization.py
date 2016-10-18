# -*- coding: utf-8 -*-
"""
Created on Tue May 31 16:32:44 2016

@author: nmvenuti

Modeling grid search
"""

#Import packages
import pandas as pd
import numpy as np
import glob

from sklearn.preprocessing import StandardScaler
from sklearn import svm
from sklearn.ensemble import RandomForestRegressor
import time
#from sknn import mlp

################################
#####Import and clean data######
################################
startTime=time.time()
#Define data filepath
dataPath='../DSI_Religion/modeling/ref_complete1/'


#Get Files and store in appropriate list
judgementList=glob.glob(dataPath+'signal_judgements*')
networkList=glob.glob(dataPath+'signal_network*')
semAcomList=glob.glob(dataPath+'signal_semACOM*')
semContextList=glob.glob(dataPath+'signal_semContext*')
sentimentList=glob.glob(dataPath+'signal_sentiment*')



#For each variable extract files and create total dataframe using only desired columns
judgementDF= pd.concat((pd.read_csv(fileName) for fileName in judgementList))[['group','avgPercJ','avgNumJ']].set_index('group')

networkDF= pd.concat((pd.read_csv(fileName) for fileName in networkList))[['group','subgraph_centrality','eigenvector_centrality']].set_index('group')

semAcomDF= pd.concat((pd.read_csv(fileName) for fileName in semAcomList))[['group','acom']].set_index('group')

semContextDF= pd.concat((pd.read_csv(fileName) for fileName in semContextList))[['groupName','t.cvCosineSim.']]
semContextDF=semContextDF.groupby('groupName').mean()
semContextDF.reset_index(inplace=True)
semContextDF.columns=['group','contextVec']
semContextDF=semContextDF.set_index('group')

sentimentDF= pd.concat((pd.read_csv(fileName) for fileName in sentimentList))[['group','X.PosWords','X.NegWords','X.PosDoc','X.NegDoc']].set_index('group')

#Merge dataframes into one based on groupname
signalDF=judgementDF.join([networkDF,semAcomDF,semContextDF,sentimentDF], how='left')
signalDF.reset_index(inplace=True)

#Add in group ranking
groupNameList=['WBC', 'PastorAnderson', 'NaumanKhan', 'DorothyDay', 'JohnPiper', 'Shepherd',
'Rabbinic', 'Unitarian', 'MehrBaba']
groupRankList=[1,2,3,4,4,4,6,7,8]
#groupRankList=[1,2,3.5,4,4,4,6,7,7.5]

groupRankDF=pd.DataFrame([[groupNameList[i],groupRankList[i]] for i in range(len(groupNameList))],columns=['groupName','rank'])

signalDF['groupName']=signalDF['group'].map(lambda x: x.split('_')[0])

signalDF=signalDF.merge(groupRankDF, on='groupName')


##################################################################
#####Hyperparameter optimzation for MLP RF and SVM Regression#####
##################################################################

#Set up variables
#xList=[x for x in signalDF.columns if x not in ['rank','group','groupName']]
xList=['X.PosWords','X.NegWords','acom','contextVec','avgPercJ','avgNumJ', 'eigenvector_centrality','subgraph_centrality']
yList=['rank']

#Set up test train splits
trainIndex=[x for x in signalDF['group'] if 'train' in x]
testIndex=[x for x in signalDF['group'] if 'test' in x]

signalTrainDF=signalDF[signalDF['group'].isin(trainIndex)]
signalTestDF=signalDF[signalDF['group'].isin(testIndex)]

yActual=signalTestDF['rank'].tolist()

#SVM
svmParamList=[]
cList=[0.01,0.05,0.1,0.5,1.0,1.5,2.0,2.5,3.0,3.5]
epsilonList=[0.01,0.05,0.1,0.5,1.0]
kernelList=['linear','poly','rbf','sigmoid']
degreeList=[0,1,2,3,4]
coefList=[0,1,2,3]
for C in cList:
    for epsilon in epsilonList: 
        for kernel in kernelList:
            for degree in degreeList:
                for coef in coefList:
                    signalSVR=svm.SVR(C=C,epsilon=epsilon,kernel=kernel,degree=degree,coef0=coef,max_iter=100000)
                    signalSVR.fit(signalTrainDF[xList],signalTrainDF[yList])

                    #Predict New Data
                    yPred=signalSVR.predict(signalTestDF[xList])
                    
                    #Get accuracy
                    svmAccuracy=float(len([i for i in range(len(yPred)) if abs(yActual[i]-yPred[i])<1])/float(len(yPred)))
                    
                    #Add to parameter list
                    svmParamList.append([C,epsilon,kernel,degree,coef,svmAccuracy])

svmParamDF=pd.DataFrame(svmParamList,columns=['C','epsilon','kernel','degree','coef','accuracy'])                    

svmParamDF.to_csv('../DSI_Religion/variableAnalysis/svmOptimization.csv')

#Random Forest Regressor
estimatorList=[10,25,50,100,150,200]
depthList=[5,10,15,20,25,30]
featureList=['auto','sqrt','log2']
bsList=[True,False]
splitList=[1,2,3]
rfParamList=[]
for estimator in estimatorList:
    for depth in depthList:
        for bs in bsList:
            for feature in featureList:
                for split in splitList:
                    rfModel=RandomForestRegressor(n_estimators=estimator,max_depth=depth,
                                                  min_samples_split=split, max_features=feature,
                                                  bootstrap=bs,random_state=0,n_jobs=-1)
        
                    rfModel.fit(signalTrainDF[xList],signalTrainDF[yList])
        
                    #Predict New Data
                    yPred=rfModel.predict(signalTestDF[xList])
                    
                    #Get accuracy
                    rfAccuracy=float(len([i for i in range(len(yPred)) if abs(yActual[i]-yPred[i])<1])/float(len(yPred)))
                            
                    
                    rfParamList.append([estimator,depth,bs,split,feature,rfAccuracy])

#Convert to dataframe
rfParamDF=pd.DataFrame(rfParamList,columns=['estimator','depth','bs','split','feature','accuracy'])
rfParamDF.to_csv('../DSI_Religion/variableAnalysis/rfOptimization.csv')


#Perform same analysis with scaled data
#Scale the data
sc = StandardScaler()
sc=sc.fit(signalTrainDF[xList])
signalStdTrainDF= pd.DataFrame(sc.transform(signalTrainDF[xList]),columns=xList)
signalStdTestDF = pd.DataFrame(sc.transform(signalTestDF[xList]),columns=xList)

#STD SVM
svmParamList=[]
for C in cList:
    for epsilon in epsilonList: 
        for kernel in kernelList:
            for degree in degreeList:
                for coef in coefList:
                    signalSVR=svm.SVR(C=C,epsilon=epsilon,kernel=kernel,degree=degree,coef0=coef,max_iter=100000)
                    signalSVR.fit(signalStdTrainDF[xList],signalTrainDF[yList])

                    #Predict New Data
                    yPred=signalSVR.predict(signalStdTestDF[xList])
                    
                    #Get accuracy
                    svmAccuracy=float(len([i for i in range(len(yPred)) if abs(yActual[i]-yPred[i])<1])/float(len(yPred)))
                    
                    #Add to parameter list
                    svmParamList.append([C,epsilon,kernel,degree,coef,svmAccuracy])

svmStdParamDF=pd.DataFrame(svmParamList,columns=['C','epsilon','kernel','degree','coef','accuracy'])                    

svmStdParamDF.to_csv('../DSI_Religion/variableAnalysis/svmStdOptimization.csv')

#STDRandom Forest Regressor
rfParamList=[]
for estimator in estimatorList:
    for depth in depthList:
        for bs in bsList:
            for feature in featureList:
                for split in splitList:
                    rfModel=RandomForestRegressor(n_estimators=estimator,max_depth=depth,
                                                  min_samples_split=split, max_features=feature,
                                                  bootstrap=bs,random_state=0,n_jobs=-1)
        
                    rfModel.fit(signalStdTrainDF[xList],signalTrainDF[yList])
        
                    #Predict New Data
                    yPred=rfModel.predict(signalStdTestDF[xList])
                    
                    #Get accuracy
                    rfAccuracy=float(len([i for i in range(len(yPred)) if abs(yActual[i]-yPred[i])<1])/float(len(yPred)))
                            
                    
                    rfParamList.append([estimator,depth,bs,split,feature,rfAccuracy])

#Convert to dataframe
rfStdParamDF=pd.DataFrame(rfParamList,columns=['estimator','depth','bs','split','feature','accuracy'])
rfStdParamDF.to_csv('../DSI_Religion/variableAnalysis/rfStdOptimization.csv')    



##MLP
#nnParamList=[]
#momentumList=[ n/10 for n in list(range(1,10,2))] 
#learningRateList=[ n/1000 for n in list(range(5,51,5))]
#unitList=[10,25,50,100,150,200]
#learningRuleList=['sgd','momentum','nesterov','adadelta','adagrad','rmsprop']
#layerList=['Sigmoid','Tanh','Rectifier','ExpLin']
#runs=len(momentumList)*len(learningRateList)*len(unitList)*len(learningRuleList)*len(layerList)
#counter=0
#for learningRule in learningRuleList:
#    for learningRate in learningRateList:
#        for momentum in momentumList:
#            for unit in unitList:
#                for layer in layerList:
#                    # set up hidden layers and basic nn classifier
#                    hidden_layer1 = mlp.Layer(layer, units=unit)
#                    hidden_layer2 = mlp.Layer('Linear')
#                    
#                    signalNN = mlp.Regressor([hidden_layer1, hidden_layer2],random_state=1,
#                                       learning_rule=learningRule, learning_rate=learningRate,
#                                       learning_momentum=momentum,n_iter=100)
#                                       
#                    signalNN.fit(signalTrainDF[xList].as_matrix(),signalTrainDF[yList].as_matrix())
#                    
#                    #Predict New Data
#                    yPred=signalNN.predict(signalTestDF[xList].as_matrix())
#
#                    #Get accuracy
#                    nnAccuracy=float(len([i for i in range(len(yPred)) if abs(yActual[i]-yPred[i])<1])/float(len(yPred)))
#                    nnParamList.append([learningRule,float(learningRate),float(momentum),unit,layer,nnAccuracy])
#                    counter=counter+1
#                    print(str(100*float(counter)/float(runs))+'% Complete' )
#
##Review effect on more units with adaDelta and Tanh
#momentumList=[ n/10 for n in list(range(1,10,2))] 
#learningRateList=[ n/1000 for n in list(range(5,51,5))]
#unitList=[200,225,250,300]
#learningRuleList=['adadelta']
#layerList=['Tanh']
#runs=len(momentumList)*len(learningRateList)*len(unitList)*len(learningRuleList)*len(layerList)
#counter=0
#for learningRule in learningRuleList:
#    for learningRate in learningRateList:
#        for momentum in momentumList:
#            for unit in unitList:
#                for layer in layerList:
#                    # set up hidden layers and basic nn classifier
#                    hidden_layer1 = mlp.Layer(layer, units=unit)
#                    hidden_layer2 = mlp.Layer('Linear')
#                    
#                    signalNN = mlp.Regressor([hidden_layer1, hidden_layer2],random_state=1,
#                                       learning_rule=learningRule, learning_rate=learningRate,
#                                       learning_momentum=momentum,n_iter=100)
#                                       
#                    signalNN.fit(signalTrainDF[xList].as_matrix(),signalTrainDF[yList].as_matrix())
#                    
#                    #Predict New Data
#                    yPred=signalNN.predict(signalTestDF[xList].as_matrix())
#
#                    #Get accuracy
#                    nnAccuracy=float(len([i for i in range(len(yPred)) if abs(yActual[i]-yPred[i])<1])/float(len(yPred)))
#                    nnParamList.append([learningRule,float(learningRate),float(momentum),unit,layer,nnAccuracy])
#                    counter=counter+1
#                    print(str(100*float(counter)/float(runs))+'% Complete' )
#
#nnParamDF=pd.DataFrame(nnParamList,columns=['learningRule','learningRate','momentum','unit','layer','accuracy'])                    
#
#nnParamDF.to_csv('../DSI_Religion/variableAnalysis/nnOptimization.csv')

endTime=time.time()
print('runtime (in seconds):' +str(int(endTime-startTime)))
#runtime (in seconds):829
