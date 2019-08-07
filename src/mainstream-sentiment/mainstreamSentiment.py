#%%
import pandas as pd

#%%
maindf = pd.read_json("data/mainstream/clean_articles.json")
maindf = maindf.drop("source", axis=1)
#%%
from datetime import datetime
#maindf["time"] = maindf["publishedAt"].apply(datetime.fromtimestamp)
#maindf = maindf.drop("publishedAt", axis=1)
maindf = maindf.set_index("publishedAt")

#%%
maindf = maindf.drop("description", axis=1)

#%%
df = maindf

#%%
# Clean reddit titles
from nltk.corpus import stopwords
from nltk.corpus import words
import re
stopWords = set(stopwords.words("english"))
engCorpus = set(words.words())
# Function to clean tweet text (Remove whitespace, convert to lowercase, remove non-alphabetic characters)
def textCleaner(tweetText):
    # Convert text to lowercase
    newText = tweetText.lower()

    # Strip whitespace from text
    newText = newText.strip()

    # Remove all non-alphabetic characters using regular expression
    regex = re.compile("[^a-zA-Z]")
    newText = regex.sub(" ", newText)
    
    return newText
# Function to filter text for spam, duplicates and nonsense
def spamFilter(tweetText):
    # Use NLTK to remove non-english words and stop-words
    words = tweetText.split()
    newText = ""
    orderedWords = set()

    # Check if the word is a duplicate, and a stop word or a proper word
    for w in words:
        if (w not in orderedWords) and (w not in stopWords) and (w in engCorpus) and (len(w) > 1):
            orderedWords.add(w)
            newText = newText + " " + w
    return newText[1:]

df["title_clean"] = df["title"].apply(textCleaner)
df["title_clean"] = df["title_clean"].apply(spamFilter)


#%%
# Filter post for duplicates and duplicates on cleaned text
df = df.drop_duplicates(subset="title", keep="first")
df = df.drop_duplicates(subset="title_clean", keep="first")


#%%
# Calculate vader scores for each title
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer
analyzer = SentimentIntensityAnalyzer()
df["sentiment"] = df["title"].apply(analyzer.polarity_scores)
df["sentiment_clean"] = df["title_clean"].apply(analyzer.polarity_scores)

#%%
# Extract individual sentiment scores from the column
df["pos"] = df["sentiment"].apply(lambda x: x["pos"])
df["neg"] = df["sentiment"].apply(lambda x: x["neg"])
df["neu"] = df["sentiment"].apply(lambda x: x["neu"])
df["com"] = df["sentiment"].apply(lambda x: x["compound"])
df = df.drop("sentiment", axis=1)

df["pos_clean"] = df["sentiment_clean"].apply(lambda x: x["pos"])
df["neg_clean"] = df["sentiment_clean"].apply(lambda x: x["neg"])
df["neu_clean"] = df["sentiment_clean"].apply(lambda x: x["neu"])
df["com_clean"] = df["sentiment_clean"].apply(lambda x: x["compound"])
df = df.drop("sentiment_clean", axis=1)

#%%
# Remove all posts which are neutral according to Vader recommended threshold
def sentimentThreshold(sentiment):
    if (sentiment > 0.5):
        return 1
    elif (sentiment < -0.5):
        return 0
    else:
        return 2
df["com_bool"] = df["com"].apply(sentimentThreshold)
df = df[df["com_bool"] <= 1]
df = df.drop("com_bool", axis=1)


#%%
df["time"] = df.index
def timeFixer(string):
    return string[0:-1] + ".000Z"
df["time"] = df["time"].apply(lambda x: timeFixer(str(x)))
df["time"] = pd.to_datetime(df["time"], utc=True)
#%%
df = df.set_index("time")


#%%
# Calculate mean scores per Day 
dfpDay= df.resample("D").mean()

#%%
# Get historical BTC price per hour
from cryptocompare import get_historical_price_day
btc = get_historical_price_day("BTC", "USD", )

