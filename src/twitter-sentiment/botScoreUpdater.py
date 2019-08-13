# Script to update the user database with bot scores
# Necessary imports
import botometer
from pymongo import MongoClient
import pprint

# MongoDB connection
client = MongoClient("192.168.2.69", 27017)
db = client["sentiment_data"]
users = db["twitter_users"]

# Twitter Authentication
twitterAuth = {
    "consumer_key" : "LIrUnrnifiXrTaiuTmalM30Pd",
    "consumer_secret": "iH9hlwQvrdzKhkwd1RzSiAhEUjnRltgYihR1n5YPO6FkOY81k9",
    "access_token" : "1152134174108782592-qEFou1vhM61EI4tnUjzZRNsfeq8Enq",
    "access_secret" : "89d5n5V0mviJeJyXdKirjKTLDKVAa6hbeKbUuM3SXX9Yq"
}

# Botometer API key
botAPIKey = "cd3f38366emshdd2cd0a2a5cca9ep14172djsn5f6c4df5a085"
bom = botometer.Botometer(wait_on_rate_limit = True, mashape_key = botAPIKey, **twitterAuth)

# Grab 17000
user_list = users.find({})
user_list = list(user_list)

# Grab botometer score for the first 17000 entries (first 22 done already)
# & insert into Mongo
for i in range(23, 17000):
    try:
        result = bom.check_account(user_list[i]["id"])
        result.pop("display_scores")
        result.pop("user")
        result["authorised"] = True
        pprint.pprint(result)
        users.update_one({"_id": user_list[i]["_id"]}, {"$set": result})
    except:
        print("User " + str(user_list[i]["id"]) + "(@" + user_list[i]["screen_name"] + ") is not authorised")
        users.update_one({"_id": user_list[i]["_id"]}, {"$set": {"authorised": False}})
        print("CONTINUING...")
    