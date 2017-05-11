# DSI-Religion-2017
## Computational Analysis of Religious and Ideological Linguistic Behavior
In today’s global environment, effective communication between groups of diverse ideological beliefs can mean the difference between peaceful negotiations and violent conflict. At the root of communication is language, and researchers at the University of Virginia Center for Religion, Politics, and Conflict (RPC) hypothesize that the analysis of the performative character of a group's discourse (how words are used) provides valuable guidance for how to negotiate with groups of differing ideological beliefs. The RPC team developed a manual method for measuring the performative character of discourse using a 1-9 linguistic rigidity scale, with a score of 1 indicating a rigid use of language and a score of 9 indicating a flexible use of language.

The University of Virginia’s Computational Linguistics (CL) team created a signal processing model that closely replicates the manual process of the RPC team. And the team's results strengthen the evidence for the hypothesis of the effectiveness of computationally implemented performative analysis as predictive of linguistic rigidity. Current analysis includes investigating how an ideological group's use of language changes over time and what that predicts about a group's behavior.

Below is the breakdown of this repository:
* newMasterOOscript.py and newMasterOOscript_singledocs.py:
  * these scripts perform an end-to-end test: splitting the docs into test/train, calculating signals on all, then testing the accuracy and saving it modelOutput.
* writeSignalsSCRIPT.py:
  * calculates signals on all docs and saves them to modelOutput.
* prototype_python:
  * contains all custom analysis files for calculating signals. These files are imported as libraries into the scripts that use them.
* refData:
  * contains all static lookups referenced in the scripts (IDF dictionary, POS/NEG word lists, etc.)
* data_dsicap:
  * contains all documents used by Venuti et al 
* data_dsicap_EVEN:
  * contains an even number of documents for each group
* data_dsicap_FULL:
  * contains all the documents in corpus used by CL team.
* data_dsicap_ALL_SINGLE:
  * contains all single document whether scored or not
* data_dsicap_SINGLE:
  * contains all scored single documents
* Directory Maintence:
  * Python Scripts for creating directories of all scored single documents. 
* modeling:
  * Scripts for running RF, Tree Boosting, SVM on Document Signals
* modelOutput and modelOutputSingleDocs:
  * contains signals, filesplits, and predictions for binned and single document runs respectively
* pythonOutput:
* Neural Net
  * all scripts relating to our Deep Learning analysis (not presented in 2017 SIEDS paper).
* Presentations:
  * Various presentations the CL team gave throughout the 2016-2017 school year
* plotting-etc:
  * visualizations and exploratory analysis from throughout the project.
* plotting-etc/TFIDF:
  * Document-by-document TFIDF Matrix for a sample of docs
* wiki-IDF:
  * contains the raw Wikipedia text that the IDF was calculated from, as well as the script to do it and several IDF matrices
  
Repository for work by 2016 DSI group (Venuti et al.) can be found [here](https://github.com/nmvenuti/DSI_Religion).
Contact Seth Green at seth127 at gmail dot com with any questions.
