library(caret)
library(randomForest)
setwd('/Users/meganstiles/Desktop/github/DSI-Religion-2017/signalFiles/')

list.files()

signals<- read.csv('SingleDocSignals.csv')

#Drop Unneeded Columns
signals<- signals[,-1]

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
  
  #Calculate Mean Absolute Error 
  accuracy<-mean(difference)
  
  #Store accuracy for each run in vector
  raw_accuracy[i]= accuracy
}
raw_accuracy
mean(raw_accuracy) #MAE = 0.805

#Variable Importance

importance(model)

#                MeanDecreaseGini
#perPos                 14.041060
#perNeg                 13.273062
#perPosDoc               1.881506
#perNegDoc               1.993255
#PSJudge                12.755123
#judgementCount         13.344963
#judgementFrac          19.395052
#nous                   17.108875
#vous                   11.321047
#je                     11.359904
#ils                    15.006078
#il                     15.325472
#elle                    7.268749
#le                     12.425368
#UniqueWordCount        17.579925
#avgSD                  16.825747
#avgEVC                 11.013572
#groupName              42.639129

##### Regression Random Forest ########

signals<- read.csv('SingleDocSignals.csv')

#Drop Unneeded Columns
signals<- signals[,-1]

#Set Rank as Numeric Variable

signals$rank<- as.numeric(signals$rank)

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
mean(raw_accuracy) #61.5

####Classification Remove Variables

small<- read.csv('SingleDocSignals.csv')

#Drop Unneeded Columns
small<- small[,-c(1,2,5,6,17)]

#Set Rank as Factor

small$rank<- factor(small$rank)

folds<-createFolds(small$rank, k=10, list = TRUE, returnTrain = FALSE)


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
mean(raw_accuracy)
