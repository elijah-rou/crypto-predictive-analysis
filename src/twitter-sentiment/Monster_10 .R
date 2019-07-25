#######################################################
########## 15minute Interval Twitter Download #########
#######################################################
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


consumer_key2    <-"BfIYQbVQAuGAVpOKa0ldIrYgw"
consumer_secret2 <-"WARBBW6SuT5AkUi4oqIFKmbq2yzAXRBaEgBUtjZVVefjY1KjZC"
access_token2    <-"1148924254966226945-oGPaCVuMZxHTW46hEI3bjNGLI4UTA4"
access_secret2   <-"34WP9hbA2xs8VGkGMigR0Ubk8Q0lGFLiB0jCnUBZbye0R"

setup_twitter_oauth(consumer_key2, consumer_secret2, access_token2, access_secret2)


####################################################### #Bitcoin #######################################################
time1 = Sys.time()
time2 = time1 - 900

tweets_bc = searchTwitter('#bitcoin -filter:retweets',lang = "en", n = 1000, resultType = 'recent', retryOnRateLimit = 1)

#Only looking at most recent tweets from t-15mins
bitcoin_tweets <- twListToDF(tweets_bc)
bitcoin_tweets$current <- ifelse(bitcoin_tweets$created > time2, 1, 0)
bitcoin_current <- filter(bitcoin_tweets, current == 1)
  
bitcoin_text   <- bitcoin_current$text
bitcoin_text   <- tolower(bitcoin_text)
bitcoin_text   <- gsub("rt", "", bitcoin_text)
bitcoin_text   <- gsub("@\\w+", "", bitcoin_text)
bitcoin_text   <- gsub("[[:punct:]]", "", bitcoin_text)
bitcoin_text   <- gsub("http\\w+", "",bitcoin_text)
bitcoin_text   <- gsub("[ |\t]{2,}", "", bitcoin_text)
bitcoin_text   <- gsub("^ ", "", bitcoin_text)
bitcoin_text   <- gsub(" $", "", bitcoin_text)

####################################################### #BTC ##########################################################
time1 = Sys.time()
time2 = time1 - 900

tweets_btc = searchTwitter('#btc -filter:retweets',lang = "en", n=1000, resultType = 'recent', retryOnRateLimit = 1)


#Only looking at most recent tweets from t-15mins
btc_tweets <- twListToDF(tweets_btc)
btc_tweets$current <- ifelse(btc_tweets$created > time2, 1, 0)
btc_current <- filter(btc_tweets, current == 1)


btc_text   <- btc_current$text
btc_text   <- tolower(btc_text)
btc_text   <- gsub("rt", "", btc_text)
btc_text   <- gsub("@\\w+", "", btc_text)
btc_text   <- gsub("[[:punct:]]", "", btc_text)
btc_text   <- gsub("http\\w+", "",btc_text)
btc_text   <- gsub("[ |\t]{2,}", "", btc_text)
btc_text   <- gsub("^ ", "", btc_text)
btc_text   <- gsub(" $", "", btc_text)

####################################################### #crypto ##########################################################
time1 = Sys.time()
time2 = time1 - 900

tweets_cc = twitteR::searchTwitter('#crypto -filter:retweets',lang = "en", n = 1000, resultType = 'recent', retryOnRateLimit = 1)

#Only looking at most recent tweets from t-15mins
cc_tweets <- twListToDF(tweets_cc)
cc_tweets$current <- ifelse(cc_tweets$created > time2, 1, 0)
cc_current <- filter(cc_tweets, current == 1)


cc_text<- cc_current$text
cc_text <- tolower(cc_text)
cc_text <- gsub("rt", "", cc_text)
cc_text <- gsub("@\\w+", "", cc_text)
cc_text <- gsub("[[:punct:]]", "", cc_text)
cc_text <- gsub("http\\w+", "",cc_text)
cc_text <- gsub("[ |\t]{2,}", "", cc_text)
cc_text <- gsub("^ ", "", cc_text)
cc_text <- gsub(" $", "", cc_text)

####################################################### #cryptocurrency ####################################################
time1 = Sys.time()
time2 = time1 - 900