#%%
# Create dataframe
from dateutil import parser
btc_df = pd.DataFrame.from_dict(btc["Data"])
def toTime(unixTime):
    utcTime = str(datetime.utcfromtimestamp(unixTime))
    return parser.parse(utcTime[0:11]+" "+utcTime[11:20])
btc_df["time"] = btc_df["time"].apply(toTime)
btc_df["time"] = pd.to_datetime(btc_df["time"], utc=True)
btc_df = btc_df.set_index("time")


#%%
# Merge btc and title df's into one
sentdf = pd.merge(btc_df, dfpDay, how="inner", left_index=True, right_index=True)

#%%
# Plot compound sentiment vs closing price
sentdf.plot(x="time", y=["close",  "com"], secondary_y=["close"], mark_right=False, colormap='Paired')

#%%
# Add a price change variable to sentdf
sentdf = sentdf.dropna()
sentdf["price_delta"] = sentdf["close"] - sentdf["open"]
sentdf["delta_bool"] = sentdf["price_delta"].apply(lambda x: 1 if x >= 0 else 0)

#%%
# Plot stuff for July

#%%
rollSent = sentdf["com"].rolling(window=7).mean()
sentdf["roll_com"] = rollSent

#%%
# Plot rolling verses price
sentdf.plot(figsize=(8, 5), y=["close",  "com"], secondary_y=["close"], mark_right=False, colormap='Paired')


#%%
# Make Close price series statoinary
import numpy as np
sentdf["close_log"] = np.log(sentdf["close"])
sentdf['close_log_diff'] = sentdf['close_log'] - sentdf['close_log'].shift(1)
rollClose = sentdf["close_log_diff"].rolling(window=7).mean()
sentdf["close_roll"] = rollClose
sentdf = sentdf.dropna()

#%%
# Plot rolling versus log difference
#plotRoll = sentJuly.plot(x="time", y=["close_log_diff",  "roll_com"], secondary_y=["roll_com"], mark_right=False, colormap='Paired', \
#    title="24 hour rolling average of sentiment and BTC closing price over July")
#plotRoll.set_xlabel("Date")
#plotRoll.set_ylabel("Average sentiment")
import matplotlib.pyplot as plt
fig, ax1 = plt.subplots()
sentdf['close_roll'].plot(ax=ax1, alpha=0.0)
sentdf['roll_com'].plot(secondary_y=True, ax=ax1, alpha=0.0)
ax = sentdf['close_roll'].plot(color="#FF372A"); 
ax.set_ylabel('Rolling normalised BTC price difference', fontsize=10, color="#FF372A")
sentdf['roll_com'].plot(ax=ax, secondary_y=True, title="Weekly rolling average of hourly Mainstream Media sentiment and BTC price difference." \
    ,color="#2AD8FF", figsize=(8, 5), alpha=0.8)
plt.xlabel('Day', fontsize=10) 
plt.ylabel('Rolling average of hourly Mainstream Media sentiment', fontsize=10, rotation=-90, color="#2AD8FF")
plt.savefig("output/Mainstream_Hourly_vs_BTC_price_diff_ROLLED.png", dpi=300)


#%%
from sklearn.model_selection import train_test_split
# Remove unnecessary columns
sentdf = sentdf[["com_clean", "delta_bool"]]
#sentdf = sentdf[["pos", "neg" ,"neu", "delta_bool"]]
# Split data
X_train, X_test, y_train, y_test = \
train_test_split(sentdf.drop("delta_bool", axis=1), sentdf["delta_bool"], test_size=0.3, random_state=322)

#%%
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report
from sklearn.metrics import confusion_matrix
from sklearn.metrics import accuracy_score
# 86% - n(1000)/depth(5) || 71% - n(5000)/depth(9)
clf = RandomForestClassifier(n_estimators = 5000, max_depth = 9, random_state = 0)
clf.fit(X_train, y_train)
rf_pred = clf.predict(X_test)
print(classification_report(y_test, rf_pred))
print(confusion_matrix(y_test, rf_pred))
print("Accuracy:", accuracy_score(y_test,  rf_pred))

#%%
