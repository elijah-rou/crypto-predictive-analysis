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
def textCleaner(textText):

    # Convert text to lowercase
    newText = tweetText.lower()

    # Strip whitespace from text
    newText = newText.strip()

    # Remove all non-alphabetic characters using regular expression
    regex = re.compile("[^a-zA-Z]")
    newText = regex.sub("", newText)
    
    return newText


# Function to filter text for spam and nonsense
def spamFilter(tweetText):

    # Use NLTK to remove non-english words and stop-words
    words = tweetText.split()
    newText = ""
    # Check if the word is a stop word and is a proper word
    for w in words:
        if (not w in stopWords) or (w in engCorpus):
            newText = newText + " " + w
    return newText


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
        # Ignore retweets
        if tweet["retweeted"] == False:
            text = tweet["text"]
            
            # Clean and Filter data from tweet
            text = textCleaner(text)
            text = spamFilter(text)

            # Replace tweet data
            tweet["text"] = text


# Main Function
def main():

    # Open a new JSON file
    # Set up a stream listener
    btcListener = BitcoinListener()

    # Set up stream
    authentication = OAuthHandler(consumerKey, consumerSecret)
    authentication.set_access_token(accessToken, accessSecret)
    stream = Stream(authentication, btcListener ,tweet_mode = "extended")

    # Filter steam by keywords
    stream.filter(languages = ["en"], track = keywords, is_async = True)

if __name__ == "__main__": main()