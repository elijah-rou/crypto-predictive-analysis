# R Script to calculate sentiment and store it along with the bitcoin price in a JSON

library("rtweet") 
library("tidyverse")
library("twitteR") 
library("syuzhet")
library("crypto")
library("tidytext")
library("dplyr")
library("jsonlite")
library("datetime")
library("lubridate")
library("cronR")
library("miniUI")
library("shiny")
library("shinyFiles")
library("mongolite")
library("cryptor")
library("zoo")

# Set up twitter API credentials
consumer_key    <-"BfIYQbVQAuGAVpOKa0ldIrYgw"
consumer_secret <-"WARBBW6SuT5AkUi4oqIFKmbq2yzAXRBaEgBUtjZVVefjY1KjZC"
access_token    <-"1148924254966226945-oGPaCVuMZxHTW46hEI3bjNGLI4UTA4"
access_secret   <-"34WP9hbA2xs8VGkGMigR0Ubk8Q0lGFLiB0jCnUBZbye0R"

# Twitter Authentication
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)


# Functions
# Function to search twitter and return the text of the tweets associated with the phrase
getTweets <- function(searchPhrase){
    time1 <- Sys.time()
    time2 <- time1 - 900
    tweets <- searchTwitter(paste(searchPhrase, " -filter:retweets"), lang = "en", n = 1000, resultType = "recent", retryOnRateLimit = 1)
    tweets <- twListToDF(tweets)
    tweets$current <- ifelse(tweets$created > time2, 1, 0)
    current <- filter(tweets, current == 1)
    text   <- current$text %>%
        tolower %>%
        gsub("rt", "", .) %>%
        gsub("@\\w+", "", .) %>%
        gsub("[[:punct:]]", "", .) %>%
        gsub("http\\w+", "", .) %>%
        gsub("[ |\t]{2,}", "", .) %>%
        gsub("^ ", "", .) %>%
        gsub(" $", "", .)
    return(text)
}

# Function that updates a json file with newly calculated values
updateJson <- function(fileName, newData){
    oldFile <- read_json(path = paste("data/twitter/", fileName), simplifyVector = TRUE) %>%
        as_tibble
    newFile <- rbind(oldFile, newData) %>% 
        distinct
    write_json(newFile, path = paste("data/twitter/", fileName))
}

# Calculate the sentiment for a collection of tweets and output a matrix
calculateSentimentNRC <- function(tweetData){
    sentimentScores <- get_nrc_sentiment(tweetData)
    sentimentScores <- data.frame(colSums(sentimentScores[,]))
    names(sentimentScores) <- "Score"
    sentimentScores<-cbind("sentiment"=rownames(sentimentScores), sentimentScores)
    rownames(sentimentScores) <- NULL
    sentimentMatrix <- as_tibble(sentimentScores %>% spread("sentiment","Score")) %>% as.matrix
    return(sentimentMatrix)
}


calculateSentiment <- function(tweetData){
    sentimentScores <- get_sentiment(tweetData)
    sentimentScores <- data.frame(colSums(sentimentScores[,]))
    names(sentimentScores) <- "Score"
    sentimentScores<-cbind("sentiment"=rownames(sentimentScores), sentimentScores)
    rownames(sentimentScores) <- NULL
    sentimentMatrix <- as_tibble(sentimentScores %>% spread("sentiment","Score")) %>% as.matrix
    return(sentimentMatrix)
}

# Grab tweets with various search parameters and perform sentiment analysis
hbitcoin_tweets <- getTweets("#bitcoin") %>% calculateSentiment
hbtc_tweets <- getTweets("#btc") %>% calculateSentiment
hcrypto_tweets <- getTweets("#crypto") %>% calculateSentiment
hcryptocurrency_tweets <- getTweets("#cryptocurrency") %>% calculateSentiment
hblockchain_tweets <- getTweets("#blockchain") %>% calculateSentiment
hethereum_tweets <- getTweets("#ethereum") %>% calculateSentiment
heth_tweets <- getTweets("#eth") %>% calculateSentiment
hcryptonews_tweets <- getTweets("#cryptonews") %>% calculateSentiment
hbitcoinnews_tweets <- getTweets("#bitcoinnews") %>% calculateSentiment
hbitcoinmining_tweets <- getTweets("#bitcoinmining") %>% calculateSentiment
hhodl_tweets <- getTweets <- getTweets("#hodl") %>% calculateSentiment
bitcoin_tweets <- getTweets("bitcoin") %>% calculateSentiment
btc_tweets <- getTweets("btc") %>% calculateSentiment
crypto_tweets <- getTweets("crypto") %>% calculateSentiment
cryptocurrency_tweets <- getTweets("cryptocurrency") %>% calculateSentiment
blockchain_tweets <- getTweets("blockchain") %>% calculateSentiment
ethereum_tweets <- getTweets("ethereum") %>% calculateSentiment
eth_tweets <- getTweets("eth") %>% calculateSentiment
bitcoinNews_tweets <- getTweets("bitcoin+news") %>% calculateSentiment
bitcoinMining_tweets <- getTweets("bitcoin+mining") %>% calculateSentiment
hodl_tweets <- getTweets <- getTweets("hodl") %>% calculateSentiment
fud_tweets <- getTweets <- getTweets("bitcoin+fud") %>% calculateSentiment
whale_tweets <- getTweets("whale+bitcoin") %>% calculateSentiment
mooning_tweets <-getTweets("bitcoin+mooning") %>% calculateSentiment
buy_tweets <- getTweets("buy+bitcoin") %>% calculateSentiment
sell_tweets <- getTweets("sell+bitcoin") %>% calculateSentiment



