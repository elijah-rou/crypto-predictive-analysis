#Automated Code for Updating Master Sentiment Analyis#
######################################################
library("rtweet") 
library("tidyverse")
library("twitteR") 
library("syuzhet")
library("crypto")
library("tm")
library("jsonlite")
library("lubridate")


MasterData <- data.frame(matrix(ncol = 11, nrow = 0))
x <- c("anger", "anticipation", "disgust", "fear", "joy", "negative", "positive","sadness","surprise","trust","BTC-USD")
colnames(MasterData) <- x

consumer_key2    <-"BfIYQbVQAuGAVpOKa0ldIrYgw"
consumer_secret2 <-"WARBBW6SuT5AkUi4oqIFKmbq2yzAXRBaEgBUtjZVVefjY1KjZC"
access_token2    <-"1148924254966226945-oGPaCVuMZxHTW46hEI3bjNGLI4UTA4"
access_secret2   <-"34WP9hbA2xs8VGkGMigR0Ubk8Q0lGFLiB0jCnUBZbye0R"

setup_twitter_oauth(consumer_key2, consumer_secret2, access_token2, access_secret2)


tweets_bc = searchTwitter('#bitcoin -filter:retweets',lang = "en", n = 1000, resultType = 'recent', retryOnRateLimit = 1)

### Data Processing
bitcoin_tweets <- twListToDF(tweets_bc)
bitcoin_text   <- bitcoin_tweets$text
bitcoin_text   <- tolower(bitcoin_text)
bitcoin_text   <- gsub("rt", "", bitcoin_text)
bitcoin_text   <- gsub("@w+", "", bitcoin_text)
bitcoin_text   <- gsub("[[:punct:]]", "", bitcoin_text)
bitcoin_text   <- gsub("httpw+", "",bitcoin_text)
bitcoin_text   <- gsub("[ |t]{2,}", "", bitcoin_text)
bitcoin_text   <- gsub("^ ", "", bitcoin_text)
bitcoin_text   <- gsub(" $", "", bitcoin_text)


#Sentiment Analysis 
mysentiment_bitcoin <- get_nrc_sentiment((bitcoin_text))
Sentimentscores_bitcoin <-data.frame(colSums(mysentiment_bitcoin[,]))


names(Sentimentscores_bitcoin)<-"Score"
Sentimentscores_bitcoin<-cbind("sentiment"=rownames(Sentimentscores_bitcoin),Sentimentscores_bitcoin)
rownames(Sentimentscores_bitcoin)<-NULL



############################################################################################################

tweets_cc = twitteR::searchTwitter('#crypto -filter:retweets',lang = "en", n = 1000, resultType = 'recent', retryOnRateLimit = 1)

cc_tweets <- twListToDF(tweets_cc)
cc_text<- cc_tweets$text
cc_text <- tolower(cc_text)
cc_text <- gsub("rt", "", cc_text)
cc_text <- gsub("@w+", "", cc_text)
cc_text <- gsub("[[:punct:]]", "", cc_text)
cc_text <- gsub("httpw+", "",cc_text)
cc_text <- gsub("[ |t]{2,}", "", cc_text)
cc_text <- gsub("^ ", "", cc_text)
cc_text <- gsub(" $", "", cc_text)

#Sentiment Analysis 
cc_tweets.text.corpus <- Corpus(VectorSource(cc_text))
mysentiment_cc <- get_nrc_sentiment((cc_text))
Sentimentscorescc<-data.frame(colSums(mysentiment_cc[,]))



names(Sentimentscorescc)<-"Score"
Sentimentscorescc<-cbind("sentiment"=rownames(Sentimentscorescc),Sentimentscorescc)
rownames(Sentimentscorescc)<-NULL



############################################################################################################

