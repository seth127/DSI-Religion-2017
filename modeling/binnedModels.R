#Read In Files

setwd('/Users/meganstiles/Desktop/github/DSI-Religion-2017/signalFiles/')

#gradient Boosting
require(xgboost)
library(caret)
library(dplyr)


df_clean = read.csv('binnedSignals3.csv')


#Drop Unneeded Variables:
df_clean<- df_clean[,-c(1)]





#Remove New Documents- only run this if you are testing old docs methods
df_clean<-df_clean[!(df_clean$groupId=='SeaShepherds'| df_clean$groupId=='ISIS' | df_clean$groupId=='ACLU'
                     | df_clean$groupId=='Bahai' | df_clean$groupId=='Schizophrenia' | df_clean$groupId=='AndrewMurray'
                     | df_clean$groupId=='Ghandi' | df_clean$groupId=='IntegralYoga' | df_clean$groupId=='MalcolmX' 
                     |df_clean$groupId=='PeterGomes'),]


clean<-df_clean


#Reset Rank Levels, for xgboost in multiclass classification, the classes are (0, num_class) so we subtract one from rank
df_clean$rank<- df_clean$rank - 1

#Set Rank as Factor
df_clean$rank<- as.factor(df_clean$rank)


#10 fold CV

#Set Seed
set.seed(21)
#Create Folds
folds<- createFolds(df_clean$rank, k=10, list = TRUE, returnTrain = FALSE)

param <- list("objective" = "multi:softprob",    
              "num_class" = 9,
              'max_depth' = 5,
              'eval_metric' = 'merror')


#initialzie empty vector to store accuracy
raw_accuracy<- vector()
difference<- vector()
i=0
j=0
for (i in 1:10) {
  #Create testing indicies based on folds
  test.indices<- folds[[i]]
  
  #Create training and testing sets
  train = df_clean[-test.indices,]
  test = df_clean[test.indices,]
  
  #Convert to Matrix
  train_X<-data.matrix(train[,c(2:17)])
  train_Y<- data.matrix(train$rank)
  test_X<- data.matrix(test[,c(2:17)])
  test_Y = data.matrix(test$rank)
  
  #train Model
  model <- xgboost(param=param, data=train_X, label=train_Y, nrounds=5)
  
  #Make predictions based on model for testing set
  predictions<- predict(model, test_X)
  
  # reshape it to a num_class-columns matrix
  pred <- matrix(predictions, ncol=9, byrow=TRUE)
  
  # convert the probabilities to softmax labels (we have to subtract  one)
  pred_labels <- max.col(pred) - 1
  
  #Find the difference between the predicted value and the actual value
  for (j in 1: length(test_Y)) {
    diff<- abs(as.numeric(test_Y[j]) - pred_labels[j])
    difference[j]<- diff
  }
  
  #Calculate Accuracy, we define accuracy as correctly predicting the class within 1
  correct<-  sum(difference ==1 | difference ==0)
  accuracy<-correct/length(test_Y)
  
  #Store accuracy for each run in vector
  raw_accuracy[i]= accuracy
}

Avg_Accuracy = mean(raw_accuracy)
Avg_Accuracy #96.7% old docs, 92.6% with new docs


#################
#Random Forest###
#################
library(randomForest)

signals<-clean




#Set Rank as Factor Variable

signals$rank<- as.factor(signals$rank)

set.seed(21)
folds<-createFolds(signals$rank, k=10, list = TRUE, returnTrain = FALSE)

raw_accuracy<- vector()
difference<- vector()
i=0
j=0
for (i in 1:10) {
  #Create testing indicies based on folds
  test.indices<- folds[[i]]
  
  #Create training and testing sets
  train = signals[-test.indices,]
  test = signals[test.indices,]
  train$rank = factor(train$rank)
  test$rank = factor(test$rank)
  #train Model
  model <- randomForest(rank ~. -groupId, data = train)
  
  #Make predictions based on model for testing set
  predictions<- predict(model, newdata = test)
  
  #Calculate Accuracy
  for (j in 1: length(test)) {
    diff<- abs(as.numeric(test$rank[j]) - as.numeric(predictions[j]))
    difference[j]<- diff
  }
  
  #Calculate Accuracy, we define accuracy as correctly predicting the class within 1
  correct<-  sum(difference ==1 | difference ==0)
  accuracy<-correct/length(test)
  
  #Store accuracy for each run in vector
  raw_accuracy[i]= accuracy
}
raw_accuracy
mean(raw_accuracy) #95.37 old docs, 95.6% new docs

##########################
####SVM###################
##########################
library(kernlab)


# 10-Fold CV
folds<-createFolds(signals$rank, k=10, list = TRUE, returnTrain = FALSE)

raw_accuracy<- vector()
difference<- vector()
i=0
j=0
for (i in 1:10) {
  #Create testing indicies based on folds
  test.indices<- folds[[i]]
  
  #Create training and testing sets
  train = signals[-test.indices,]
  test = signals[test.indices,]
  train$rank = factor(train$rank)
  test$rank = factor(test$rank)
  #train Model
  model <- ksvm(rank ~. -groupId, data = train, type="C-svc", kernel="vanilladot", C=100)
  
  #Make predictions based on model for testing set
  predictions<- predict(model, newdata = test)
  
  #Calculate Accuracy
  for (j in 1: length(test)) {
    diff<- abs(as.numeric(test$rank[j]) - as.numeric(predictions[j]))
    difference[j]<- diff
  }
  
  #Calculate Accuracy, we define accuracy as correctly predicting the class within 1
  correct<-  sum(difference ==1 | difference ==0)
  accuracy<-correct/length(test)
  
  #Store accuracy for each run in vector
  raw_accuracy[i]= accuracy
}
raw_accuracy
mean(raw_accuracy) #98.15% old docs, 95.6% new docs