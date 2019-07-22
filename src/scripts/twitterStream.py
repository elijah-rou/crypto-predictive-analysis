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
import pymongo


# Constants
keywords = ["bitcoin"]
stopWords = set(stopwords.words("english"))
engCorpus = set(words.words())

# Define acess tokens & user credentials used for access
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
            print(w)
            orderedWords.add(w)
            newText = newText + "," + w
    return newText[1:]


# Function to dump relevant parts of the tweet to a mongo database
# TODO
#def dumpTweet(tweet):
#    try:
#    
#    except:



# Classes
# override tweepy.StreamListener
class BitcoinListener(StreamListener):

    # OVERRIDE on_status
    def on_status(self, statusCode):
        print("Status: " + str(statusCode))

    # OVERRIDE on_error
    def on_error(self, statusCode):
        print("Error: " + str(statusCode))

        # If status is 420 error disconnect stream
        if statusCode == 420:
            return False

    # OVERRIDE on_data
    def on_data(self, data):
        tweet = json.loads(data)
        id = tweet["id_str"]
        print("Receiving tweet " + id)
        # Ignore retweets (for now)
        if tweet["retweeted"] == False:
            text = tweet["text"]
            print(text)
            # Clean and Filter data from tweet
            text = textCleaner(text)
            text = spamFilter(text)
            """
            # Remove unnecessary key-values
            tweet.pop("in_reply_to_status_id")
            tweet.pop("in_reply_to_user_id_str")
            tweet.pop("coordinates")
            tweet.pop("contributors")
            tweet.pop("in_reply_to_status_id_str")
            tweet.pop("source")
            tweet.pop("place")
            tweet.pop("geo")
            tweet.pop("truncated")
            tweet.pop("in_reply_to_screen_name")
            tweet.pop("is_quote_status")
            #tweet.pop("extended_entities")
            tweet.pop("lang")
            
            # From "entities" key
            #tweet["entities"].pop("media")
            tweet["entities"].pop("urls")
            tweet["entities"].pop("symbols")
            tweet["entities"].pop("user_mentions")


            # From "user" key
            tweet["user"].pop("default_profile")
            tweet["user"].pop("profile_background_tile")
            tweet["user"].pop("following")
            tweet["user"].pop("name")
            tweet["user"].pop("description")
            tweet["user"].pop("profile_sidebar_border_color")
            #tweet["user"].pop("entities")
            tweet["user"].pop("utc_offset")
            tweet["user"].pop("notifications")
            #tweet["user"].pop("profile_background_image_url")
            tweet["user"].pop("profile_image_url")
            tweet["user"].pop("profile_image_url_https")
            tweet["user"].pop("follow_request_sent")
            tweet["user"].pop("url")
            tweet["user"].pop("profile_background_image_url")
            tweet["user"].pop("profile_link_color")
            tweet["user"].pop("profile_text_color")
            tweet["user"].pop("profile_banner_url")
            tweet["user"].pop("profile_sidebar_fill_color")
            tweet["user"].pop("profile_background_color")
            tweet["user"].pop("time_zone")
            """

            if text != '':
                # Add cleaned tweet data
                tweet["cleaned_text"] = text

                ## TODO
                ## Store the tweet data in either a file or a database
                ## (only <id, timestamp, text>)
                file = open("data/twitter/" + tweet["id_str"] + ".json", "w+")
                file.write(json.dumps(tweet)) 
                print("Saved " + id + ".\n")




# Main Function
def main():
    # Set up a stream listener
    btcListener = BitcoinListener()

    # Set up stream
    authentication = OAuthHandler(consumerKey, consumerSecret)
    authentication.set_access_token(accessToken, accessSecret)
    stream = Stream(authentication, btcListener ,tweet_mode = "extended")

    # Filter steam by keywords
    stream.filter(languages = ["en"], track = keywords, is_async = True)

if __name__ == "__main__": main()