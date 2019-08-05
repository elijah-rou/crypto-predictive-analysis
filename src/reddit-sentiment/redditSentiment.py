#%%
import pandas as pd

#%%
# Read in reddit data
df_btc = pd.read_csv("data/reddit/btcSubreddit.csv")
df_BitCoin = pd.read_csv("data/reddit/BitCoinSubreddit.csv")
df_CryptoCurrency = pd.read_csv("data/reddit/CryptoCurrency_12_months.csv")
df = pd.merge(df_btc, df_BitCoin, how="outer")
df = pd.merge(df, df_CryptoCurrency, how="outer")

#%%
df = df[["score", "author", "title", "created_utc", "subreddit"]]
del df_btc, df_BitCoin, df_CryptoCurrency

#%%
from datetime import datetime
df["time"] = df["created_utc"].apply(datetime.fromtimestamp)
df = df.drop("created_utc", axis=1)


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


################################################## PER HOUR
#%%
# Add one hour to sentiment scores (want to predict if sentiment affects price 3 hour from now)
from datetime import timedelta
df_time = df.copy(deep=True)
df_time["time"] = df_time["time"].apply(lambda x: x + timedelta(hours=2))

#%%
# Calculate mean scores per hour
dfpHour = df_time.resample("H", on="time").mean()
del df_time

#%%
# Get historical BTC price per hour
from cryptocompare import get_historical_price_hour
btc = get_historical_price_hour("BTC", "USD", )

#%%
# Create dataframe
from dateutil import parser
btc_df = pd.DataFrame.from_dict(btc["Data"])
def toTime(unixTime):
    utcTime = str(datetime.utcfromtimestamp(unixTime))
    return parser.parse(utcTime[0:11]+" "+utcTime[11:20])
btc_df["time"] = btc_df["time"].apply(toTime)
del btc


#%%
# Merge btc and title df's into one
sentdf = pd.merge(btc_df, dfpHour, on="time" ,how="inner")

#%%
# Plot compound sentiment vs closing price
sentdf.plot(x="time", y=["close",  "com"], secondary_y=["com"], mark_right=False, colormap='Paired')

#%%
# Add a price change variable to sentdf
sentdf = sentdf.dropna()
sentdf["price_delta"] = sentdf["close"] - sentdf["open"]
sentdf["delta_bool"] = sentdf["price_delta"].apply(lambda x: 1 if x >= 0 else 0)

#%%
from sklearn.model_selection import train_test_split
# Remove unnecessary columns
train = sentdf[["com", "delta_bool"]]
#train = sentdf[["pos", "neg" ,"neu", "delta_bool"]]
# Split data
X_train, X_test, y_train, y_test = \
train_test_split(train.drop("delta_bool", axis=1), train["delta_bool"], test_size=0.3, random_state=322)

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
# Calculate pearson correlation for different shifts
from scipy.stats import pearsonr
from datetime import timedelta
testdf = dfpHour.copy(deep=True)
for i in range(1, 180):
    # Merge btc and title df's into one
    testdf.index = testdf.index + pd.DateOffset(hours=1)
    sentDaydf = pd.merge(btc_df, testdf, on="time", how="inner") 
    sentDaydf = sentDaydf.dropna()
    sentDaydf["price_delta"] = sentDaydf["close"] - sentDaydf["open"]
    sentDaydf["delta_bool"] = sentDaydf["price_delta"].apply(lambda x: 1 if x >= 0 else 0)
    correlation = pearsonr(sentDaydf["com"], sentDaydf["delta_bool"])
    if correlation[0] >= 0.1:
        print("Shift of " + str(i) + " hours." + str(correlation))


###################################################### Per DAY
#%%
# Calculate mean scores per day
dfpDay= df.resample("D", on="time").mean()

#%%
# Get historical BTC price per day
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
del btc
#%%
# Merge btc and title df's into one
sentDaydf = pd.merge(btc_df, dfpDay, on="time" ,how="inner")

#%%
# Plot compound sentiment vs closing price
sentDaydf.plot(x="time", y=["close",  "com"], secondary_y=["com"], mark_right=False, colormap='Paired')

#%%
# Add a price change variable to sentdf
sentDaydf = sentdf.dropna()
sentDaydf["price_delta"] = sentDaydf["close"] - sentDaydf["open"]
sentDaydf["delta_bool"] = sentDaydf["price_delta"].apply(lambda x: 1 if x >= 0 else 0)

#%%
from sklearn.model_selection import train_test_split
# Remove unnecessary columns
train = sentDaydf[["com", "delta_bool"]]
#train = sentdf[["pos", "neg" ,"neu", "delta_bool"]]
# Split data
X_train, X_test, y_train, y_test = \
train_test_split(train.drop("delta_bool", axis=1), train["delta_bool"], test_size=0.3, random_state=322)

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
# Calculate pearson correlation for different shifts
from scipy.stats import pearsonr
from datetime import timedelta
testdf = dfpDay.copy(deep=True)
for i in range(1, 180):
    # Merge btc and title df's into one
    testdf.index = testdf.index + pd.DateOffset(1)
    sentDaydf = pd.merge(btc_df, testdf, on="time", how="inner") 
    sentDaydf["price_delta"] = sentDaydf["close"] - sentDaydf["open"]
    sentDaydf["delta_bool"] = sentDaydf["price_delta"].apply(lambda x: 1 if x >= 0 else 0)
    correlation = pearsonr(sentDaydf["com"], sentDaydf["delta_bool"])
    if correlation[0] >= 0.1:
        print("Shift of " + str(i) + " days." + str(correlation))


#%%
