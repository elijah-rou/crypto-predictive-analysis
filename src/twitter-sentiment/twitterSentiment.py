# Import necessary libraries
#%%
from pymongo import MongoClient
import datetime
import pandas as pd

# Connect to MongoDB client
#%%
client = MongoClient("192.168.2.69", 27017)
db = client["sentiment_data"]
twitterData = db.twitter

# Find all tweets stored on the 27th of July
#%%
docs = twitterData.find(
{
  'time':{'$gte': "2019-07-27T00:00:00+0000",
          '$lte': "2019-07-28T00:00:00+000"}
})

# Convert to pandas dataframe
#%%
df = pd.DataFrame(list(docs))

# Show first 10
#%%
df.head(10)

# Remove all tweets that have the same text
#%%
df_2 = df.drop_duplicates(subset = "text", keep = "first")

#%%
df_2.to_csv("data/twitter/tweets_2019_07_27.csv")

#%%
df_3 = df_2.copy(deep = True)


#%%
for index, row in df_3.head().iterrows():
    if (row["text"][0:2] == "RT"):
        df_3.drop(index)

#%%
docs_2 = twitterData.find(
{
  'time':{'$gte': "2019-07-28T00:00:00+0000"
          }
})

df_4 = pd.DataFrame(docs_2)

#%%
df_4.head(10)


#%%
docs_3 = twitterData.find(
{
  'time':{'$gte': "2019-07-26T00:00:00+0000",
          '$lte': "2019-07-27T00:00:00+0000"}
})

#%%
df_5 = pd.DataFrame(docs_3)

#%%
df_6 = df_5.drop_duplicates(subset = "text", keep = "first")

#%%
df_7 = df_6[df_6["retweeted_status"].isnull()]


#%%
df_7.head(10)


#%%
df_8 = df_7[["text", "time", "cleaned_text", "_id"]]


#%%
df_8.to_csv("data/twitter/tweets_2019_07_27.csv")


#%%
