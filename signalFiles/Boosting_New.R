#Read In Files

setwd('/Users/meganstiles/Desktop/github/DSI-Religion-2017/signalFiles/')

#gradient Boosting
require(xgboost)
library(caret)
library(dplyr)
df_clean = read.csv('SingleDocSignals.csv')
#Reset Rank Levels, for xgboost in multiclass classification, the classes are (0, num_class) so we subtract one from rank
df_clean$rank<- df_clean$rank - 1

#Set Rank as Factor
df_clean$rank<- as.factor(df_clean$rank)

#Drop Unneeded Variables:
df_clean<- df_clean[,-c(1)]
#10 fold CV

#Create Folds
folds<- createFolds(df_clean$rank, k=10, list = TRUE, returnTrain = FALSE)

param <- list("objective" = "multi:softprob",    
              "num_class" = 9,
              'max_depth' = 4,
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
  train_X<-data.matrix(train[,c(1:18, 20)])
  train_Y<- data.matrix(train$rank)
  test_X<- data.matrix(test[,c(1:18, 20)])
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
  miss<- table(difference)
  zero<-miss[names(miss)==0]
  one<- miss[names(miss)==1]
  correct<- zero[[1]] + one[[1]]
  accuracy<-correct/length(test_Y)
  
  #Store accuracy for each run in vector
  raw_accuracy[i]= accuracy
}

Avg_Accuracy = mean(raw_accuracy)
Avg_Accuracy #highest was 74% with 321 docs
