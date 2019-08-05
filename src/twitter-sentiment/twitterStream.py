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
from threading import Thread 
# Thread sleeping
from time import sleep
# Time for logging
import datetime
# Botometer for bot detection
#import botometer
# Vader for Sentiment analysis
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer
# Tenacity
from tenacity import retry
from tenacity import wait_exponential
# Logging
import logging
# URLlib3 and requests
import urllib3
import requests
# Queue
from queue import Queue

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
twitterUsers = db.twitter_users

# Define access tokens & user credentials used for access
twitterAuth = {
    "consumer_key" : "LIrUnrnifiXrTaiuTmalM30Pd",
    "consumer_secret": "iH9hlwQvrdzKhkwd1RzSiAhEUjnRltgYihR1n5YPO6FkOY81k9",
    "access_token" : "1152134174108782592-qEFou1vhM61EI4tnUjzZRNsfeq8Enq",
    "access_secret" : "89d5n5V0mviJeJyXdKirjKTLDKVAa6hbeKbUuM3SXX9Yq"
}

# Botometer API key
#botAPIKey = "cd3f38366emshdd2cd0a2a5cca9ep14172djsn5f6c4df5a085"
#bom = botometer.Botometer(wait_on_rate_limit = True, mashape_key = botAPIKey, **twitterAuth)

# Vader analyser
analyzer = SentimentIntensityAnalyzer()

# Logging configuration
logging.basicConfig(level=logging.INFO, filename="logs/twitter_stream.log", filemode="a", format="%(levelname)s - %(asctime)s - %(message)s")


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
            newText = newText + " " + w
    return newText[1:]

# Function that queries the botometer api to return a score
# of how likely the account is to be a bot
def botCheck(username_id):
    result = bom.check_account("username_id")
    score = result["scores"]["english"]
    # False if likely to be human
    if(score > 0.3):
        return False
    else:
        return True

# Dictionary used to convert a month string JAN/FEB etc. to a number
monthNum ={
    "Jan" : "01",
    "Feb" : "02",
    "Mar" : "03",
    "Apr" : "04",
    "May" : "05",
    "Jun" : "06",
    "Jul" : "07",
    "Aug" : "08",
    "Sep" : "09",
    "Oct" : "10",
    "Nov" : "11",
    "Dec" : "12"
}

# Used to convert a twitter created_at value to a UTC timestamp
def toTimestamp(date):
    timestamp = date[-4:]+"-"
    timestamp += monthNum[date[4:7]]+"-"+date[8:10]+" "
    timestamp += date[11:19]
    return(timestamp)



# Function that cleans a tweet and stores it in a MongoDB database
def cleanAndStore(data):
    # Load data into JSON
    tweet = json.loads(data)
    id = tweet["id_str"]
    # Ignore retweets
    #if tweet["retweeted"] == False and not botCheck(tweet["user"]["id"]):
    if (tweet["retweeted"] == False) and (tweet["text"][0:2] != "RT") and ("retweeted_status" not in tweet): 
        # Check if the tweet uses extended text
        # If tweet is extended use that format else use normal format
        logging.info("RECIEVING: " + id)
        if "extended_text" in tweet:
            text = tweet["extended_tweet"]["full_text"]
            tweet["text"] = text
            tweet.pop("extended_tweet")
        else:
            text = tweet["text"]

        # Clean and Filter data from tweet
        text = textCleaner(text)
        text = spamFilter(text)

        # If meaningful -> Continue with processing
        if text != '':
            # Refactor important values
            tweet["tweet_id"] = tweet.pop("id")

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

            # Reformat created_at key-value to a workable timestamp
            tweet["time"] = toTimestamp(tweet["created_at"])

            # Store the sentiment score calculated by Vader
            tweet["sentiment"] = analyzer.polarity_scores(tweet["text"])
            tweet["sentiment_clean"] = analyzer.polarity_scores(tweet["cleaned_text"]) 

            # Save tweet & update user
            user = tweet["user"]
            user.pop("id_str")
            user.pop("translator_type")
            user["time"] = toTimestamp(user["created_at"])
            twitterUsers.update_one({"id": user["id"]},{"$set": user}, upsert  = True)
            result = twitterData.insert_one(tweet)
            logging.info(id + ' POSTED as {0}'.format(result.inserted_id))
            print(str(datetime.datetime.now()) + ": " + id + ' POSTED as {0}'.format(result.inserted_id)) 
            


# Classes
# override tweepy.StreamListener
class BitcoinListener(StreamListener):

    def __init__(self, q=Queue):
        # Create 4 threads that will handle tweet cleaning
        self.q = q
        for i in range(0, 4):
            t = Thread(target=self.cleanTweets)
            t.daemon = True
            t.start()
    # OVERRIDE on_status
    def on_status(self, statusCode):
        logging.info("Status: " + str(statusCode))

    # OVERRIDE on_error
    def on_error(self, statusCode):
        # If status is 420 error disconnect stream
        if statusCode == 420:
            logging.error(str(statusCode) +" Making too many requests; Rate Limited")
            return False
        if statusCode == 429:
            logging.error(str(statusCode) +" Request cannot be served due to rate limit.")
            return False
        if statusCode == 500:
            logging.error(str(statusCode) +" Internal Error")
            return False
        if statusCode == 502:
            logging.error(str(statusCode) +" Twitter is down")
            return False
        if statusCode == 503:
            logging.error(str(statusCode) +" Service is unavailable")
            return False

    # OVERRIDE on_data
    def on_data(self, data):
        # Attach the data to the process queue
        self.q.put(data)
    
    # OVERRIDE on_exception
    # If stream error, wait for 5 minutes
    def on_exception(self, exception):
        logging.critical("Stream error")
        print(str(datetime.datetime.now()) + ": STREAM ERROR - check log")
        logging.critical(str(exception))
        #raise exception
    
    def cleanTweets(self):
        while True:
            cleanAndStore(self.q.get())
            self.q.task_done()

# Wrapper function for the stream so that when timeouts occur
# tenacity will just retry the connection
@retry(wait=wait_exponential(multiplier=1, min=5, max=60))
def tenacityStream(stream):
    try:
        stream.filter(languages = ["en"], track = keywords, is_async = True, stall_warnings = True)
    except Exception as e:
        logging.info("Retrying stream...")

# Main Function
def main():
    logging.info("Stream started")
    # Set up a stream listener
    btcListener = BitcoinListener()

    # Set up stream
    authentication = OAuthHandler(twitterAuth["consumer_key"], twitterAuth["consumer_secret"])
    authentication.set_access_token(twitterAuth["access_token"], twitterAuth["access_secret"])
    stream = Stream(authentication, btcListener, tweet_mode = "extended")

    # Filter stream by keywords
    while True:
        try:
            logging.info("Started run")
            tenacityStream(stream)
        except (Timeout, SSLError, ReadTimeoutError, ConnectionError) as e:
            logging.warning("Network error occurred. Keep calm and carry on.", str(e))
        except urllib3.exceptions.ProtocolError as e:
            logging.warning("Protocol error. Les restart!")
        except ConnectionError as e:
            logging.warning("Some sort of connection error. Keep going")
        except requests.exceptions.ConnectionError as e:
            logging.warning("Request connection error. Ooooops...")
        except Exception as e:
            logging.error("Unexpected error!", e)
        logging.info("Stream has crashed. System will restart twitter stream in 5 min!")
        sleep(3000)
    logging.critical("Ai how did this break")

if __name__ == "__main__": main()