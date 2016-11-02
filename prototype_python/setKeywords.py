
####### THIS IS JUST A SANDBOX THAT GOES WITHIN THE lingualObject IN lingual.py
###############
from nltk.probability import FreqDist

        #
        self.idfFile = 'wiki-test-5-IDF.csv'
        self.idf = pd.read_csv('./wiki-IDF/' + idfFile)
        self.idf = idf.set_index('term')



    def setKeywords(self,method='adjAdv',wordCount=10,startCount=0):
        '''
        function to automatically assign keywords if manual ones have not been assigned
        
        Inputs
        ======
        method: string
            Method used to pick automatically defined keywords. Choose from:
            adjAdv- picks most common adj and adv in text (default and 
                catch if other method doesn't exist)
            judgement-Under development
        wordCount: int
            Number of keywords returned (default 10)
        startCount: int
            Index where keywords are extracted (default 0 i.e. start of list)
        
        Attributes
        ==========
        keywords: list
            List of keywords automatically generated (can also be assigned 
            outside of function manually)
        '''
        #Save input values
        self.keywordCount=wordCount
        self.keywordStar=startCount
        
  
        #Default to 'adjAdv'
        if method=='adjAdv':
            #Get total text string
            txtString=''.join([x for x in self.rawText.values()])
            
            #Get total tag list
            tagList=tagger.tag(nltk.word_tokenize(txtString))
            
            #Define target dict
            targetDict={}
            
            #Loop through each tag in list and get count of tag and word
            for tag in tagList:
                if tag[1] in tagFilterList:
                    word=str.lower(''.join([c for c in tag[0] if c not in string.punctuation]))
                    #Filter out codecerrors
                    if word != 'codecerror':
                        try:
                            targetDict[word]=targetDict[word]+1
                        except:
                            targetDict[word]=1
        
            #Create data frame with counts and sort
            targetDF=pd.DataFrame([[k,v] for k,v in targetDict.items()],columns=['word','count'])
            targetDF.sort(['count'],inplace=True,ascending=False)
            
            #Create keywords based on startCount and wordCount
            ##self.keywords=list(targetDF['word'])[startCount:wordCount+startCount]

                        ###
            keyRaw=list(targetDF['word'])[startCount:wordCount+startCount]
            #print(keyRaw)

            keyStem=[stemmer.stem(word) for word in keyRaw] 
            #print(keyStem)

            self.keywords = keyStem

        elif method=='tfidf':
        	# get all tokens for the fileList
        	all_words = []
			for toke in loTest.tokens.values():
			    all_words = all_words + toke

			## create FreqDF with word frequencies from fileList
			freq = FreqDist(all_words) 
			columns_obj = ["term", "freq"]
			freqDF = pd.DataFrame(freq.items(), columns=columns_obj) # convert it to a data frame
			freqDF = freqDF.set_index('term')
			
			## merge freqDF with idf data frame
			freqit = freqDF.join(idf[['idf', 'logidf']])
			# replace null values with max
			maxidf = max(freqit['idf'].dropna())
			maxlogidf = max(freqit['logidf'].dropna())
			freqit.loc[pd.isnull(freqit['idf']), 'idf'] = maxidf
			freqit.loc[pd.isnull(freqit['logidf']), 'logidf'] = maxlogidf

			## create tfidf columns
			freqit['tfidf'] = freqit['freq'] * freqit['idf']
			freqit['logtfidf'] = freqit['freq'] * freqit['logidf']

			## order by tfidf weight
			freqit = freqit.sort_values(by='tfidf', ascending=False) 

			##
			self.keywords = freqit.iloc[startCount:wordCount+startCount].index.tolist()




        #Judgement method
        elif method=='judgement':
            posList=nounList+tagFilterList
            #Define target dict
            targetDict={}
            for fileName in self.fileList:
                for judgementStr in self.judgements[fileName]:
                    tagList=tagger.tag(nltk.word_tokenize(judgementStr))
            
                    
                    #Loop through each tag in list and get count of tag and word
                    for tag in tagList:
                        if tag[1] in posList:
                            word=str.lower(''.join([c for c in tag[0] if c not in string.punctuation]))
                            #Stem words if useStem True
                            newStopWords=stopWords
                            if self.useStem:
                                word=stemmer.stem(word)
                                newStopWords=[stemmer.stem(x) for x in stopWords]
                             
                            #Remove stopwords if useStopwords ==False
                            if not self.useStopwords: 
                                newStopWords.append("")

                                
                            #Filter out codecerrors
                            if word not in ['codecerror']+[' ']+newStopWords:
                                try:
                                    targetDict[word]=targetDict[word]+1
                                except:
                                    targetDict[word]=1
            #Create data frame with counts and sort
            targetDF=pd.DataFrame([[k,v] for k,v in targetDict.items()],columns=['word','count'])
            targetDF.sort(['count'],inplace=True,ascending=False)
            
            #Create keywords based on startCount and wordCount
            #self.keywords=list(targetDF['word'])[startCount:wordCount+startCount]

                        ###
            keyRaw=list(targetDF['word'])[startCount:wordCount+startCount]
            #print(keyRaw)

            keyStem=[stemmer.stem(word) for word in keyRaw] 
            #print(keyStem)

            self.keywords = keyStem

        else:
            print('ERROR: Method not found')