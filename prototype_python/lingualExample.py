# -*- coding: utf-8 -*-
"""
Created on Mon Jul 18 16:12:17 2016

@author: nmvenuti
Example of lingual package
"""
import time
start=time.time()
import sys, os
import multiprocessing as mp

os.chdir('./github/nmvenuti/DSI_Religion/')
#from joblib import Parallel, delayed
#import multiprocessing as mp
import os.path
import pandas as pd
import numpy as np
sys.path.append('./prototype_python/')
import lingual as la

#Extract randomized files
fileDF=pd.read_csv('./data_dsicap/test_train/fileSplit_0.csv')
fileList=fileDF.values.tolist()
fileList=[[fileList[i][1],fileList[i][2],fileList[i][3]] for i in range(len(fileList))]


#Get set of subgroups
subgroupList=[ list(y) for y in set((x[0],x[2]) for x in fileList) ]

#Select files for first set of values in subgroupList
testFiles=list(fileDF[(fileDF['group']==subgroupList[0][0])&(fileDF['subgroup']==subgroupList[0][1])]['filepath'])

startTime=time.time()
#Test lingual object
loTest=la.lingualObject(testFiles)

#Test get coco
loTest.getCoco()

#Test DSM
loTest.getDSM()

#Test keywords with default and judgements method
loTest.setKeywords()
loTest.keywords

loTest.setKeywords('judgement')
loTest.keywords


#Test context vectors
loTest.getContextVectors()

#Test get average semantic density
loTest.getSD()
np.mean([x[1] for x in loTest.getSD(1000)])

#Test judgements
loTest.getJudgements()
list(np.mean(np.array([[x[1],x[2]] for x in loTest.getJudgements()]),axis=0))
#Test sentiment
loTest.sentimentLookup()

#Test network
loTest.setNetwork()

#Test evc
loTest.evc()

#Subgraph centrality development
#import igraph
#import random
#import scipy.spatial.distance as ssd
#import math
#import numpy as np
##Get list of values in DSM
#dsmList=[x.values() for x in loTest.DSM.values()]
#netAngle=30
##Calculate distances for each set of values in dsm
#cosineNP=ssd.cdist(dsmList,dsmList,metric='cosine')
#
#adj = cosineNP.copy()
#
##Apply thresholds
#adj[np.abs(cosineNP) >= math.cos(math.radians(netAngle))] = 0 # Converting 3threshold to radians to a cosine value
#
#adj[np.abs(cosineNP) < math.cos(math.radians(netAngle))] = 1 # Converting threshold to radians to a cosine value
#x=loTest.DSM.keys()
#adjList = pd.DataFrame(adj,columns=loTest.DSM.keys(),index=loTest.DSM.keys()).values.tolist()
#graph = loTest.network
#
#for keyword in loTest.keywords:
#	subgraph_vertex_list = [v.index for v in graph.vs if x[v] in lo]
#	subgraph = igraph.Graph.subgraph(graph, subgraph_vertex_list)
#
#	centrality = sum(subgraph.betweenness()) / sample_size
#	density = subgraph.density()
#
#	print 'Subsample %s has average centrality %f, density %f' % (keyword, centrality, density)
#
#print(str(time.time()-startTime))


#define function for multiple filecuts
def fullRun(fileList):
    #Test lingual object
    loTest=la.lingualObject(fileList)
    
    #Test get coco
    loTest.getCoco()
    
    #Test DSM
    loTest.getDSM()
    
    #Test keywords
    loTest.setKeywords()
    
    #Test context vectors
    loTest.getContextVectors()
    
    #Test get average semantic density
    loTest.getSD()
    
    #Test judgements
    loTest.judgements()
    
    #Test sentiment
    loTest.sentimentLookup()
    
    #Test network
    loTest.setNetwork()
    
    #Test evc
    loTest.evc()
    
    return('complete')

paramList=[list(fileDF[(fileDF['group']==subgroupList[i][0])&(fileDF['subgroup']==subgroupList[i][1])]['filepath']) for i in range(10)]
#Time ten runs
startTime=time.time()
testOuptut=[fullRun(x) for x in paramList]
print(str(time.time()-startTime))
#99.7856340408


#time ten paralleized runs
startTime=time.time()
xPool=mp.Pool(processes=3)    
outputList=[xPool.apply_async(fullRun, args=(x,)) for x in paramList]
masterOutput=[p.get() for p in outputList] 
print(str(time.time()-startTime))