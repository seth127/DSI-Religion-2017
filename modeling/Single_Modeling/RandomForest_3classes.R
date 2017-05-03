library(caret)
library(randomForest)

setwd('/Users/meganstiles/Desktop/github/DSI-Religion-2017/modelOutputSingleDocs/307 Signals/')

df.signals<- read.csv('SingleDocSignals.csv')

#Set Rank to 4 classes

for (i in 1: nrow(df.signals)){
  if (df.signals$rank[i] == 1 | df.signals$rank[i] == 2) {
    df.signals$rank[i] = "low"
  }
  if (df.signals$rank[i] == 3 | df.signals$rank[i] == 4) {
    df.signals$rank[i] = 'mid'
  }
  if (df.signals$rank[i] == 5 | df.signals$rank[i] == 6) {
    df.signals$rank[i] = 'higher'
  }
  if (df.signals$rank[i] == 7 | df.signals$rank[i] == 8 | df.signals$rank[i] == 9) {
    df.signals$rank[i] = 'highest'
  }
}


#Make Response Variable Factor
df.signals$rank<- factor(df.signals$rank)
#Create Folds
folds<- createFolds(df.signals$rank, k=15, list = TRUE, returnTrain = FALSE)

raw_accuracy<- vector()
i=0
for (i in 1:10) {
  #Create testing indicies based on folds
  test.indices<- folds[[i]]
  
  #Create training and testing sets
  train = df.signals[-test.indices,]
  test = df.signals[test.indices,]
  train$rank<- factor(train$rank)
  test$rank <- factor(test$rank)
  #train Model
  model <- randomForest(rank ~. -groupId - X, data = train)
  
  #Make predictions based on model for testing set
  predictions<- predict(model, newdata = test)
  
  #Calculate Accuracy
  # Output raw accuracy.
  accuracy = sum(predictions == test[,"rank"]) / nrow(test) 
  
  #Store accuracy for each run in vector
  raw_accuracy[i]= accuracy
}
raw_accuracy
mean(raw_accuracy)
