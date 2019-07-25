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

# Set up twitter API credentials
consumer_key2    <-"BfIYQbVQAuGAVpOKa0ldIrYgw"
consumer_secret2 <-"WARBBW6SuT5AkUi4oqIFKmbq2yzAXRBaEgBUtjZVVefjY1KjZC"
access_token2    <-"1148924254966226945-oGPaCVuMZxHTW46hEI3bjNGLI4UTA4"
access_secret2   <-"34WP9hbA2xs8VGkGMigR0Ubk8Q0lGFLiB0jCnUBZbye0R"

# Twitter Authentication
setup_twitter_oauth(consumer_key2, consumer_secret2, access_token2, access_secret2)

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
calculateSentiment <- function(tweetData){
    sentimentScores <- get_nrc_sentiment(tweetData)
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