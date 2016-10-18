# -*- coding: utf-8 -*-
"""
Created on Tue May 31 13:17:50 2016

@author: nmvenuti

File is used to consolidate output reports from Rivanna 
and perform variable analysis on each output type
"""

#Import packages
import pandas as pd
import glob

import seaborn as sns
import matplotlib.pyplot as plt
import matplotlib.backends.backend_pdf

################################
#####Import and clean data######
################################

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

groupRankDF=pd.DataFrame([[groupNameList[i],groupRankList[i]] for i in range(len(groupNameList))],columns=['groupName','rank'])

signalDF['groupName']=signalDF['group'].map(lambda x: x.split('_')[0])

signalDF=signalDF.merge(groupRankDF, on='groupName')


##################################
#####Review Consolidated Data#####
##################################

signalDF.describe()


#Create box plots
ax = sns.boxplot(x='rank',y='avgPercJ',data=signalDF)
fig= ax.get_figure()
plt.suptitle('Average Percent of Judgements versus Rank') 

ax = sns.boxplot(x='rank',y='avgNumJ',data=signalDF)
fig= ax.get_figure()
plt.suptitle('Average Number of Judgements versus Rank') 

ax = sns.boxplot(x='rank',y='subgraph_centrality',data=signalDF)
fig= ax.get_figure()
plt.suptitle('Subgraph Centrality versus Rank') 

ax = sns.boxplot(x='rank',y='eigenvector_centrality',data=signalDF)
fig= ax.get_figure()
plt.suptitle('Eigenvector Centrality versus Rank') 

ax = sns.boxplot(x='rank',y='acom',data=signalDF)
fig= ax.get_figure()
plt.suptitle('Distributional Score versus Rank') 

ax = sns.boxplot(x='rank',y='contextVec',data=signalDF)
fig= ax.get_figure()
plt.suptitle('Context Vector Similarity versus Rank') 

ax = sns.boxplot(x='rank',y='X.PosWords',data=signalDF)
fig= ax.get_figure()
plt.suptitle('Fraction of Positive Words versus Rank') 

ax = sns.boxplot(x='rank',y='X.NegWords',data=signalDF)
fig= ax.get_figure()
plt.suptitle('Fraction of Negative Words versus Rank') 

ax = sns.boxplot(x='rank',y='X.PosDoc',data=signalDF)
fig= ax.get_figure()
plt.suptitle('Fraction of Positive Documents versus Rank') 

ax = sns.boxplot(x='rank',y='X.NegDoc',data=signalDF)
fig= ax.get_figure()
plt.suptitle('Fraction of Negative Documents versus Rank') 

#Create violin plots for each
#titleList=['Average Percent of Judgements','Average Number of Judgements', 'Subgraph Centrality',
#           'Eigenvector Centrality', 'Distributional Score', 'Context Vector Similarity', 'Fraction of Positive Words',
#           'Fraction of Negative Words', 'Fraction of Positive Documents','Fraction of Negative Documents']
#variableList=[col for col in signalDF.columns if col not in ['group','groupName','rank']]
#pdf = matplotlib.backends.backend_pdf.PdfPages('../DSI_Religion/variableAnalysis/graphics/violinPlots.pdf')
#for i in range(len(titleList)):
#    sns.set(style='ticks')
#    ax = sns.violinplot(x='rank',y=variableList[i],data=signalDF)
#    fig= ax.get_figure()
#    plt.suptitle(titleList[i]+' versus Rank')    
#    pdf.savefig(fig)
#pdf.close()
#
#pdf = matplotlib.backends.backend_pdf.PdfPages('../DSI_Religion/variableAnalysis/graphics/boxPlots.pdf')
#for i in range(len(titleList)):
#    sns.set(style='ticks')
#    ax = sns.boxplot(x='rank',y=variableList[i],data=signalDF)
#    fig= ax.get_figure()
#    plt.suptitle(titleList[i]+' versus Rank')    
#    pdf.savefig(fig)
#pdf.close()

