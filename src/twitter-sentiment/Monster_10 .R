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
library(jsonlite)

consumer_key2    <-"BfIYQbVQAuGAVpOKa0ldIrYgw"
consumer_secret2 <-"WARBBW6SuT5AkUi4oqIFKmbq2yzAXRBaEgBUtjZVVefjY1KjZC"
access_token2    <-"1148924254966226945-oGPaCVuMZxHTW46hEI3bjNGLI4UTA4"
access_secret2   <-"34WP9hbA2xs8VGkGMigR0Ubk8Q0lGFLiB0jCnUBZbye0R"

setup_twitter_oauth(consumer_key2, consumer_secret2, access_token2, access_secret2)

####################################################### #Bitcoin #######################################################
tweets_bc = searchTwitter('#bitcoin -filter:retweets',lang = "en", n = 1000, resultType = 'recent', retryOnRateLimit = 1)

### Data Processing
bitcoin_tweets <- twListToDF(tweets_bc)
bitcoin_text   <- bitcoin_tweets$text
bitcoin_text   <- tolower(bitcoin_text)
bitcoin_text   <- gsub("rt", "", bitcoin_text)
bitcoin_text   <- gsub("@\\w+", "", bitcoin_text)
bitcoin_text   <- gsub("[[:punct:]]", "", bitcoin_text)
bitcoin_text   <- gsub("http\\w+", "",bitcoin_text)
bitcoin_text   <- gsub("[ |\t]{2,}", "", bitcoin_text)
bitcoin_text   <- gsub("^ ", "", bitcoin_text)
bitcoin_text   <- gsub(" $", "", bitcoin_text)

mysentiment_eth <- get_nrc_sentiment((eth_text))
Sentimentscoreseth <-data.frame(colSums(mysentiment_eth[,]))

names(Sentimentscoreseth)<-"Score"
Sentimentscoreseth<-cbind("sentiment"=rownames(Sentimentscoreseth),Sentimentscoreseth)
rownames(Sentimentscoreseth)<-NULL
####################################################### #BTC ##########################################################
tweets_btc = searchTwitter('#btc -filter:retweets',lang = "en", n=1000, resultType = 'recent', retryOnRateLimit = 1)

### Data Processing
btc_tweets <- twListToDF(tweets_btc)
btc_text   <- btc_tweets$text
btc_text   <- tolower(btc_text)
btc_text   <- gsub("rt", "", btc_text)
btc_text   <- gsub("@\\w+", "", btc_text)
btc_text   <- gsub("[[:punct:]]", "", btc_text)
btc_text   <- gsub("http\\w+", "",btc_text)
btc_text   <- gsub("[ |\t]{2,}", "", btc_text)
btc_text   <- gsub("^ ", "", btc_text)
btc_text   <- gsub(" $", "", btc_text)

####################################################### #crypto ##########################################################
tweets_cc = twitteR::searchTwitter('#crypto -filter:retweets',lang = "en", n = 1000, resultType = 'recent', retryOnRateLimit = 1)

cc_tweets <- twListToDF(tweets_cc)
cc_text<- cc_tweets$text
cc_text <- tolower(cc_text)
cc_text <- gsub("rt", "", cc_text)
cc_text <- gsub("@\\w+", "", cc_text)
cc_text <- gsub("[[:punct:]]", "", cc_text)
cc_text <- gsub("http\\w+", "",cc_text)
cc_text <- gsub("[ |\t]{2,}", "", cc_text)
cc_text <- gsub("^ ", "", cc_text)
cc_text <- gsub(" $", "", cc_text)

