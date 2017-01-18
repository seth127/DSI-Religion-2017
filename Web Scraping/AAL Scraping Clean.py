
# Author: Megan Stiles

from urllib.request import urlopen
from urllib.error import URLError, HTTPError
from bs4 import BeautifulSoup
import re
import pandas as pd
import numpy as np
import time

#Url code that we are looking for is:
## http://www.theafricanamericanlectionary.org/ + PopupLectionaryReading + .asp?LRID=NUMBER

#The numbers range from 1 - 304

numbers = list(range(1,304))

#There is an error with article #12 so we remove it here
numbers.remove(12)
print(numbers)

url = 'http://www.theafricanamericanlectionary.org/PopupLectionaryReading.asp?LRID='
s = ''
link_list = []
for i in numbers:
    full_link = s.join([url,str(i)])
    link_list.append(full_link)

print(len(link_list))  
link_list
#Create Empty Data Frame to store documents and meta data
N= 303
AAL = pd.DataFrame(pd.np.empty((N,2)) *pd.np.nan)
AAL

#Name Columns of DF
AAL.columns=['Title','Text']
AAL

#Compile Text for all Web pages
for i in (range(len(link_list))):
    try:
        editorial= urlopen(link_list[i])
        soup = BeautifulSoup(editorial) 
        soup.prettify()
        titles = soup.find_all('p', attrs ={'align': 'center'})
        for title in titles:
            AAL['Title'][i] = title.string
        Texts= soup.find_all('div', attrs ={'id': 'main-content'})
        text_clean = Texts[0].prettify()
        #Clean up Document Text
        t1 = re.sub('<.*>', '', text_clean)
        text_clean_2 = re.sub('\xa0|[     \\n]+', ' ', t1)
        text_clean_3 = re.sub('(\\r|\\t)', '', text_clean_2)
        Text_clean_4 = re.sub('\((v....)+', '', text_clean_3)
        AAL['Text'][i] = Text_clean_4
        print(i)
        time.sleep(10+np.random.uniform(-5,5))
    except HTTPError as e:
        print('The server couldn\'t fulfill the request.')
        print('Error code: ', e.code)
        continue
   
#Write to CSV    
AAL.to_csv('AAL Docs.csv')



#Write text to txt files

os.chdir('/Users/meganstiles/Desktop/DSI_Religion/Megan_Capstone/AAL Files/')

for x in AAL.iterrows():
    #iterrows returns a tuple per record which you can unpack
    # X[0] is the index
    # X[1] is a tuple of the rows values so X[1][0] is the value of the first column etc.
    pd.DataFrame([x[1][1]]).to_csv('AAL' + str(x[0]) + '.txt', header=False, index=False)
