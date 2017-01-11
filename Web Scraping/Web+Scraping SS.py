
# coding: utf-8

# In[31]:

from urllib.request import urlopen
from bs4 import BeautifulSoup
import re
import pandas as pd
import numpy as np
import time


# In[2]:

#Save website that has urls that I want
page = urlopen('http://www.theafricanamericanlectionary.org/readings2008.asp')


# In[3]:

soup = BeautifulSoup(page, 'lxml') 


# In[4]:

#Create empty list to store links
links = []


# In[5]:

#Find all links on page and store in a list
for link in soup.findAll('a', attrs={'href': re.compile("^http://")}):
    links.append(link.get('href'))
 
print(links)


# In[6]:

#The above list has some links that I don't want so now I will use RE to extract the ones I want into a new list
commentary = []


# In[7]:

for element in links:
    # Match if link contains "commentary-and-editorials" and append the link to commentary
    if (bool((re.findall("commentary-and-editorials", element))) == True):
        commentary.append(element)
    


# In[8]:

print(commentary)


# 

# In[9]:

#Find out number of links
print(len(commentary))
unique= np.unique(commentary)
print(len(unique))
unique[1]
# In[10]:

#Try Scraping One Webpage before trying iteration
editorial= urlopen(unique[1])


# In[11]:

soup = BeautifulSoup(editorial) 


# In[12]:

soup.prettify()
print(soup.prettify())


# In[42]:

#Print Article Title
soup.title.string


# In[14]:

#Print Date Published
dates = soup.find_all('span', attrs={'class':"date_added"})
for date in dates:
    print (date.string)


# In[15]:

dates = soup.find_all('div', attrs={'class':"content2"})[0]

t = dates.prettify()

t.split("<!--",1)[0]


# In[22]:

#Print Content of Article
text= soup.find_all('div', attrs ={'class': 'content2'})
    
print(text)


# In[18]:

caption = soup.find_all('span', attrs={'class':"wf_caption"})


# In[25]:

for i in caption:
    t.replace(str(i), '')
t


# In[ ]:




# In[27]:

# Remove extraneous HTML Tags
t1 = re.sub('<.*>', '', t)
t1


# In[ ]:




# In[28]:

# Replace whitespace, tabs, new lines with a space
text = re.sub('\xa0|[     \\n]+', ' ', t1)
text


# In[ ]:




# In[48]:

#Create Empty Data Frame to store documents and meta data
N= 743
SS = pd.DataFrame(pd.np.empty((N,4)) *pd.np.nan)


# In[58]:

SS.columns=['Title','Date','Author', 'Text']
SS


# In[32]:

print('test')
time.sleep(10+np.random.uniform(-5,5))
print('yes')


# In[59]:

for i in (range(len(unique))):
    editorial= urlopen(unique[i])
    soup = BeautifulSoup(editorial) 
    soup.prettify()
    SS['Title'][i] = soup.title.string
    texts = soup.find_all('div', attrs={'class':"content2"})
    for text in texts:   
        t = text.prettify()
        t.split("<!--",1)
        caption = soup.find_all('span', attrs={'class':"wf_caption"})
        for j in caption:
            t.replace(str(j), '')
        t1 = re.sub('<.*>', '', t)
        text = re.sub('\xa0|[     \\n]+', ' ', t1)
        SS['Text'][i] = text
    dates = soup.find_all('span', attrs={'class':"date_added"})
    for date in dates:
        SS['Date'][i] =  date.string
    time.sleep(10+np.random.uniform(-5,5))
    
SS


# In[60]:

SS


# In[ ]:



