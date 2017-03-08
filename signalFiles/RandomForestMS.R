library(caret)
library(randomForest)
setwd('/Users/meganstiles/Desktop/github/DSI-Religion-2017/refData/')

list.files()

signals<- read.csv('SingleDocSignals.csv')

#Drop Unneeded Columns
signals<- signals[,-1]

#Set Rank as Factor Variable

signals$rank<- as.factor(signals$rank)

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
  miss<- table(difference)
  zero<-miss[names(miss)==0]
  one<- miss[names(miss)==1]
  correct<- zero[[1]] + one[[1]]
  accuracy<-correct/length(test)
  
  #Store accuracy for each run in vector
  raw_accuracy[i]= accuracy
}
raw_accuracy
mean(raw_accuracy)
  

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
  miss<- table(difference)
  one<- miss[names(miss)<=1]
  correct<- length(one)
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
  miss<- table(difference)
  zero<-miss[names(miss)==0]
  one<- miss[names(miss)==1]
  correct<- zero[[1]] + one[[1]]
  accuracy<-correct/length(test)
  
  #Store accuracy for each run in vector
  raw_accuracy[i]= accuracy
}
raw_accuracy
mean(raw_accuracy)