tweets_ccur = twitteR::searchTwitter('#cryptocurrency -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

#Only looking at most recent tweets from t-15mins
ccur_tweets <- twListToDF(tweets_ccur)
ccur_tweets$current <- ifelse(ccur_tweets$created > time2, 1, 0)
ccur_current <- filter(ccur_tweets, current == 1)

ccur_text<- ccur_current$text
ccur_text <- tolower(ccur_text)
ccur_text <- gsub("rt", "", ccur_text)
ccur_text <- gsub("@\\w+", "", ccur_text)
ccur_text <- gsub("[[:punct:]]", "", ccur_text)
ccur_text <- gsub("http\\w+", "",ccur_text)
ccur_text <- gsub("[ |\t]{2,}", "", ccur_text)
ccur_text <- gsub("^ ", "", ccur_text)
ccur_text <- gsub(" $", "", ccur_text)


####################################################### #blockchain ####################################################
time1 = Sys.time()
time2 = time1 - 900

tweets_block = twitteR::searchTwitter('#blockchain -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

#Only looking at most recent tweets from t-15mins
block_tweets <- twListToDF(tweets_block) 
block_tweets$current <- ifelse(block_tweets$created > time2, 1, 0)
block_current <- filter(block_tweets, current == 1)

  block_text   <- block_current$text
  block_text   <- tolower(block_text)
  block_text   <- gsub("rt", "", block_text)
  block_text   <- gsub("@\\w+", "", block_text)
  block_text   <- gsub("[[:punct:]]", "", block_text)
  block_text   <- gsub("http\\w+", "",block_text)
  block_text   <- gsub("[ |\t]{2,}", "", block_text)
  block_text   <- gsub("^ ", "", block_text)
  block_text   <- gsub(" $", "", block_text)

####################################################### Update Token  ####################################################
consumer_key3    <- "2thaU3bm7h1pqfOgiQ90Ry2IF"
consumer_secret3 <-"6UdbkYKJKkBh4r9xqOaNYWnmKzh89lR32UNYjA75cI8ZFU0mjD"
access_token3    <-"1148900534130237440-HCWlq81HaR0PMAThmd0IJBejqc8Ne7"
access_secret3     <-"ezkf7uGnmOtpvLWoVyUzraAysTMQSQoTbiHTCNsgAPjlo"
setup_twitter_oauth(consumer_key3, consumer_secret3, access_token3, access_secret3)

####################################################### #ethereum ####################################################
time1 = Sys.time()
time2 = time1 - 900

tweets_ether = twitteR::searchTwitter('#ethereum -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

#Only looking at most recent tweets from t-15mins
ether_tweets <- twListToDF(tweets_ether)
ether_tweets$current <- ifelse(ether_tweets$created > time2, 1, 0)
ether_current <- filter(ether_tweets, current == 1)

ether_text   <- ether_current$text
ether_text   <- tolower(ether_text)
ether_text   <- gsub("rt", "", ether_text)
ether_text   <- gsub("@\\w+", "", ether_text)
ether_text   <- gsub("[[:punct:]]", "", ether_text)
ether_text   <- gsub("http\\w+", "",ether_text)
ether_text   <- gsub("[ |\t]{2,}", "", ether_text)
ether_text   <- gsub("^ ", "", ether_text)
ether_text   <- gsub(" $", "", ether_text)

####################################################### #eth ####################################################
time1 = Sys.time()
time2 = time1 - 900

tweets_eth = twitteR::searchTwitter('#eth -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

#Only looking at most recent tweets from t-15mins
eth_tweets <- twListToDF(tweets_eth)
eth_tweets$current <- ifelse(eth_tweets$created > time2, 1, 0)
eth_current <- filter(eth_tweets, current == 1)

eth_text   <- eth_current$text
eth_text   <- tolower(eth_text)
eth_text   <- gsub("rt", "", eth_text)
eth_text   <- gsub("@\\w+", "", eth_text)
eth_text   <- gsub("[[:punct:]]", "", eth_text)
eth_text   <- gsub("http\\w+", "",eth_text)
eth_text   <- gsub("[ |\t]{2,}", "", eth_text)
eth_text   <- gsub("^ ", "", eth_text)
eth_text   <- gsub(" $", "", eth_text)

####################################################### #cryptonews ####################################################
time1 = Sys.time()
time2 = time1 - 900

tweets_cryn = twitteR::searchTwitter('#cryptonews -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

#Only looking at most recent tweets from t-15mins
cryn_tweets <- twListToDF(tweets_cryn)
cryn_tweets$current <- ifelse(cryn_tweets$created > time2, 1, 0)
cryn_current <- filter(cryn_tweets, current == 1)

cryn_text   <- cryn_current$text
cryn_text   <- tolower(cryn_text)
cryn_text   <- gsub("rt", "", cryn_text)
cryn_text   <- gsub("@\\w+", "", cryn_text)
cryn_text   <- gsub("[[:punct:]]", "", cryn_text)
cryn_text   <- gsub("http\\w+", "",cryn_text)
cryn_text   <- gsub("[ |\t]{2,}", "", cryn_text)
cryn_text   <- gsub("^ ", "", cryn_text)
cryn_text   <- gsub(" $", "", cryn_text)

####################################################### #bitcoinnews ####################################################
time1 = Sys.time()
time2 = time1 - 900

tweets_btcnew = twitteR::searchTwitter('#bitcoinnews -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

#Only looking at most recent tweets from t-15mins
btcnew_tweets <- twListToDF(tweets_btcnew)
btcnew_tweets$current <- ifelse(btcnew_tweets$created > time2, 1, 0)
btcnew_current <- filter(btcnew_tweets, current == 1)

btcnew_text   <- btcnew_current$text
btcnew_text   <- tolower(btcnew_text)
btcnew_text   <- gsub("rt", "", btcnew_text)
btcnew_text   <- gsub("@\\w+", "", btcnew_text)
btcnew_text   <- gsub("[[:punct:]]", "", btcnew_text)
btcnew_text   <- gsub("http\\w+", "",btcnew_text)
btcnew_text   <- gsub("[ |\t]{2,}", "", btcnew_text)
btcnew_text   <- gsub("^ ", "", btcnew_text)
btcnew_text   <- gsub(" $", "", btcnew_text)

####################################################### #bitcoinmining ##################################################
time1 = Sys.time()
time2 = time1 - 900

tweets_btcmin = twitteR::searchTwitter('#bitcoinmining -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

#Only looking at most recent tweets from t-15mins
btcmin_tweets <- twListToDF(tweets_btcmin)
btcmin_tweets$current <- ifelse(btcmin_tweets$created > time2, 1, 0)
btcmin_current <- filter(btcmin_tweets, current == 1)

btcmin_text   <- btcmin_current$text
btcmin_text   <- tolower(btcmin_text)
btcmin_text   <- gsub("rt", "", btcmin_text)
btcmin_text   <- gsub("@\\w+", "", btcmin_text)
btcmin_text   <- gsub("[[:punct:]]", "", btcmin_text)
btcmin_text   <- gsub("http\\w+", "",btcmin_text)
btcmin_text   <- gsub("[ |\t]{2,}", "", btcmin_text)
btcmin_text   <- gsub("^ ", "", btcmin_text)
btcmin_text   <- gsub(" $", "", btcmin_text)


####################################################### #hodl ###########################################################
time1 = Sys.time()
time2 = time1 - 900

tweets_hodl = twitteR::searchTwitter('#hodl -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

#Only looking at most recent tweets from t-15mins
hodl_tweets <- twListToDF(tweets_hodl)
hodl_tweets$current <- ifelse(hodl_tweets$created > time2, 1, 0)
hodl_current <- filter(hodl_tweets, current == 1)

hodl_text   <- hodl_current$text
hodl_text   <- tolower(hodl_text)
hodl_text   <- gsub("rt", "", hodl_text)
hodl_text   <- gsub("@\\w+", "", hodl_text)
hodl_text   <- gsub("[[:punct:]]", "", hodl_text)
hodl_text   <- gsub("http\\w+", "",hodl_text)
hodl_text   <- gsub("[ |\t]{2,}", "", hodl_text)
hodl_text   <- gsub("^ ", "", hodl_text)
hodl_text   <- gsub(" $", "", hodl_text)

####################################################### Update Token  ####################################################
consumer_key        <- "LIrUnrnifiXrTaiuTmalM30Pd"
consumer_secret     <-"iH9hlwQvrdzKhkwd1RzSiAhEUjnRltgYihR1n5YPO6FkOY81k9"
access_token        <-"1152134174108782592-qEFou1vhM61EI4tnUjzZRNsfeq8Enq"
access_token_secret <-"89d5n5V0mviJeJyXdKirjKTLDKVAa6hbeKbUuM3SXX9Yq"

setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_token_secret)

########################################################### Search Bitcoin ##################################################
time1 = Sys.time()
time2 = time1 - 900

tweets_Sbit = twitteR::searchTwitter('bitcoin -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

#Only looking at most recent tweets from t-15mins
Sbit_tweets <- twListToDF(tweets_Sbit)
Sbit_tweets$current <- ifelse(Sbit_tweets$created > time2, 1, 0)
Sbit_current <- filter(Sbit_tweets, current == 1)

Sbit_text   <- Sbit_current$text
Sbit_text   <- tolower(Sbit_text)
Sbit_text   <- gsub("rt", "", Sbit_text)
Sbit_text   <- gsub("@\\w+", "", Sbit_text)
Sbit_text   <- gsub("[[:punct:]]", "", Sbit_text)
Sbit_text   <- gsub("http\\w+", "",Sbit_text)
Sbit_text   <- gsub("[ |\t]{2,}", "", Sbit_text)
Sbit_text   <- gsub("^ ", "", Sbit_text)
Sbit_text   <- gsub(" $", "", Sbit_text)

########################################################### Search Cryptocurrency ##############################################
time1 = Sys.time()
time2 = time1 - 900

tweets_Scc = twitteR::searchTwitter('cryptocurrency -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)


#Only looking at most recent tweets from t-15mins
Scc_tweets <- twListToDF(tweets_Scc)
Scc_tweets$current <- ifelse(Scc_tweets$created > time2, 1, 0)
Scc_current <- filter(Scc_tweets, current == 1)

Scc_text   <- Scc_current$text
Scc_text   <- tolower(Scc_text)
Scc_text   <- gsub("rt", "", Scc_text)
Scc_text   <- gsub("@\\w+", "", Scc_text)
Scc_text   <- gsub("[[:punct:]]", "", Scc_text)
Scc_text   <- gsub("http\\w+", "",Scc_text)
Scc_text   <- gsub("[ |\t]{2,}", "", Scc_text)
Scc_text   <- gsub("^ ", "", Scc_text)
Scc_text   <- gsub(" $", "", Scc_text)

########################################################### Search Crypto ####################################################
time1 = Sys.time()
time2 = time1 - 900

tweets_Scp = twitteR::searchTwitter('crypto -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)


#Only looking at most recent tweets from t-15mins
Scp_tweets <- twListToDF(tweets_Scp)
Scp_tweets$current <- ifelse(Scp_tweets$created > time2, 1, 0)
Scp_current <- filter(Scp_tweets, current == 1)

Scp_text   <- Scp_current$text
Scp_text   <- tolower(Scp_text)
Scp_text   <- gsub("rt", "", Scp_text)
Scp_text   <- gsub("@\\w+", "", Scp_text)
Scp_text   <- gsub("[[:punct:]]", "", Scp_text)
Scp_text   <- gsub("http\\w+", "",Scp_text)
Scp_text   <- gsub("[ |\t]{2,}", "", Scp_text)
Scp_text   <- gsub("^ ", "", Scp_text)
Scp_text   <- gsub(" $", "", Scp_text)

########################################################### Search Blockchain ####################################################
time1 = Sys.time()
time2 = time1 - 900

tweets_Sblock = twitteR::searchTwitter('blockchain -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

#Only looking at most recent tweets from t-15mins
Sblock_tweets <- twListToDF(tweets_Sblock)
Sblock_tweets$current <- ifelse(Sblock_tweets$created > time2, 1, 0)
Sblock_current <- filter(Sblock_tweets, current == 1)

Sblock_text   <- Sblock_current$text
Sblock_text   <- tolower(block_text)
Sblock_text   <- gsub("rt", "", Sblock_text)
Sblock_text   <- gsub("@\\w+", "", Sblock_text)
Sblock_text   <- gsub("[[:punct:]]", "", Sblock_text)
Sblock_text   <- gsub("http\\w+", "",Sblock_text)
Sblock_text   <- gsub("[ |\t]{2,}", "", Sblock_text)
Sblock_text   <- gsub("^ ", "", Sblock_text)
Sblock_text   <- gsub(" $", "", Sblock_text)

########################################################### Search bitcon mining ###################################################
time1 = Sys.time()
time2 = time1 - 900

tweets_Sbtcmin = twitteR::searchTwitter('bitcoin mining -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

#Only looking at most recent tweets from t-15mins
Sbtcmin_tweets <- twListToDF(tweets_Sbtcmin)
Sbtcmin_tweets$current <- ifelse(Sbtcmin_tweets$created > time2, 1, 0)
Sbtcmin_current <- filter(Sbtcmin_tweets, current == 1)

Sbtcmin_text   <- Sbtcmin_current$text
Sbtcmin_text   <- tolower(Sbtcmin_text)
Sbtcmin_text   <- gsub("rt", "", Sbtcmin_text)
Sbtcmin_text   <- gsub("@\\w+", "", Sbtcmin_text)
Sbtcmin_text   <- gsub("[[:punct:]]", "", Sbtcmin_text)
Sbtcmin_text   <- gsub("http\\w+", "",Sbtcmin_text)
Sbtcmin_text   <- gsub("[ |\t]{2,}", "", Sbtcmin_text)
Sbtcmin_text   <- gsub("^ ", "", Sbtcmin_text)
Sbtcmin_text   <- gsub(" $", "", Sbtcmin_text)


########################################################### Search sell bitcoin ###################################################
time1 = Sys.time()
time2 = time1 - 900

tweets_SB = twitteR::searchTwitter('sell bitcoin -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

#Only looking at most recent tweets from t-15mins
SB_tweets <- twListToDF(tweets_SB)
SB_tweets$current <- ifelse(SB_tweets$created > time2, 1, 0)
SB_current <- filter(SB_tweets, current == 1)

SB_text   <- SB_current$text
SB_text   <- tolower(SB_text)
SB_text   <- gsub("rt", "", SB_text)
SB_text   <- gsub("@\\w+", "", SB_text)
SB_text   <- gsub("[[:punct:]]", "", SB_text)
SB_text   <- gsub("http\\w+", "",SB_text)
SB_text   <- gsub("[ |\t]{2,}", "", SB_text)
SB_text   <- gsub("^ ", "", SB_text)
SB_text   <- gsub(" $", "", SB_text)


############################################################## Search buy bitcoin ###################################################
time1 = Sys.time()
time2 = time1 - 900

tweets_BB = twitteR::searchTwitter('buy+bitcoin -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

#Only looking at most recent tweets from t-15mins
BB_tweets <- twListToDF(tweets_BB)
BB_tweets$current <- ifelse(BB_tweets$created > time2, 1, 0)
BB_current <- filter(BB_tweets, current == 1)

BB_text   <- BB_current$text
BB_text   <- tolower(BB_text)
BB_text   <- gsub("rt", "", BB_text)
BB_text   <- gsub("@\\w+", "", BB_text)
BB_text   <- gsub("[[:punct:]]", "", BB_text)
BB_text   <- gsub("http\\w+", "",BB_text)
BB_text   <- gsub("[ |\t]{2,}", "", BB_text)
BB_text   <- gsub("^ ", "", BB_text)
BB_text   <- gsub(" $", "", BB_text)

############################################################## Search HODL ###################################################
time1 = Sys.time()
time2 = time1 - 900

tweets_hodl2 = twitteR::searchTwitter('bitcoin HODL -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

#Only looking at most recent tweets from t-15mins
hodl2_tweets <- twListToDF(tweets_hodl2)
hodl2_tweets$current <- ifelse(hodl2_tweets$created > time2, 1, 0)
hodl2_current <- filter(hodl2_tweets, current == 1)

hodl2_text   <- hodl2_current$text
hodl2_text   <- tolower(hodl2_text)
hodl2_text   <- gsub("rt", "", hodl2_text)
hodl2_text   <- gsub("@\\w+", "", hodl2_text)
hodl2_text   <- gsub("[[:punct:]]", "", hodl2_text)
hodl2_text   <- gsub("http\\w+", "",hodl2_text)
hodl2_text   <- gsub("[ |\t]{2,}", "", hodl2_text)
hodl2_text   <- gsub("^ ", "", hodl2_text)
hodl2_text   <- gsub(" $", "", hodl2_text)

############################################################## Search FUD ###################################################
time1 = Sys.time()
time2 = time1 - 900

tweets_fud = twitteR::searchTwitter('bitcoin FUD -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

#Only looking at most recent tweets from t-15mins
fud_tweets <- twListToDF(tweets_fud)
fud_tweets$current <- ifelse(fud_tweets$created > time2, 1, 0)
fud_current <- filter(fud_tweets, current == 1)

fud_text   <- fud_current$text
fud_text   <- tolower(fud_text)
fud_text   <- gsub("rt", "", fud_text)
fud_text   <- gsub("@\\w+", "", fud_text)
fud_text   <- gsub("[[:punct:]]", "", fud_text)
fud_text   <- gsub("http\\w+", "",fud_text)
fud_text   <- gsub("[ |\t]{2,}", "", fud_text)
fud_text   <- gsub("^ ", "", fud_text)
fud_text   <- gsub(" $", "", fud_text)

############################################################## Search Whale ###################################################
time1 = Sys.time()
time2 = time1 - 900

tweets_whale = twitteR::searchTwitter('whale bitcoin -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

#Only looking at most recent tweets from t-15mins
whale_tweets <- twListToDF(tweets_whale)
whale_tweets$current <- ifelse(whale_tweets$created > time2, 1, 0)
whale_current <- filter(whale_tweets, current == 1)

whale_text   <- whale_current$text
whale_text   <- tolower(whale_text)
whale_text   <- gsub("rt", "", whale_text)
whale_text   <- gsub("@\\w+", "", whale_text)
whale_text   <- gsub("[[:punct:]]", "", whale_text)
whale_text   <- gsub("http\\w+", "",whale_text)
whale_text   <- gsub("[ |\t]{2,}", "", whale_text)
whale_text   <- gsub("^ ", "", whale_text)
whale_text   <- gsub(" $", "", whale_text)

############################################################## Search Mooning ###################################################
time1 = Sys.time()
time2 = time1 - 900

tweets_moon = twitteR::searchTwitter('bitcoin mooning -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

moon_tweets <- twListToDF(tweets_moon)
moon_tweets$current <- ifelse(moon_tweets$created > time2, 1, 0)
moon_current <- filter(moon_tweets, current == 1)

moon_text   <- moon_current$text
moon_text   <- tolower(moon_text)
moon_text   <- gsub("rt", "", moon_text)
moon_text   <- gsub("@\\w+", "", moon_text)
moon_text   <- gsub("[[:punct:]]", "", moon_text)
moon_text   <- gsub("http\\w+", "",moon_text)
moon_text   <- gsub("[ |\t]{2,}", "", moon_text)
moon_text   <- gsub("^ ", "", moon_text)
moon_text   <- gsub(" $", "", moon_text)

#################################################################### writing Jsons for raw twitter data ##################################################################

#moon_text
oldVal   <- read_json(path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/moon_text.json", simplifyVector = TRUE) 
oldVal   <- as_tibble(oldVal)
new_file <- rbind(oldVal, moon_text)
new_file <- new_file %>% distinct
write_json(moon_text, path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/moon_text.json") 

#bitcoin_text
bitVal   <- read_json(path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/bitcoin_text.json", simplifyVector = TRUE)
bitVal   <- as_tibble(bitVal)
bit_file <- rbind(bitVal, bitcoin_text)
bit_file <- bit_file %>% distinct
write_json(bitcoin_text, path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/bitcoin_text.json") 

#fud_text
fudVal   <- read_json(path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/fud_text.json", simplifyVector = TRUE)
fudVal   <- as_tibble(fudVal)
fud_file <- rbind(bitVal, fud_text)
fud_file <- fud_file %>% distinct
write_json(fud_text, path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/fud_text.json")

#btc_text
btcVal   <- read_json(path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/btc_text.json", simplifyVector = TRUE)
btcVal   <- as_tibble(btcVal)
btc_file <- rbind(btcVal, btc_text)
btc_file <- btc_file %>% distinct
write_json(btc_text, path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/btc_text.json")

#cc_text
CCVal    <- read_json(path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/cc_text.json", simplifyVector = TRUE)
CCVal    <- as_tibble(ccVal)
cc_file  <- rbind(CCVal, cc_text)
cc_file <- cc_file %>% distinct
write_json(cc_text, path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/cc_text.json")

#ccur_text 
ccurVal   <- read_json(path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/ccur_text.json", simplifyVector = TRUE)
ccurVal   <- as_tibble(ccurVal)
ccur_file <- rbind(ccurVal, ccur_text)
ccur_file <- ccur_file %>% distinct
write_json(ccur_text, path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/ccur_text.json")

#block_text
blockVal  <- read_json(path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/block_text.json", simplifyVector = TRUE)
ccurVal   <- as_tibble(ccurVal)
ccur_file <- rbind(ccurVal, ccur_text)
ccur_file <- ccur_file %>% distinct
write_json(block_text, path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/ccur_text.json")

#ether_text
etherVal <- read_json(path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/ether_text.json", simplifyVector = TRUE)
etherVal <- as_tibble(etherVal)
ether_file <- rbind(etherVal, ether_text)
ether_file <- ether_file %>% distinct
write_json(ether_text, path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/ether_text.json")

#eth_text
ethVal <- read_json(path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/eth_text.json", simplifyVector = TRUE)
ethVal <- as_tibble(ethVal)
eth_file <- rbind(ethVal, eth_text)
eth_file <- eth_file %>% distinct
write_json(eth_text, path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/eth_text.json")

#cryn_text
ethVal <- read_json(path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/eth_text.json", simplifyVector = TRUE)
ethVal <- as_tibble(ethVal)
eth_file <- rbind(ethVal, eth_text)
eth_file<- eth_file %>% distinct
write_json(cryn_text, path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/eth_text.json")

#btcnew_text
btcnewVal <-read_json(path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/btcnew_text.json", simplifyVector = TRUE)
btcnewVal <- as_tibble(btcnewVal)
btcnew_file <- rbind(btcnewVal, btcnew_text)
btcnew_file<- btcnew_file %>% distinct
write_json(btcnew_text, path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/btcnew_text.json")

#btcmin_text
btcminVal <-read_json(path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/btcmin_text.json", simplifyVector = TRUE)
btcminVal <- as_tibble(btcminVal)
btcmin_file <- rbind(btcminVal, btcmin_text)
btcmin_file <- btcmin_file %>% distinct
write_json(btcmin_text, path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/btcmin_text.json")

#hodl_text
hodlVal <-read_json(path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/hodl_text.json", simplifyVector = TRUE)
hodlVal <- as_tibble(hodlVal)
hodl_file <- rbind(hodlVal, hodl_text)
hhodl_file <- hodl_file %>% distinct
write_json(hodl_text, path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/hodl_text.json")

#Sbit_text
SbitVal <-read_json(path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/Sbit_text.json", simplifyVector = TRUE)
SbitVal <- as_tibble(SbitVal)
Sbit_file <- rbind(SbitVal, Sbit_text)
Sbit_file <- Sbit_file %>% distinct
write_json(Sbit_text, path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/Sbit_text.json")

#Scc_text
SccVal <-read_json(path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/Scc_text.json", simplifyVector = TRUE)
SccVal <- as_tibble(SccVal)
Scc_file <- rbind(SccVal, Scc_text)
Scc_file <- Scc_file %>% distinct
write_json(Scc_text, path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/Scc_text.json")

#Scp_text
SbitVal <-read_json(path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/Sbit_text.json", simplifyVector = TRUE)
SbitVal <- as_tibble(SbitVal)
Sbit_file <- rbind(SbitVal, Sbit_text)
Sbit_file <- Sbit_file %>% distinct
write_json(Scp_text, path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/Sbit_text.json")

#Sblock_text
SblockVal <-read_json(path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/Sblock_text.json", simplifyVector = TRUE)
SblockVal <- as_tibble(SblockVal)
Sblock_file <- rbind(SblockVal, Sblock_text)
Sblock_file <- Sblock_file %>% distinct
write_json(Sblock_text, path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/Sblock_text.json")

#Sbtcmin_text
SbtcminVal <-read_json(path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/Sbtcmin_text.json", simplifyVector = TRUE)
SbtcminVal <- as_tibble(SbtcminVal)
Sbtcmin_file <- rbind(SbtcminVal, Sbtcmin_text)
Sbtcmin_file <- Sbtcmin_file %>% distinct
write_json(Sbtcmin_text, path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/Sbtcmin_text.json")

#SB_text
SBVal <-read_json(path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/SB_text.json", simplifyVector = TRUE)
SBVal <- as_tibble(SBVal)
SB_file <- rbind(SBVal, SB_text)
SB_file <- SB_file %>% distinct
write_json(SB_text, path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/SB_text.json")

#BB_text
BBVal <-read_json(path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/BB_text.json", simplifyVector = TRUE)
BBVal <- as_tibble(BBVal)
BB_file <- rbind(BBVal, BB_text)
BB_file <- BB_file %>% distinct
write_json(BB_text, path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/BB_text.json")

#hodl2_text
hodl2Val <-read_json(path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/hodl2_text.json", simplifyVector = TRUE)
hodl2Val <- as_tibble(hodl2Val)
hodl2_file <- rbind(hodl2Val, hodl2_text)
hodl12_file<- hodl2_file %>% distinct
write_json(hodl2_text, path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/hodl2_text.json")

#whale_text
whaleVal <-read_json(path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/whale_text.json", simplifyVector = TRUE)
whaleVal <- as_tibble(whaleVal)
whale_file <- rbind(whaleVal, whale_text)
whale_file <- whale_file %>% distinct
write_json(whale_text, path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/whale_text.json")

########################################################################################################################################################################
######################################################################## SENTIMENT ANALYSIs #############################################################################
########################################################################################################################################################################

#bitcoin_text
mysentiment_bit <- get_nrc_sentiment((bitcoin_text))
Sentimentscores_Bit <-data.frame(colSums(mysentiment_bit[,]))

names(Sentimentscores_Bit)<-"Score"
Sentimentscores_Bit<-cbind("sentiment"=rownames(Sentimentscores_Bit),Sentimentscores_Bit)
rownames(Sentimentscores_Bit)<-NULL

#fud_text
mysentiment_fud <- get_nrc_sentiment((fud_text))
Sentimentscores_Fud <-data.frame(colSums(mysentiment_fud[,]))

names(Sentimentscores_Fud)<-"Score"
Sentimentscores_Fud<-cbind("sentiment"=rownames(Sentimentscores_Fud),Sentimentscores_Fud)
rownames(Sentimentscores_Fud)<-NULL

#btc_text
mysentiment_btc <- get_nrc_sentiment((btc_text))
Sentimentscores_Btc <-data.frame(colSums(mysentiment_btc[,]))

names(Sentimentscores_Btc)<-"Score"
Sentimentscores_Btc<-cbind("sentiment"=rownames(Sentimentscores_Btc),Sentimentscores_Btc)
rownames(Sentimentscores_Btc)<-NULL

#cc_text
mysentiment_cc <- get_nrc_sentiment((cc_text))
Sentimentscores_CC <-data.frame(colSums(mysentiment_cc[,]))

names(Sentimentscores_CC)<-"Score"
Sentimentscores_CC<-cbind("sentiment"=rownames(Sentimentscores_CC),Sentimentscores_CC)
rownames(Sentimentscores_CC)<-NULL

#ccur_text
mysentiment_ccur <- get_nrc_sentiment((ccur_text))
Sentimentscores_Ccur <-data.frame(colSums(mysentiment_ccur[,]))

names(Sentimentscores_Ccur)<-"Score"
Sentimentscores_Ccur<-cbind("sentiment"=rownames(Sentimentscores_Ccur),Sentimentscores_Ccur)
rownames(Sentimentscores_Ccur)<-NULL

#block_text
mysentiment_block <- get_nrc_sentiment((block_text))
Sentimentscores_Block <-data.frame(colSums(mysentiment_block[,]))

names(Sentimentscores_Block)<-"Score"
Sentimentscores_Block<-cbind("sentiment"=rownames(Sentimentscores_Block),Sentimentscores_Block)
rownames(Sentimentscores_Block)<-NULL

#ether_text
mysentiment_ether <- get_nrc_sentiment((ether_text))
Sentimentscores_ether <-data.frame(colSums(mysentiment_ether[,]))

names(Sentimentscores_ether)<-"Score"
Sentimentscores_ether<-cbind("sentiment"=rownames(Sentimentscores_ether),Sentimentscores_ether)
rownames(Sentimentscores_ether)<-NULL

#eth_text
mysentiment_eth <- get_nrc_sentiment((eth_text))
Sentimentscores_eth <-data.frame(colSums(mysentiment_eth[,]))

names(Sentimentscores_eth)<-"Score"
Sentimentscores_eth<-cbind("sentiment"=rownames(Sentimentscores_eth),Sentimentscores_eth)
rownames(Sentimentscores_eth)<-NULL

#cryn_text
mysentiment_cryn <- get_nrc_sentiment((cryn_text))
Sentimentscores_cryn <-data.frame(colSums(mysentiment_cryn[,]))

names(Sentimentscores_cryn)<-"Score"
Sentimentscores_cryn<-cbind("sentiment"=rownames(Sentimentscores_cryn),Sentimentscores_cryn)
rownames(Sentimentscores_cryn)<-NULL

#btcnew_text
mysentiment_btcnew <- get_nrc_sentiment((btcnew_text))
Sentimentscores_btcnew <-data.frame(colSums(mysentiment_btcnew[,]))

names(Sentimentscores_btcnew)<-"Score"
Sentimentscores_btcnew<-cbind("sentiment"=rownames(Sentimentscores_btcnew),Sentimentscores_btcnew)
rownames(Sentimentscores_btcnew)<-NULL

#btcmin_text
mysentiment_btcmin <- get_nrc_sentiment((btcmin_text))
Sentimentscores_btcmin <-data.frame(colSums(mysentiment_btcmin[,]))

names(Sentimentscores_btcmin)<-"Score"
Sentimentscores_btcmin<-cbind("sentiment"=rownames(Sentimentscores_btcmin),Sentimentscores_btcmin)
rownames(Sentimentscores_btcmin)<-NULL

#hodl_text
mysentiment_hodl <- get_nrc_sentiment((hodl_text))
Sentimentscores_hodl <-data.frame(colSums(mysentiment_hodl[,]))

names(Sentimentscores_hodl)<-"Score"
Sentimentscores_hodl<-cbind("sentiment"=rownames(Sentimentscores_hodl),Sentimentscores_hodl)
rownames(Sentimentscores_hodl)<-NULL

#Sbit_text
mysentiment_sbit <- get_nrc_sentiment((Sbit_text))
Sentimentscores_sbit <-data.frame(colSums(mysentiment_sbit[,]))

names(Sentimentscores_sbit)<-"Score"
Sentimentscores_sbit<-cbind("sentiment"=rownames(Sentimentscores_sbit),Sentimentscores_sbit)
rownames(Sentimentscores_sbit)<-NULL

#Scc_text
mysentiment_scc <- get_nrc_sentiment((Scc_text))
Sentimentscores_scc <-data.frame(colSums(mysentiment_scc[,]))

names(Sentimentscores_scc)<-"Score"
Sentimentscores_scc<-cbind("sentiment"=rownames(Sentimentscores_scc),Sentimentscores_scc)
rownames(Sentimentscores_scc)<-NULL

#Scp_text
mysentiment_scp <- get_nrc_sentiment((Scp_text))
Sentimentscores_scp <-data.frame(colSums(mysentiment_scp[,]))

names(Sentimentscores_scp)<-"Score"
Sentimentscores_scp<-cbind("sentiment"=rownames(Sentimentscores_scp),Sentimentscores_scp)
rownames(Sentimentscores_scp)<-NULL

#Sblock_text
mysentiment_sblock <- get_nrc_sentiment((Sblock_text))
Sentimentscores_sblock <-data.frame(colSums(mysentiment_sblock[,]))

names(Sentimentscores_sblock)<-"Score"
Sentimentscores_sblock<-cbind("sentiment"=rownames(Sentimentscores_sblock),Sentimentscores_sblock)
rownames(Sentimentscores_sblock)<-NULL

#Sbtcmin_text
mysentiment_sbtcmin <- get_nrc_sentiment((Sbtcmin_text))
Sentimentscores_sbtcmin <-data.frame(colSums(mysentiment_sbtcmin[,]))

names(Sentimentscores_sbtcmin)<-"Score"
Sentimentscores_sbtcmin<-cbind("sentiment"=rownames(Sentimentscores_sbtcmin),Sentimentscores_sbtcmin)
rownames(Sentimentscores_sbtcmin)<-NULL

#SB_text
mysentiment_sb <- get_nrc_sentiment((SB_text))
Sentimentscores_sb <-data.frame(colSums(mysentiment_sb[,]))

names(Sentimentscores_sb)<-"Score"
Sentimentscores_sb<-cbind("sentiment"=rownames(Sentimentscores_sb),Sentimentscores_sb)
rownames(Sentimentscores_sb)<-NULL

#BB_text
mysentiment_bb <- get_nrc_sentiment((BB_text))
Sentimentscores_bb <-data.frame(colSums(mysentiment_bb[,]))

names(Sentimentscores_bb)<-"Score"
Sentimentscores_bb<-cbind("sentiment"=rownames(Sentimentscores_bb),Sentimentscores_bb)
rownames(Sentimentscores_bb)<-NULL

#hodl2_text
mysentiment_hodl2     <- get_nrc_sentiment((hodl2_text))
Sentimentscores_hodl2 <- data.frame(colSums(mysentiment_hodl2[,]))

names(Sentimentscores_hodl2) <- "Score"
Sentimentscores_hodl2        <- cbind("sentiment"=rownames(Sentimentscores_hodl2),Sentimentscores_hodl2)
rownames(Sentimentscores_hodl2)<-NULL

#whale_text
mysentiment_whale     <- get_nrc_sentiment((whale_text))
Sentimentscores_whale <-data.frame(colSums(mysentiment_whale[,]))

names(Sentimentscores_whale) <- "Score"
Sentimentscores_whale        <- cbind("sentiment"=rownames(Sentimentscores_whale),Sentimentscores_whale)
rownames(Sentimentscores_whale)<-NULL

#moon_text
mysentiment_moon <- get_nrc_sentiment((moon_text))
Sentimentscores_moon <-data.frame(colSums(mysentiment_moon[,]))

names(Sentimentscores_moon) <- "Score"
Sentimentscores_moon        <- cbind("sentiment"=rownames(Sentimentscores_moon),Sentimentscores_moon)
rownames(Sentimentscores_moon)<-NULL


########################################################################################################################################################################
######################################################################## COMBINING DATA #############################################################################
########################################################################################################################################################################
SentBit     <- as_tibble(Sentimentscores_Bit %>% spread('sentiment','Score'))
SentFud     <- as_tibble(Sentimentscores_Fud %>% spread('sentiment','Score'))
SentBtc     <- as_tibble(Sentimentscores_Btc %>% spread('sentiment','Score'))
SentCC      <- as_tibble(Sentimentscores_CC %>% spread('sentiment','Score')) 
SentCcur    <- as_tibble(Sentimentscores_Ccur %>% spread('sentiment','Score'))
SentBlock   <- as_tibble(Sentimentscores_Block %>% spread('sentiment','Score'))
SentEther   <- as_tibble(Sentimentscores_ether%>% spread('sentiment','Score'))
SentETH     <- as_tibble(Sentimentscores_eth %>% spread('sentiment','Score'))
SentCryn    <- as_tibble(Sentimentscores_cryn %>% spread('sentiment','Score'))
SentBtcnew  <- as_tibble(Sentimentscores_btcnew %>% spread('sentiment','Score'))
SentBtcmin  <- as_tibble(Sentimentscores_btcmin %>% spread('sentiment','Score'))
SentHodl    <- as_tibble(Sentimentscores_hodl %>% spread('sentiment','Score'))
SentSbit    <- as_tibble(Sentimentscores_sbit %>% spread('sentiment','Score'))
SentScc     <- as_tibble(Sentimentscores_scc %>% spread('sentiment','Score'))
SentScp     <- as_tibble(Sentimentscores_scp %>% spread('sentiment','Score'))
SentSBlock  <- as_tibble(Sentimentscores_sblock %>% spread('sentiment','Score'))
SentSbtcmin <- as_tibble(Sentimentscores_sbtcmin %>% spread('sentiment','Score'))
SentSB      <- as_tibble(Sentimentscores_sb %>% spread('sentiment','Score'))
SentBB      <- as_tibble(Sentimentscores_bb %>% spread('sentiment','Score'))
SentHodl2   <- as_tibble(Sentimentscores_hodl2 %>% spread('sentiment','Score'))
SentWhale   <- as_tibble(Sentimentscores_whale %>% spread('sentiment','Score'))
SentMoon    <- as_tibble(Sentimentscores_moon %>% spread('sentiment','Score'))


SentBit     <- as.matrix(SentBit)
SentFud     <- as.matrix(SentBlock)
SentBtc     <- as.matrix(SentBtc)
SentCC      <- as.matrix(SentCC)
SentCcur    <- as.matrix(SentCcur)
SentBlock   <- as.matrix(SentBlock)
SentEther   <- as.matrix(SentEther)
SentETH     <- as.matrix(SentETH)
SentCryn    <- as.matrix(SentCryn)
SentBtcnew  <- as.matrix(SentBtcnew)
SentBtcmin  <- as.matrix(SentBtcmin)
SentHodl    <- as.matrix(SentHodl)
SentSbit    <- as.matrix(SentSbit)
SentScc     <- as.matrix(SentScc)
SentScp     <- as.matrix(SentScp)
SentSBlock  <- as.matrix(SentSBlock)
SentSbtcmin <- as.matrix(SentSbtcmin)
SentSB      <- as.matrix(SentSB)
SentBB      <- as.matrix(SentBB)
SentHodl2   <- as.matrix(SentHodl2)
SentWhale   <- as.matrix(SentWhale)
SentMoon    <- as.matrix(SentMoon)



Monster_Sentiment <- SentBit + SentFud + SentBtc + SentCC + SentCcur + SentBlock + SentEther + SentETH + SentCryn + SentBtcnew + SentBtcmin + SentHodl + SentSbit +
                     SentScc + SentScp + SentSBlock + SentSbtcmin + SentSB + SentBB + SentHodl2 + SentWhale + SentMoon

MonsterData <- as_tibble(rbind(Monster_Sentiment))

BTC_Price <- crypto_prices('bitcoin')
BTC_USD   <- as_tibble(cbind(BTC_Price$percent_change_1h))
BTC_USD   <- as_tibble(cbind(BTC_Price$price_usd, BTC_USD))
BTC_USD   <- as_tibble(cbind(BTC_Price$last_updated, BTC_USD))

BTC_USD$Inc_Dec <- ifelse(BTC_USD$V1 > 0.0, "Increase","Decrease")
MonsterData     <- cbind(MonsterData, BTC_USD)

colnames(MonsterData)[colnames(MonsterData)== "BTC_Price$last_updated"] <- "Time_of_Price_Update"
colnames(MonsterData)[colnames(MonsterData)=="BTC_Price$price_usd"] <- "Price_in_USD"
colnames(MonsterData)[colnames(MonsterData)=="V1"] <- "Percent_Change"


MonsterVal   <-read_json(path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/Monster_Data.json", simplifyVector = TRUE)
MonsterVal   <- as_tibble(MonsterVal)
Monster_file <- rbind(MonsterVal, MonsterData)

write_json(MonsterData, path = "/Users/gordonjohnson/Desktop/DataScience/crypto-predictive-analysis/data/twitter/Monster_Data.json")