combinedSentiment <- hbitcoin_tweets + hbtc_tweets + hcrypto_tweets + hcryptocurrency_tweets +
hblockchain_tweets + hethereum_tweets + heth_tweets + hcryptonews_tweets + hbitcoinnews_tweets +
hbitcoinmining_tweets + hhodl_tweets + bitcoin_tweets + btc_tweets + crypto_tweets + cryptocurrency_tweets +
blockchain_tweets + ethereum_tweets + eth_tweets + bitcoinNews_tweets + bitcoinMining_tweets +
hodl_tweets + fud_tweets + whale_tweets + mooning_tweets + buy_tweets + sell_tweets

combinedData <- as_tibble(rbind(combinedSentiment))

btcPrice <- crypto_prices('bitcoin')
btcUSD   <- as_tibble(cbind(btcPrice$percent_change_1h, btcPrice$price_usd, btcPrice$last_updated))
btcUSD$Inc_Dec <- ifelse(BTC_USD$V1 > 0.0, "Increase","Decrease")
combinedData <- cbind(combinedData, BTC_USD)

colnames(combinedData)[colnames(combinedData)== "BTC_Price$last_updated"] <- "Time_of_Price_Update"
colnames(combinedData)[colnames(combinedData)=="BTC_Price$price_usd"] <- "Price_in_USD"
colnames(combinedData)[colnames(combinedData)=="V1"] <- "Percent_Change"

updateJson("sentimentData.json", combinedData)

########### With Mongo
# Connect to MongoDB database
tweets <-mongo(collection = "twitter", db = "sentiment_data", url="mongodb://192.168.2.69:27017")

# Fetch all tweets
all_tweets <- tweets$find("{}", limit = 1) %>% as.data.frame

all_tweets <- tweets$find(query = '{"time": {"$gte": { "$date": "2019-07-28T00:00:00+0000"} } }')

issues$find(
    query = '{"created_at": { "$gte" : { "$date" : "2017-01-01T00:00:00Z" }}}',
    fields = '{"created_at" : true, "user.login" : true, "title":true, "_id": false}'
)

# Create a column of Time object values
all_tweets$time_created <- as.POSIXct(all_tweets$time, 'UTC')

first_10k <- tweets$find("{}", limit=1) %>% as.data.frame
#first_10k$time_lt <- strptime(first_10k$time, format = "%Y-%m-%d %H:%M:%S")
first_10k$time_created <- as.POSIXct(first_10k$time, 'UTC')

df <- cbind(first_10k$time, first_10k$time_created, first_10k$time_lt, first_10k$cleaned_text,  first_10k$text, first_10k$tweet_id) %>% as.data.frame
colnames(df)[colnames(df) == "V1"] <- "time"
colnames(df)[colnames(df) == "V2"] <- "timestamp"
#colnames(df)[colnames(df) == "V3"] <- "time_as_POSIX"
colnames(df)[colnames(df) == "V3"] <- "cleaned_text"
colnames(df)[colnames(df) == "V4"] <- "text"
colnames(df)[colnames(df) == "V5"] <- "tweet_id"

cleaned_text <- gsub(",", " ", df$cleaned_text) 
twitter_text <- df$text %>%
        tolower %>%
        gsub("rt", "", .) %>%
        gsub("@\\w+", "", .) %>%
        gsub("[[:punct:]]", "", .) %>%
        gsub("http\\w+", "", .) %>%
        gsub("[ |\t]{2,}", "", .) %>%
        gsub("^ ", "", .) %>%
        gsub(" $", "", .)
df$score_with_clean <- as.list(get_sentiment(cleaned_text))
#df$score_raw <- as.list(get_sentiment(twitter_text))

df_2 <- df[!duplicated(df[,c('text')]),]
df_2$minute <- minute(df_2$time)
df_2$hour <- hour(df_2$time)
df_2$day <- day(df_2$time)


aggregate(df_2$score_with_clean, by = list(df_2$minute, df_2$hour, df_2$day), FUN = sum)


final <- df_2 %>%
    group_by(minute, hour, day)
    #summarize(n())
    summarise(sum_score = sum(score_with_clean))

