# Module that processes text and produces clean text
##
# Necessary Libraries 
# Regular Expression module
import re
# NLTK corpi
from nltk.corpus import stopwords
from nltk.corpus import words
stopWords = set(stopwords.words("english"))
engCorpus = set(words.words())

# Function that converts text to lowercase, removes whitespace
# and removes all non-alphabetic characters
def textCleaner(text):
    # Convert text to lowercase
    newText = text.lower()

    # Strip whitespace from text
    newText = newText.strip()

    # Remove all non-alphabetic characters using regular expression
    regex = re.compile("[^a-zA-Z]")
    # Remove all excess whitespace
    newText = re.sub("\s\s+", " ", regex.sub(" ", newText))
    
    return newText


# Function to filter text for spam, duplicates and non-Englinsh words
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

# Function to convert a twitter created_at value to a UTC timestamp
def toTimestamp(date):
    timestamp = date[-4:]+"-"
    timestamp += monthNum[date[4:7]]+"-"+date[8:10]+" "
    timestamp += date[11:19]
    return(timestamp)