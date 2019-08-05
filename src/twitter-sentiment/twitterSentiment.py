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
from sklearn.metrics import mean_absolute_error
from sklearn.metrics import mean_squared_error
from sklearn.metrics import confusion_matrix
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
df = df.drop_duplicates(subset = "text", keep = "first")
df = df.drop_duplicates(subset="cleaned_text", keep = "first")

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
# Drop unnecessary columns
tweet_df = tweet_df.drop("sentiment", axis =1)
tweet_df = tweet_df.drop("sentiment_clean", axis =1)

#%%
# Filter out all "neutral" tweets (Vader Com > +- 0.5)
def sentimentThreshold(sentiment):
    if (sentiment > 0.5):
        return 1
    elif (sentiment < -0.5):
        return 0
    else:
        return 2
tweet_df["com_bool"] = tweet_df["com"].apply(sentimentThreshold)
tweet_df = tweet_df[tweet_df["com_bool"] <= 1]

#%%
# Calculate mean scores per hour
tweetpHour_df = tweet_df.resample("H", on="time").mean()

#%%
#processed = tweetpHour_df[["com"]]

#%%
def sentimentDelta(row):
    if (row.shift(1)["com"].isnull()):
        row["sent_delta"] = 0
    else:
        row["sent_delta"] = row["com"]= row.shift(1)["com"]

#processed["sent_delta"] = processed.apply(sentimentDelta)

#%%
# Calculate pearson correlation for different shifts
from scipy.stats import pearsonr
from datetime import timedelta
from scipy.stats import pearsonr
testdf = tweetpHour_df.copy(deep=True)
for i in range(1, 12):
    # Merge btc and title df's into one
    testdf.index = testdf.index + pd.DateOffset(hours=1)
    sentdf = pd.merge(btc_df, testdf, on="time", how="inner") 
    sentdf = sentdf.dropna()
    sentdf["price_delta"] = sentdf["close"] - sentdf["open"]
    sentdf["delta_bool"] = sentdf["price_delta"].apply(lambda x: 1 if x >= 0 else 0)
    correlation = pearsonr(sentdf["com"], sentdf["delta_bool"])
    print("Shift of " + str(i) + " hours." + str(correlation))

#%%
# Add 3 hours to sentiment scores (want to predict if sentiment affects price 3 hour from now)
tweetpHour_df.index = tweetpHour_df.index + pd.DateOffset(9)

#%%
# Merge dataframes
sentdf = pd.merge(tweetpHour_df, btc_df, on="time", how="inner")

#%%
sentdf.plot(x="time", y=["close",  "com"], secondary_y=["com"], mark_right=False, colormap='Paired')

#%%
# Calculate cumulative score of sentiment per hour 
sentpHour_df = tweet_df.resample("A", on="time").sum()
sentpHour_df.plot.bar(colormap='Paired')

#%%
# Add a price change variable to sentdf
sentdf = sentdf.dropna()
sentdf["price_delta"] = sentdf["close"] - sentdf["open"]
sentdf["delta_bool"] = sentdf["price_delta"].apply(lambda x: 1 if x >= 0 else 0)

#%%
p_change = sentdf["com"].pct_change(1)
p_change = p_change.apply(lambda x: 1 if x > 0 else 0)
sentdf["com_change"] = p_change
# Filter for only continuous data
sentdf = sentdf.iloc[10:]
sentdf = sentdf.iloc[100:]

#%%
# Remove unnecessary columns
train = sentdf[["com", "delta_bool"]]
#train = sentdf[["pos", "neg" ,"neu", "delta_bool"]]
# Split data
X_train, X_test, y_train, y_test = \
train_test_split(train.drop("delta_bool", axis=1), train["delta_bool"], test_size=0.3, random_state=322)

#%%
from sklearn.ensemble import RandomForestClassifier
# 86% - n(1000)/depth(5) || 71% - n(5000)/depth(9)
clf = RandomForestClassifier(n_estimators = 5000, max_depth = 9, random_state = 0)
clf.fit(X_train, y_train)
rf_pred = clf.predict(X_test)
print(classification_report(y_test, rf_pred))
print(confusion_matrix(y_test, rf_pred))
print("Accuracy:", accuracy_score(y_test,  rf_pred))