####################################################### #cryptocurrency ####################################################
tweets_ccur = twitteR::searchTwitter('#cryptocurrency -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

ccur_tweets <- twListToDF(tweets_ccur)
ccur_text<- ccur_tweets$text
ccur_text <- tolower(ccur_text)
ccur_text <- gsub("rt", "", ccur_text)
ccur_text <- gsub("@\\w+", "", ccur_text)
ccur_text <- gsub("[[:punct:]]", "", ccur_text)
ccur_text <- gsub("http\\w+", "",ccur_text)
ccur_text <- gsub("[ |\t]{2,}", "", ccur_text)
ccur_text <- gsub("^ ", "", ccur_text)
ccur_text <- gsub(" $", "", ccur_text)


####################################################### #blockchain ####################################################
tweets_block = twitteR::searchTwitter('#blockchain -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

block_tweets <- twListToDF(tweets_block)
block_text   <- block_tweets$text
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
tweets_ether = twitteR::searchTwitter('#ethereum -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

ether_tweets <- twListToDF(tweets_ether)
ether_text   <- ether_tweets$text
ether_text   <- tolower(ether_text)
ether_text   <- gsub("rt", "", ether_text)
ether_text   <- gsub("@\\w+", "", ether_text)
ether_text   <- gsub("[[:punct:]]", "", ether_text)
ether_text   <- gsub("http\\w+", "",ether_text)
ether_text   <- gsub("[ |\t]{2,}", "", ether_text)
ether_text   <- gsub("^ ", "", ether_text)
ether_text   <- gsub(" $", "", ether_text)

####################################################### #eth ####################################################
tweets_eth = twitteR::searchTwitter('#eth -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

eth_tweets <- twListToDF(tweets_eth)
eth_text   <- eth_tweets$text
eth_text   <- tolower(eth_text)
eth_text   <- gsub("rt", "", eth_text)
eth_text   <- gsub("@\\w+", "", eth_text)
eth_text   <- gsub("[[:punct:]]", "", eth_text)
eth_text   <- gsub("http\\w+", "",eth_text)
eth_text   <- gsub("[ |\t]{2,}", "", eth_text)
eth_text   <- gsub("^ ", "", eth_text)
eth_text   <- gsub(" $", "", eth_text)

####################################################### #cryptonews ####################################################
tweets_cryn = twitteR::searchTwitter('#cryptonews -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

cryn_tweets <- twListToDF(tweets_cryn)
cryn_text   <- cryn_tweets$text
cryn_text   <- tolower(cryn_text)
cryn_text   <- gsub("rt", "", cryn_text)
cryn_text   <- gsub("@\\w+", "", cryn_text)
cryn_text   <- gsub("[[:punct:]]", "", cryn_text)
cryn_text   <- gsub("http\\w+", "",cryn_text)
cryn_text   <- gsub("[ |\t]{2,}", "", cryn_text)
cryn_text   <- gsub("^ ", "", cryn_text)
cryn_text   <- gsub(" $", "", cryn_text)

####################################################### #bitcoinnews ####################################################
tweets_btcnew = twitteR::searchTwitter('#bitcoinnews -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

btcnew_tweets <- twListToDF(tweets_btcnew)
btcnew_text   <- btcnew_tweets$text
btcnew_text   <- tolower(btcnew_text)
btcnew_text   <- gsub("rt", "", btcnew_text)
btcnew_text   <- gsub("@\\w+", "", btcnew_text)
btcnew_text   <- gsub("[[:punct:]]", "", btcnew_text)
btcnew_text   <- gsub("http\\w+", "",btcnew_text)
btcnew_text   <- gsub("[ |\t]{2,}", "", btcnew_text)
btcnew_text   <- gsub("^ ", "", btcnew_text)
btcnew_text   <- gsub(" $", "", btcnew_text)

####################################################### #bitcoinmining ##################################################
tweets_btcmin = twitteR::searchTwitter('#bitcoinmining -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

btcmin_tweets <- twListToDF(tweets_btcmin)
btcmin_text   <- btcmin_tweets$text
btcmin_text   <- tolower(btcmin_text)
btcmin_text   <- gsub("rt", "", btcmin_text)
btcmin_text   <- gsub("@\\w+", "", btcmin_text)
btcmin_text   <- gsub("[[:punct:]]", "", btcmin_text)
btcmin_text   <- gsub("http\\w+", "",btcmin_text)
btcmin_text   <- gsub("[ |\t]{2,}", "", btcmin_text)
btcmin_text   <- gsub("^ ", "", btcmin_text)
btcmin_text   <- gsub(" $", "", btcmin_text)


####################################################### #hodl ###########################################################
tweets_hodl = twitteR::searchTwitter('#hodl -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

hodl_tweets <- twListToDF(tweets_hodl)
hodl_text   <- hodl_tweets$text
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
tweets_Sbit = twitteR::searchTwitter('bitcoin -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

Sbit_tweets <- twListToDF(tweets_Sbit)
Sbit_text   <- Sbit_tweets$text
Sbit_text   <- tolower(Sbit_text)
Sbit_text   <- gsub("rt", "", Sbit_text)
Sbit_text   <- gsub("@\\w+", "", Sbit_text)
Sbit_text   <- gsub("[[:punct:]]", "", Sbit_text)
Sbit_text   <- gsub("http\\w+", "",Sbit_text)
Sbit_text   <- gsub("[ |\t]{2,}", "", Sbit_text)
Sbit_text   <- gsub("^ ", "", Sbit_text)
Sbit_text   <- gsub(" $", "", Sbit_text)

########################################################### Search Cryptocurrency ##############################################
tweets_Scc = twitteR::searchTwitter('cryptocurrency -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

Scc_tweets <- twListToDF(tweets_Scc)
Scc_text   <- Scc_tweets$text
Scc_text   <- tolower(Scc_text)
Scc_text   <- gsub("rt", "", Scc_text)
Scc_text   <- gsub("@\\w+", "", Scc_text)
Scc_text   <- gsub("[[:punct:]]", "", Scc_text)
Scc_text   <- gsub("http\\w+", "",Scc_text)
Scc_text   <- gsub("[ |\t]{2,}", "", Scc_text)
Scc_text   <- gsub("^ ", "", Scc_text)
Scc_text   <- gsub(" $", "", Scc_text)

########################################################### Search Crypto ####################################################
tweets_Scp = twitteR::searchTwitter('crypto -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

Scp_tweets <- twListToDF(tweets_Scp)
Scp_text   <- Scp_tweets$text
Scp_text   <- tolower(Scp_text)
Scp_text   <- gsub("rt", "", Scp_text)
Scp_text   <- gsub("@\\w+", "", Scp_text)
Scp_text   <- gsub("[[:punct:]]", "", Scp_text)
Scp_text   <- gsub("http\\w+", "",Scp_text)
Scp_text   <- gsub("[ |\t]{2,}", "", Scp_text)
Scp_text   <- gsub("^ ", "", Scp_text)
Scp_text   <- gsub(" $", "", Scp_text)

########################################################### Search Blockchain ####################################################
tweets_Sblock = twitteR::searchTwitter('blockchain -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

Sblock_tweets <- twListToDF(tweets_Sblock)
Sblock_text   <- Sblock_tweets$text
Sblock_text   <- tolower(block_text)
Sblock_text   <- gsub("rt", "", Sblock_text)
Sblock_text   <- gsub("@\\w+", "", Sblock_text)
Sblock_text   <- gsub("[[:punct:]]", "", Sblock_text)
Sblock_text   <- gsub("http\\w+", "",Sblock_text)
Sblock_text   <- gsub("[ |\t]{2,}", "", Sblock_text)
Sblock_text   <- gsub("^ ", "", Sblock_text)
Sblock_text   <- gsub(" $", "", Sblock_text)

########################################################### Search bitcon mining ###################################################
tweets_Sbtcmin = twitteR::searchTwitter('bitcoin mining -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)


Sbtcmin_tweets <- twListToDF(tweets_Sbtcmin)
Sbtcmin_text   <- Sbtcmin_tweets$text
Sbtcmin_text   <- tolower(Sbtcmin_text)
Sbtcmin_text   <- gsub("rt", "", Sbtcmin_text)
Sbtcmin_text   <- gsub("@\\w+", "", Sbtcmin_text)
Sbtcmin_text   <- gsub("[[:punct:]]", "", Sbtcmin_text)
Sbtcmin_text   <- gsub("http\\w+", "",Sbtcmin_text)
Sbtcmin_text   <- gsub("[ |\t]{2,}", "", Sbtcmin_text)
Sbtcmin_text   <- gsub("^ ", "", Sbtcmin_text)
Sbtcmin_text   <- gsub(" $", "", Sbtcmin_text)


########################################################### Search sell bitcoin ###################################################
tweets_SB = twitteR::searchTwitter('sell bitcoin -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

SB_tweets <- twListToDF(tweets_SB)
SB_text   <- SB_tweets$text
SB_text   <- tolower(SB_text)
SB_text   <- gsub("rt", "", SB_text)
SB_text   <- gsub("@\\w+", "", SB_text)
SB_text   <- gsub("[[:punct:]]", "", SB_text)
SB_text   <- gsub("http\\w+", "",SB_text)
SB_text   <- gsub("[ |\t]{2,}", "", SB_text)
SB_text   <- gsub("^ ", "", SB_text)
SB_text   <- gsub(" $", "", SB_text)


############################################################## Search buy bitcoin ###################################################
tweets_BB = twitteR::searchTwitter('buy+bitcoin -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

BB_tweets <- twListToDF(tweets_BB)
BB_text   <- BB_tweets$text
BB_text   <- tolower(BB_text)
BB_text   <- gsub("rt", "", BB_text)
BB_text   <- gsub("@\\w+", "", BB_text)
BB_text   <- gsub("[[:punct:]]", "", BB_text)
BB_text   <- gsub("http\\w+", "",BB_text)
BB_text   <- gsub("[ |\t]{2,}", "", BB_text)
BB_text   <- gsub("^ ", "", BB_text)
BB_text   <- gsub(" $", "", BB_text)

############################################################## Search HODL ###################################################
tweets_hodl2 = twitteR::searchTwitter('bitcoin HODL -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

hodl2_tweets <- twListToDF(tweets_hodl2)
hodl2_text   <- hodl2_tweets$text
hodl2_text   <- tolower(hodl2_text)
hodl2_text   <- gsub("rt", "", hodl2_text)
hodl2_text   <- gsub("@\\w+", "", hodl2_text)
hodl2_text   <- gsub("[[:punct:]]", "", hodl2_text)
hodl2_text   <- gsub("http\\w+", "",hodl2_text)
hodl2_text   <- gsub("[ |\t]{2,}", "", hodl2_text)
hodl2_text   <- gsub("^ ", "", hodl2_text)
hodl2_text   <- gsub(" $", "", hodl2_text)

############################################################## Search FUD ###################################################
tweets_fud = twitteR::searchTwitter('bitcoin FUD -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

fud_tweets <- twListToDF(tweets_fud)
fud_text   <- fud_tweets$text
fud_text   <- tolower(fud_text)
fud_text   <- gsub("rt", "", fud_text)
fud_text   <- gsub("@\\w+", "", fud_text)
fud_text   <- gsub("[[:punct:]]", "", fud_text)
fud_text   <- gsub("http\\w+", "",fud_text)
fud_text   <- gsub("[ |\t]{2,}", "", fud_text)
fud_text   <- gsub("^ ", "", fud_text)
fud_text   <- gsub(" $", "", fud_text)

############################################################## Search Whale ###################################################
tweets_whale = twitteR::searchTwitter('whale bitcoin -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

whale_tweets <- twListToDF(tweets_whale)
whale_text   <- whale_tweets$text
whale_text   <- tolower(whale_text)
whale_text   <- gsub("rt", "", whale_text)
whale_text   <- gsub("@\\w+", "", whale_text)
whale_text   <- gsub("[[:punct:]]", "", whale_text)
whale_text   <- gsub("http\\w+", "",whale_text)
whale_text   <- gsub("[ |\t]{2,}", "", whale_text)
whale_text   <- gsub("^ ", "", whale_text)
whale_text   <- gsub(" $", "", whale_text)

############################################################## Search Mooning ###################################################
tweets_moon = twitteR::searchTwitter('bitcoin mooning -filter:retweets',lang = "en", n = 1000, resultType = 'recent',retryOnRateLimit = 1)

moon_tweets <- twListToDF(tweets_moon)
moon_text   <- moon_tweets$text
moon_text   <- tolower(moon_text)
moon_text   <- gsub("rt", "", moon_text)
moon_text   <- gsub("@\\w+", "", moon_text)
moon_text   <- gsub("[[:punct:]]", "", moon_text)
moon_text   <- gsub("http\\w+", "",moon_text)
moon_text   <- gsub("[ |\t]{2,}", "", moon_text)
moon_text   <- gsub("^ ", "", moon_text)
moon_text   <- gsub(" $", "", moon_text)

############################################################## Combine Data ###################################################

###### writing Jsons for raw twitter data ###################
#moon_text
oldVal <- read_json(path = "/Users/gordonjohnson/Desktop/moon_text.json", simplifyVector = TRUE) 
oldVal <- as_tibble(oldVal)
new_file <- rbind(oldVal, moon_text)
new_file %>% distinct
write_json(new_file, path = "/Users/gordonjohnson/Desktop/moon_text.json") 

#bitcoin_text
bitVal <- read_json(path = "/Users/gordonjohnson/Desktop/bitcoin_text.json", simplifyVector = TRUE)
bitVal <- as_tibble(bitVal)
bit_file <- rbind(bitVal, bitcoin_text)
bit_file %>% distinct
write_json(new_file, path = "/Users/gordonjohnson/Desktop/bitcoin_text.json") 

#fud_text
fudVal <- read_json(path = "/Users/gordonjohnson/Desktop/fud_text.json", simplifyVector = TRUE)
fudVal <- as_tibble(fudVal)
fud_file <- rbind(bitVal, fud_text)
fud_file %>% distinct
write_json(new_file, path = "/Users/gordonjohnson/Desktop/fud_text.json")

#btc_text
btcVal <- read_json(path = "/Users/gordonjohnson/Desktop/btc_text.json", simplifyVector = TRUE)
btcVal <- as_tibble(btcVal)
btc_file <- rbind(btcVal, btc_text)
btc_file %>% distinct
write_json(new_file, path = "/Users/gordonjohnson/Desktop/btc_text.json")

#cc_text
CCVal <- read_json(path = "/Users/gordonjohnson/Desktop/cc_text.json", simplifyVector = TRUE)
CCVal <- as_tibble(ccVal)
cc_file <- rbind(CCVal, cc_text)
cc_file %>% distinct
write_json(new_file, path = "/Users/gordonjohnson/Desktop/cc_text.json")

#ccur_text 
ccurVal <- read_json(path = "/Users/gordonjohnson/Desktop/ccur_text.json", simplifyVector = TRUE)
ccurVal <- as_tibble(ccurVal)
ccur_file <- rbind(ccurVal, ccur_text)
ccur_file %>% distinct
write_json(new_file, path = "/Users/gordonjohnson/Desktop/ccur_text.json")

#block_text
blockVal <- read_json(path = "/Users/gordonjohnson/Desktop/block_text.json", simplifyVector = TRUE)
ccurVal <- as_tibble(ccurVal)
ccur_file <- rbind(ccurVal, ccur_text)
ccur_file %>% distinct
write_json(new_file, path = "/Users/gordonjohnson/Desktop/ccur_text.json")


as.matrix(bitcoin_text)
as.matrix(fud_text)
as.matrix(btc_text)
as.matrix(cc_text)
as.matrix(ccur_text)
as.matrix(block_text)
as.matrix(ether_text)
as.matrix(eth_text)
as.matrix(cryn_text)
as.matrix(btcnew_text)
as.matrix(btcmin_text)
as.matrix(hodl_text)
as.matrix(Sbit_text)
as.matrix(Scc_text)
as.matrix(Scp_text)
as.matrix(Sblock_text)
as.matrix(Sbtcmin_text)
as.matrix(SB_text)
as.matrix(BB_text)
as.matrix(hodl2_text)
as.matrix(whale_text)
as.matrix(moon_text)

