tweets_ccur = twitteR::searchTwitter('#cryptocurrency -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

ccur_tweets <- twListToDF(tweets_ccur)
ccur_text<- ccur_tweets$text
ccur_text <- tolower(ccur_text)
ccur_text <- gsub("rt", "", ccur_text)
ccur_text <- gsub("@w+", "", ccur_text)
ccur_text <- gsub("[[:punct:]]", "", ccur_text)
ccur_text <- gsub("httpw+", "",ccur_text)
ccur_text <- gsub("[ |t]{2,}", "", ccur_text)
ccur_text <- gsub("^ ", "", ccur_text)
ccur_text <- gsub(" $", "", ccur_text)

#Sentiment Analysis 
ccur_tweets.text.corpus <- Corpus(VectorSource(ccur_text))
mysentiment_ccur <- get_nrc_sentiment((ccur_text))
SentimentscoresCurrency <-data.frame(colSums(mysentiment_ccur[,]))



names(SentimentscoresCurrency)<-"Score"
SentimentscoresCurrency<-cbind("sentiment"=rownames(SentimentscoresCurrency),SentimentscoresCurrency)
rownames(SentimentscoresCurrency)<-NULL



consumer_key3    <- "2thaU3bm7h1pqfOgiQ90Ry2IF"
consumer_secret3 <-"6UdbkYKJKkBh4r9xqOaNYWnmKzh89lR32UNYjA75cI8ZFU0mjD"
access_token3    <-"1148900534130237440-HCWlq81HaR0PMAThmd0IJBejqc8Ne7"
access_secret3     <-"ezkf7uGnmOtpvLWoVyUzraAysTMQSQoTbiHTCNsgAPjlo"
setup_twitter_oauth(consumer_key3, consumer_secret3, access_token3, access_secret3)

############################################################################################################
tweets_block = twitteR::searchTwitter('#blockchain -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

block_tweets <- twListToDF(tweets_block)
block_text   <- block_tweets$text
block_text   <- tolower(block_text)
block_text   <- gsub("rt", "", block_text)
block_text   <- gsub("@w+", "", block_text)
block_text   <- gsub("[[:punct:]]", "", block_text)
block_text   <- gsub("httpw+", "",block_text)
block_text   <- gsub("[ |t]{2,}", "", block_text)
block_text   <- gsub("^ ", "", block_text)
block_text   <- gsub(" $", "", block_text)

#Sentiment Analysis 
block_tweets.text.corpus <- Corpus(VectorSource(block_text))
mysentiment_block <- get_nrc_sentiment((block_text))
SentimentscoresBlock <-data.frame(colSums(mysentiment_block[,]))



names(SentimentscoresBlock)<-"Score"
SentimentscoresBlock<-cbind("sentiment"=rownames(SentimentscoresBlock),SentimentscoresBlock)
rownames(SentimentscoresBlock)<-NULL



############################################################################################################
tweets_eth = twitteR::searchTwitter('#ethereum -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

eth_tweets <- twListToDF(tweets_eth)
eth_text   <- eth_tweets$text
eth_text   <- tolower(eth_text)
eth_text   <- gsub("rt", "", eth_text)
eth_text   <- gsub("@w+", "", eth_text)
eth_text   <- gsub("[[:punct:]]", "", eth_text)
eth_text   <- gsub("httpw+", "",eth_text)
eth_text   <- gsub("[ |t]{2,}", "", eth_text)
eth_text   <- gsub("^ ", "", eth_text)
eth_text   <- gsub(" $", "", eth_text)

#Sentiment Analysis 
eth_tweets.text.corpus <- Corpus(VectorSource(eth_text))
mysentiment_eth <- get_nrc_sentiment((eth_text))
Sentimentscoreseth <-data.frame(colSums(mysentiment_eth[,]))

names(Sentimentscoreseth)<-"Score"
Sentimentscoreseth<-cbind("sentiment"=rownames(Sentimentscoreseth),Sentimentscoreseth)
rownames(Sentimentscoreseth)<-NULL



###########################################################################################################
SentEth <- as_tibble(Sentimentscoreseth %>% spread('sentiment','Score'))
SentBlock <- as_tibble(SentimentscoresBlock %>% spread('sentiment','Score'))
SentCurrency <- as_tibble(SentimentscoresCurrency %>% spread('sentiment','Score'))
SentCrypto <- as_tibble(Sentimentscorescc %>%  spread('sentiment','Score'))
SentBitcoin <- as_tibble(Sentimentscores_bitcoin %>% spread('sentiment','Score'))

SentEth <- as.matrix(SentEth)
SentBlock <- as.matrix(SentBlock)
SentCurrency <- as.matrix(SentCurrency)
SentCrypto <- as.matrix(SentCrypto)
SentBitcoin <- as.matrix(SentBitcoin)

DataFrameBot <- SentEth + SentBlock + SentCurrency + SentCrypto + SentBitcoin

MasterData <- as_tibble(rbind(DataFrameBot))



###########################################################################################################
BTC_Hourly_Price <- crypto_prices('bitcoin')
BTC_USD <- as_tibble(cbind(BTC_Hourly_Price$percent_change_1h))
BTC_USD <- as_tibble(cbind(BTC_Hourly_Price$price_usd, BTC_USD))
BTC_USD <- as_tibble(cbind(BTC_Hourly_Price$last_updated, BTC_USD))

BTC_USD$Inc_Dec <- ifelse(BTC_USD$V1 > 0.0, "Increase","Decrease")
MasterData <- cbind(MasterData, BTC_USD)

colnames(MasterData)[colnames(MasterData)== "BTC_Hourly_Price$last_updated"] <- "Time_of_Price_Update"
colnames(MasterData)[colnames(MasterData)=="BTC_Hourly_Price$price_usd"] <- "Price_in_USD"
colnames(MasterData)[colnames(MasterData)=="V1"] <- "Percent_Change_t_1hour"

oldVal <- read_json(path = "data/twitter_g/sentiment_g.json", simplifyVector = TRUE) %>% as.data.frame
new_file <- rbind(MasterData, oldVal)
write_json(new_file, path = "data/twitter_g/sentiment_g.json")

print("END parse")
now()

########## ADD LINE THAT TAKES CURRENT HOUR DATA, MOVES TO A CSV OUTSIDE OF R STUDIO AND ADDS AS A NEW ROW####


#rm(MasterData)
#rm(BTC_USD)