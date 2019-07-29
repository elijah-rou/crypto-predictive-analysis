from pymongo import MongoClient
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer

analyzer = SentimentIntensityAnalyzer()

client = MongoClient("192.168.2.69", 27017)
db = client["sentiment_data"]
twitterData = db.twitter

docs = twitterData.find({})
regex = re.compile(",")

for doc in docs:
    cleanText = regex.sub(" ", doc["cleaned_text"])
    _id = doc["_id"]
    twitterData.update_one({"_id": _id}, { "$set": {"cleaned_text": cleanText, "sentiment": analyzer.polarity_scores(doc["text"]), "sentiment_clean": analyzer.polarity_scores(cleanText)}})
