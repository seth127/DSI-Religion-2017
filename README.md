# DSI-Religion-2017
## Computational Analysis of Religious and Ideological Linguistic Behavior
In today’s global environment, effective communication between groups of diverse ideological beliefs can mean the difference between peaceful negotiations and violent conflict. At the root of communication is language, and researchers at the University of Virginia Center for Religion, Politics, and Conflict (RPC) hypothesize that the analysis of the performative character of a group's discourse (how words are used) provides valuable guidance for how to negotiate with groups of differing ideological beliefs. The RPC team developed a manual method for measuring the performative character of discourse using a 1-9 linguistic rigidity scale, with a score of 1 indicating a rigid use of language and a score of 9 indicating a flexible use of language.

The University of Virginia’s Computational Linguistics (CL) team created a signal processing model that closely replicates the manual process of the RPC team. And the team's results strengthen the evidence for the hypothesis of the effectiveness of computationally implemented performative analysis as predictive of linguistic rigidity. Current analysis includes investigating how an ideological group's use of language changes over time and what that predicts about a group's behavior.

Below is the breakdown of this repository:
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
* modelOutputSingleDocs:
  * contains signals, filesplits, and predicitons for single document runs
* Presentations:
  * Various presentations the CL team gave throughout the 2016-2017 school year
 * TFIDF
   *Document-by-document TFIDF Matrix

