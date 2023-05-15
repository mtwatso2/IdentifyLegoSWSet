# -*- coding: utf-8 -*-
"""
Created on Tue May  2 15:22:02 2023

@author: MWatson717
"""

import pandas as pd
import requests
from bs4 import BeautifulSoup

url = 'https://brickset.com/sets/theme-Star-Wars'
    
nums = []
names = []    

for i in range(1,37): #sets after page 37 do not have numbers/are limited edition, exclusive, so they are excluded
    url = f'https://brickset.com/sets/theme-Star-Wars/page-{i}'
    html = requests.get(url)
    soup = BeautifulSoup(html.text, 'html.parser')
    sets = soup.find_all('div', {'class':'meta'})
    for i in sets:
        text = i.find('h1').text
        nums.append(text.split(':')[0])
        names.append(text.split(':')[1].strip())
        print(text.split(':')[0])

nums.pop() #no set numbers for this one and beyond

df = pd.DataFrame({'SetNumber': nums, 'SetName': names})

df.to_csv('legoSW.csv', index=False)

lst = list(df['SetNumber']) #getting just the set numbers so they can be used in URL to scrape piece inventories 

pieces = pd.DataFrame()

for l in lst:
    url = f'https://brickset.com/inventories/{l}-1'
    print(url)
    d = pd.read_html(url)[0][['Element', 'Qty', 'Colour', 'Category', 'Design']]
    d['Set Number'] = l
    pieces = pd.concat([pieces, d])
    
pieces.to_csv('allLSWpieces.csv', index = False)
