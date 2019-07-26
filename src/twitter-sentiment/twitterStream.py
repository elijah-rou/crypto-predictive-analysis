# Elijah Roussos
# Script to stream twitter data related to the keyword 'bitcoin'

# Import libraries
# Read/Write JSON
import json
# Python Twitter API Library - Tweepy
from tweepy.streaming import StreamListener
from tweepy import OAuthHandler
from tweepy import Stream
# Regular Expression
import re
# Natural Language Tool Kit
import nltk
from nltk.corpus import stopwords
from nltk.corpus import words
from nltk.tokenize import word_tokenize
# MongoDB Library
from pymongo import MongoClient
# Python thread class
import _thread
# Thread sleeping
from time import sleep
# Time for logging
import datetime


# Constants
keywords = ["bitcoin", "ethereum", "cryptocurrency", "btc", "crypto", "eth", "blockchain", "bitcoin+news", "crypto+news", "hodl", "bitcoin+fud",
"#bitcoin", "#bitcoinnews", "#cryptonews", "#crypto"]
# cryptonews, bitcoin, bitcoinmining, hodl, sell bitcion, buy bitcoin, bitcoin whale, bitcoin moooning
stopWords = set(stopwords.words("english"))
engCorpus = set(words.words())

# MongoDB @ 192.168.2.69:27017
client = MongoClient("192.168.2.69", 27017)
db = client["sentiment_data"]
twitterData = db.twitter

# Define access tokens & user credentials used for access
accessToken = "1152134174108782592-qEFou1vhM61EI4tnUjzZRNsfeq8Enq"
accessSecret = "89d5n5V0mviJeJyXdKirjKTLDKVAa6hbeKbUuM3SXX9Yq"
consumerKey = "LIrUnrnifiXrTaiuTmalM30Pd"
consumerSecret = "iH9hlwQvrdzKhkwd1RzSiAhEUjnRltgYihR1n5YPO6FkOY81k9"


# Functions

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
            newText = newText + "," + w
    return newText[1:]


# Function that cleans a tweet and stores it in a MongoDB database
def cleanAndStore(data):
    # Load data into JSON
    tweet = json.loads(data)
    id = tweet["id_str"]
    # Ignore retweets
    if tweet["retweeted"] == False:
        # Check if the tweet uses extended text
        # If tweet is extended use that format else use normal format
        print(str(datetime.datetime.now()) + ": " + "RECIEVING: " + id)
        if "extended_text" in tweet:
            text = tweet["extended_tweet"]["full_text"]
            tweet["text"] = text
            tweet.pop("extended_tweet")
        else:
            text = tweet["text"]
        #print(text)

        # Clean and Filter data from tweet
        text = textCleaner(text)
        text = spamFilter(text)

        # If meaningful -> Continue with processing
        if text != '':
            # Refactor important values
            tweet["tweet_id"] = tweet.pop("id")

            ## TODO
            ## STORE HASHTAGS

            # Remove unecessary attributes
            tweet.pop("id_str")
            tweet.pop("in_reply_to_status_id")
            tweet.pop("in_reply_to_user_id_str")
            tweet.pop("in_reply_to_user_id")
            if "display_text_range" in tweet:
                tweet.pop("display_text_range")
            tweet.pop("coordinates")
            tweet.pop("contributors")
            tweet.pop("in_reply_to_status_id_str")
            tweet.pop("source")
            tweet.pop("place")
            tweet.pop("geo")
            tweet.pop("truncated")
            tweet.pop("in_reply_to_screen_name")
            tweet.pop("is_quote_status")
            tweet.pop("lang")
            if "extended_entities" in tweet:
                tweet.pop("extended_entities")
            
            # From "entities" key
            if "entities" in tweet:
                tweet.pop("entities")
                # tweet["entities"].pop("media")
                # tweet["entities"].pop("urls")
                # tweet["entities"].pop("symbols")
                # tweet["entities"].pop("user_mentions")

            # From "user" key
            tweet["user"].pop("default_profile")
            tweet["user"].pop("profile_background_tile")
            tweet["user"].pop("following")
            tweet["user"].pop("name")
            tweet["user"].pop("description")
            tweet["user"].pop("profile_sidebar_border_color")
            tweet["user"].pop("utc_offset")
            tweet["user"].pop("notifications")
            tweet["user"].pop("profile_background_image_url")
            tweet["user"].pop("profile_image_url")
            tweet["user"].pop("profile_image_url_https")
            tweet["user"].pop("follow_request_sent")
            tweet["user"].pop("url")
            tweet["user"].pop("profile_link_color")
            tweet["user"].pop("profile_text_color")
            if "profile_banner_url" in tweet["user"]:
                tweet["user"].pop("profile_banner_url")
            tweet["user"].pop("profile_sidebar_fill_color")
            tweet["user"].pop("profile_background_color")
            tweet["user"].pop("time_zone")
            tweet["user"].pop("lang")
            tweet["user"].pop("contributors_enabled")
            tweet["user"].pop("is_translator")
            tweet["user"].pop("profile_background_image_url_https")
            tweet["user"].pop("profile_use_background_image")
            

            if "entities" in tweet["user"]:
                tweet["user"].pop("entities")
            
            # Add cleaned tweet data
            tweet["cleaned_text"] = text
            # Save tweet
            result = twitterData.insert_one(tweet)
            print(str(datetime.datetime.now()) + ": " + id + ' POSTED as {0}'.format(result.inserted_id))
        else:
            print("ERROR 2: Tweet id=" + id + " has no meaningful info. Ignoring...")
    else:
        print("ERROR 1: Tweet id=" + id + " is a retweet. Ignoring...")



# Classes
# override tweepy.StreamListener
class BitcoinListener(StreamListener):

    # OVERRIDE on_status
    def on_status(self, statusCode):
        print("Status: " + str(statusCode))

    # OVERRIDE on_error
    def on_error(self, statusCode):
        print("Error: " + str(statusCode))
        print(str(datetime.datetime.now()) +" - Error: " + str(statusCode) +"\n")
        
        # If status is 420 error disconnect stream
        if statusCode == 420:
            print("Making too many requests; Rate Limited")
            return False
        if statusCode == 429:
            print("Request cannot be served due to rate limit.")
            return False
        if statusCode == 500:
            print("Internal Error")
            return False
        if statusCode == 502:
            print("Twitter is down")
            return False
        if statusCode == 503:
            print("Service is unavailable")
            return False


    # OVERRIDE on_data
    def on_data(self, data):
        _thread.start_new_thread(cleanAndStore, (data,))
        # Start a new thread that processes the tweet
    
    # OVERRIDE on_exception
    # If stream error, wait for 5 minutes
    def on_exception(self, exception):
        print(exception)
        print(str(datetime.datetime.now()) +" - Exception: " + str(exception) +"\n")
        print("Stream encountered a problem. Sleeping for 5 minutes")
        sleep(3000)
        return 


# Main Function
def main():
    # Set up a stream listener
    btcListener = BitcoinListener()

    # Set up stream
    authentication = OAuthHandler(consumerKey, consumerSecret)
    authentication.set_access_token(accessToken, accessSecret)
    stream = Stream(authentication, btcListener, tweet_mode = "extended")

    # Filter stream by keywords
    stream.filter(languages = ["en"], track = keywords, is_async = True, stall_warnings = True)

if __name__ == "__main__": main()