

###SVM##########

library(kernlab)
setwd('/Users/meganstiles/Desktop/github/DSI-Religion-2017/signalFiles/')

list.files()

signals<- read.csv('SingleDocSignals.csv')

#Drop Unneeded Columns
signals<- signals[,-1]

#Set Rank as Factor Variable

signals$rank<- as.factor(signals$rank)

#Set Seed
set.seed(21)

# 10-Fold CV
folds<-createFolds(signals$rank, k=10, list = TRUE, returnTrain = FALSE)

raw_accuracy<- vector()

i=0
j=0
for (i in 1:10) {
  #Create testing indicies based on folds
  difference<- vector()
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
mean(raw_accuracy)
