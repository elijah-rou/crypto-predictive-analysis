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

docs = twitterData.find({})
for doc in docs:
    if "retweeted_status" in doc:
        twitterData.delete_one({"_id": doc["_id"]})
        print(doc["time"])

docs_3 = twitterData.find(
{
  'time':{'$gte': "2019-07-26T00:00:00+0000",
          '$lte': "2019-07-27T00:00:00+0000"}
})

twitterUsers = db.twitter_users

docs = twitterData.find({})

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


for doc in docs:
    user = doc["user"]
    user.pop("id_str")
    user.pop("translator_type")
    user["time"] = toTimestamp(user["created_at"])
    twitterUsers.update_one({"id": user["id"]},{"$set": user}, upsert  = True)


