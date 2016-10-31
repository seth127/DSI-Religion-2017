WHAT NEEDS TO HAPPEN WITH newDocsModel.py

####
install iGraph on AWS 

###
make TF-IDF keyword selector 
--(we need to redo this in Python to standardize the stemming and stopword removal)
	# - do one that is tf(wiki)/M(wiki) (and we would divide tf(doc) by this(?)) 
		- ### abandoned this because the DTM we're working from doesn't have raw freq counts for terms because it's already a TFIDF
	- do one that is IDF(wiki) (i.e. log(M(wiki)/docswithterm(wiki)) )
		- this is basically traditional TF-IDF, except it'd be tf(doc) * IDF(wiki)
		- also, we'd need a max IDF(wiki) score (for if the term wasn't in wiki)
		- then you would multiply the term frequencies in a doc by the score in the lookup table
- load the IDF (into a DF?)
	- build the selector to take each word and do the TF-IDF tf(doc) * IDF(wiki)
	- then spit out the top words for each doc so we can check them out

####
double check the stemming
	- where they stemming the keywords before?
	- what signals depend on stemming? could we just NOT do it at all?

#####
CHECK OUT THIS IDEA FOR CLUSTERING WORD SIMILARITY
#####

go to: https://rstudio-pubs-static.s3.amazonaws.com/31867_8236987cf0a8444e962ccd2aec46d9c3.html
 then scroll down to the part that says "Hierarchical Clustering"



 