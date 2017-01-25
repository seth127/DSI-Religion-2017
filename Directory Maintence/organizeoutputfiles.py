import os

os.chdir('./Desktop/github/DSI-Religion-2017/')

files = os.listdir('./modelOutputSingleDocs/logs/')

predictions = []
for file in files:
    if 'modelPredictions' in file:
        predictions.append(file)

model_predictions = pd.DataFrame()

os.chdir('/Users/meganstiles/Desktop/github/DSI-Religion-2017/modelOutputSingleDocs/logs')

for file in predictions:
    data = pd.read_csv(file)
    model_predictions = model_predictions.append(data)

clean_model = model_predictions[['groupName', 'rank', 'rfPred', 'rfClassPred', 'svmPred', 'svmClassPred']]
clean_model.to_csv('All SingleDoc Runs.csv')