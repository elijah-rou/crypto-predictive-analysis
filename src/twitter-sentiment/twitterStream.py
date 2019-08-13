# Elijah Roussos
# Script to stream twitter data related to the keyword 'bitcoin'

# Import libraries
# Read/Write JSON
import json
# Python Twitter API Library - Tweepy
from tweepy.streaming import StreamListener
from tweepy import OAuthHandler
from tweepy import Stream
# MongoDB Library
from pymongo import MongoClient
# Python thread class
from threading import Thread 
# Thread sleeping
from time import sleep
# Time for logging
import datetime
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
# Import custom text processor module for cleaning tweets
import sys
sys.path.append('src/data-processing')
import textProcessor as tp

# Constants
keywords = ["bitcoin", "ethereum", "cryptocurrency", "btc", "crypto", "eth", "blockchain", "bitcoin+news", "crypto+news", "hodl", "bitcoin+fud",
"#bitcoin", "#bitcoinnews", "#cryptonews", "#crypto"]
# cryptonews, bitcoin, bitcoinmining, hodl, sell bitcion, buy bitcoin, bitcoin whale, bitcoin moooning

# Load configuration file for the database and connect
with open("config/database_config.cfg", "r") as f:
    client_config = json.load(f)
client = MongoClient(client_config["ip"], client_config["port"])
db = client[client_config["database"]]
twitterData = db[client_config["twitter_documents"]]
twitterUsers = db[client_config["twitter_users"]]

# Load Twitter access tokens & user credentials from config file
with open("config/twitter_authentication.cfg", "r") as f:
    twitterAuth = json.load(f)

# Vader analyser
analyzer = SentimentIntensityAnalyzer()

# Logging configuration
logging.basicConfig(level=logging.INFO, filename="logs/twitter_stream.log", filemode="a", format="%(levelname)s - %(asctime)s - %(message)s")

# Functions
# Function to remove unnecessary key-store values from tweets
def cleanTweet(tweet):
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
    
    return tweet
    
    
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
        print("RECIEVING: " + id)
        if "extended_text" in tweet:
            text = tweet["extended_tweet"]["full_text"]
            tweet["text"] = text
            tweet.pop("extended_tweet")
        else:
            text = tweet["text"]

        # Clean and Filter data from tweet
        text = tp.textCleaner(text)
        text = tp.spamFilter(text)
        
        # If meaningful -> Continue with processing
        if text != '':
            tweet = cleanTweet(tweet)
            # Add cleaned tweet data
            tweet["cleaned_text"] = text
            # Reformat created_at key-value to a workable timestamp
            tweet["time"] = toTimestamp(tweet["created_at"])
            # Store the sentiment score calculated by Vader
            tweet["sentiment"] = analyzer.polarity_scores(tweet["text"])
            tweet["sentiment_clean"] = analyzer.polarity_scores(tweet["cleaned_text"]) 
            # Update the user database with the associate user 
            user = tweet["user"]
            user.pop("id_str")
            user.pop("translator_type")
            user["time"] = toTimestamp(user["created_at"])
            twitterUsers.update_one({"id": user["id"]},{"$set": user}, upsert  = True)

            # Save the cleaned tweet in the database
            result = twitterData.insert_one(tweet)
            print(id + ' POSTED as {0}'.format(result.inserted_id))
            print(str(datetime.datetime.now()) + ": " + id + ' POSTED as {0}'.format(result.inserted_id)) 
            


# Classes
# override tweepy.StreamListener
class BitcoinListener(StreamListener):
    def __init__(self, q=Queue()):
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
    
    # Function for threads to continually check the queue and clean tweets
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
    # Log stream start
    logging.info("Stream started")
    # Set up a stream listener
    btcListener = BitcoinListener()
    # Set up stream
    authentication = OAuthHandler(twitterAuth["consumer_key"], twitterAuth["consumer_secret"])
    authentication.set_access_token(twitterAuth["access_token"], twitterAuth["access_secret"])
    stream = Stream(authentication, btcListener, tweet_mode = "extended")

    # Filter stream by keywords, log errors
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