#Read In Files

setwd('/Users/meganstiles/Desktop/github/DSI-Religion-2017/modelOutputSingleDocs/logs')

#List output codes for files we want
codes<- list( 'WWCH7S', 'DV6QAZ', 'OVDCHI', '90QZ3I', 'X055EX', '4XCVKI')
name <- "modelPredictions-coco_3_cv_3_netAng_30_twc_10_tfidfNoPro_pronoun_bin_1-"

#Read in initial file
df<- read.csv(paste0(name, 'EOXXVP' , '.csv' ))

#Read in Files and append to DF
for (i in 1:length(codes)) {
  code<- codes[i]
  filename<- paste0(name, code, '.csv')
  df.1<- read.csv(filename)
  df<- rbind(df, df.1)
}

#Drop Uneeded Columns

df_clean<- df[,c(6,7,10,12:22,24)]

#Drop duplicate entries

df_clean<- df_clean[!duplicated(df_clean[,1]),]

#gradient Boosting
require(xgboost)
library(caret)

#Reset Rank Levels, for xgboost in multiclass classification, the classes are (0, num_class) so we subtract one from rank
df_clean$rank<- df_clean$rank - 1

#Set Rank as Factor
df_clean$rank<- as.factor(df_clean$rank)

#10 fold CV

#Create Folds
folds<- createFolds(df_clean$rank, k=10, list = TRUE, returnTrain = FALSE)

param <- list("objective" = "multi:softprob",    
              "num_class" = 9,
              'max_depth' = 7,
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
  train_X<-as.matrix(train[,1:14])
  train_Y<- as.matrix(train$rank)
  test_X<- as.matrix(test[,1:14])
  test_Y = as.matrix(test$rank)
  
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
Avg_Accuracy 
