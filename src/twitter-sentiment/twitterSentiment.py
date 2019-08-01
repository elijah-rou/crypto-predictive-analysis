# Import necessary libraries
#%%
from pymongo import MongoClient
import datetime
import pandas as pd
import re
import cryptocompare
import pprint
from datetime import datetime, timedelta
import dateutil
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report
from sklearn.metrics import accuracy_score
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from Levenshtein._levenshtein import distance 

# Connect to MongoDB client
#%%
client = MongoClient("192.168.2.69", 27017)
db = client["sentiment_data"]
twitterData = db.twitter

# Find all tweets stored on the 27th of July
#%%
docs = twitterData.find(
{})

# Convert to pandas dataframe
#%%
df = pd.DataFrame(list(docs))

# Show first 10
#%%
df.head(1)

#%%
# Remove all tweets that have the same text
regex = re.compile("[^a-zA-Z]")
df["text"] = df["text"].apply(lambda x: re.sub("\s\s+", " ", (regex.sub(" ", x))))


#%%
df = df.drop_duplicates(subset = "text", keep = "first")

#%%

# Words to remove:
# #mpgvip #freebitcoin #livescore #makeyourownlane #footballcorn
# #freethereum entertaining subscribe [free, bitcoin] [free, etheruem]
# [current, price] [bitcoin, price] [earn, bitcoin] [start, trading, bitcoin]
# [join, bitcoin, mining] [free, dm, advise] [ethereum, price] [earn, etheruem]
# [start, trading, ethereum] [join, ethereum, mining]

def wordChecker(string):
    if ("mgpvip" in string) or ("freebitcoin" in string) or ("makeyourownlane" in string) \
    or ("footballcorn" in string) or ("freeethereum" in string) or ("entertaining" in string) \
    or ("subscribe" in string) or ("free" in string and "bitcoin" in string) \
    or ("free" in string and "ethereum" in string) or ("current" in string and "price" in string) \
    or ("bitcoin" in string and "price" in string) or ("earn" in string and "bitcoin" in string) \
    or ("ethereum" in string and "price" in string) or ("earn" in string and "ethereum" in string) \
    or ("start" in string and "trading" in string and "bitcoin" in string) \
    or ("start" in string and "trading" in string and "ethereum" in string) \
    or ("join" in string and "bitcoin" in string and "mining" in string) \
    or ("join" in string and "ethereum" in string and "mining" in string) \
    or ("free" in string and "dm" in string and "advise" in string):
        return True
    else:
        return False
    
#%%
df["flagged"] = wordChecker(df["text"])
df = df[~df["flagged"]]
df.drop(["flagged"], axis=1)

#%%
# Remove all tweets where Levenshtein distance < 7
#for index, row in df.head().iterrows():
#    for i, r in df.head().iterrows():
#        if (i != index) and (distance(row["clean_text"], r["clean_text"]) < 3):
#            df.drop(i)

#%%
# Select only necessary columns
tweet_df = df[["time", "sentiment", "sentiment_clean"]]


#%%
# Get historical BTC price
btc = cryptocompare.get_historical_price_hour("BTC", "USD", )

#%%
# Create dataframe
btc_df = pd.DataFrame.from_dict(btc["Data"])
def toTime(unixTime):
    utcTime = str(datetime.utcfromtimestamp(unixTime))
    return dateutil.parser.parse(utcTime[0:11]+" "+utcTime[11:20])
btc_df["time"] = btc_df["time"].apply(toTime)
del btc


#%%
# Process twitter df
# Change time to datetime
tweet_df["time"] = tweet_df["time"].apply(dateutil.parser.parse)
# Extract vader sscore
tweet_df["neu"] = tweet_df["sentiment"].apply(lambda x: x["neu"])
tweet_df["neu_clean"] = tweet_df["sentiment_clean"].apply(lambda x: x["neu"])
tweet_df["pos"] = tweet_df["sentiment"].apply(lambda x: x["pos"])
tweet_df["pos_clean"] = tweet_df["sentiment_clean"].apply(lambda x: x["pos"])
tweet_df["neg"] = tweet_df["sentiment"].apply(lambda x: x["neg"])
tweet_df["neg_clean"] = tweet_df["sentiment_clean"].apply(lambda x: x["neg"])
tweet_df["com"] = tweet_df["sentiment"].apply(lambda x: x["compound"])
tweet_df["com_clean"] = tweet_df["sentiment_clean"].apply(lambda x: x["compound"])

#%%
# Add one hour to sentiment scores (want to predict if sentiment affects price 1 hour from now)
tweet_df["time"] = tweet_df["time"].apply(lambda x: x + timedelta(hours=1))

#%%
# Calculate mean scores per hour
tweetpHour_df = tweet_df.resample("H", on="time").mean()

#%%
tweetpHour_df = tweetpHour_df.dropna()

#%%
sentdf = pd.merge(tweetpHour_df, btc_df, on="time", how="left")

#%%
# Visualise pos sentiment over time
sns.set_style("whitegrid")
sns.barplot(x="time", y="pos", data=sentdf[["time", "pos", "close"]])


#%%
sentdf.plot(x="time", y=["close", "neu", "pos", "neg"], secondary_y=["neu", "pos", "neg"], mark_right=False)


#%%
# Add a price change variable to sentdf
sentdf = sentdf.dropna()
def deltaPolarity(x, y):
    if (x - y) >= 0:
        return 1
    else:
        return 0

sentdf["price_delta"] = sentdf["close"] - sentdf["open"]


#%%
sentdf["delta_bool"] = sentdf["price_delta"].apply(lambda x: 1 if x >= 0 else 0)

#%%
# Remove unnecessary columns
train = sentdf[["neu", "pos", "neg", "delta_bool"]]
trainClean = sentdf[["neu_clean", "pos_clean", "neg_clean", "delta_bool"]]
#%%
# Create logistic regression model
# Split data
X_train, X_test, y_train, y_test = \
train_test_split(train.drop("delta_bool", axis=1), train["delta_bool"], test_size=0.3, random_state=322)

#%%
logModel = LogisticRegression()
logModel.fit(X_train, y_train)

predictions = logModel.predict(X_test)


#%%
print(classification_report(y_test,predictions))
print("Accuracy:", accuracy_score(y_test, predictions))


#%%
