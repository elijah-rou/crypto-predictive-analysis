#LET'S BEGIN SENTIMENT ANALYSIS!!!


library(tidyverse)
library(lubridate)
library(readr)

#for sentiment anlysis
library(dplyr)
library(magrittr)
library(rtweet)
library(remotes)
#install_github("juliasilge/tidytext")  #install tidy text from github (not on CRAN yet)


#for visualization
library(ggplot2) 
library(ggridges)


#Load in the Data 
CryptoCurrency_12_months <- read_csv("data/reddit/CryptoCurrency_12_months.csv")
CryptoCurrency_12_months %>% glimpse()
View(CryptoCurrency_12_months)

table(CryptoCurrency_12_months$timestamp)
#**NOTE: We already grouped the data by DAY in Python (before we uploaded to a CSV and opened it in R)


#Let's create a second data frame that showsa the timestamp (day) and the amount of datapoints on that day
  #(This dats frame could be useful when we conduct sentiment anlysis)
CryptoCurrency_12_months %>% tally()
CryptoCurrency_12_months %>% group_by(timestamp) %>% tally()

new_crypto_frame = data.frame(CryptoCurrency_12_months %>% group_by(timestamp) %>% tally())
new_crypto_frame
#***new_crypto_frame is a df that shows which days people posted the most on r/CryptoCurrency




#GGPLOT visualization package to plot titles created in the CryptoCurrency subrredit overtime 

#Visualization #1: Number of posts per day overtime (a)
ggplot(data = CryptoCurrency_12_months) + 
  geom_bar(mapping = aes(x = timestamp,))


#Visualization #2: Number of posts per day overtime (b)
ggplot(CryptoCurrency_12_months, aes(timestamp)) + geom_histogram(aes(binwidth=0.01), stat = "bin") 


#Visualization #3: Number of posts per day overtime (c)
ggplot(new_crypto_frame, aes(x=timestamp, y=n))+
  geom_line()
#Note: n = "number of posts made r/CryptoCurrency"



#Let's create a third dataframe that is solely timestamp (day) and title 
Crypto_title_frame <- CryptoCurrency_12_months %>% 
  select(timestamp, title)

#saving the csv 
write_as_csv(Crypto_title_frame, "Crypto_title_frame.csv")
Crypto_title_frame <- read_csv("Crypto_title_frame.csv")
view(Crypto_title_frame)



#SENTIMENT ANLYSIS:
#install.packages("plotly")
#install.packages("textdata")
library(textdata)
library(tidytext)
library(tidyr)
library(syuzhet)
library(NLP)
library(tm)
library(SnowballC)
library(stringi)
library(topicmodels)
library(syuzhet)
library(ROAuth)
library(plotly)

# Function to remove all non-alphabetic charaters from a string, replacing them with a space - E
replaceAlpha <- function(string) { 
  str_replace_all(string, "[^[:alpha:]]", " ") 
}
# Generate a vector of posts
postVector <- 
  map(Crypto_title_frame$title, replaceAlpha) %>%
  unlist
# Grabs all titles from df$title, removes all non-alphabetic characters, and returns a vector of sentiment scores - E
sentimentScores <- get_sentiment(postVector)

# Extract timestamp
# NOT NEEDED
#timestamp <- Crypto_title_frame$timestamp

#get sentiment for lexicon of choice (in this case, nrc)
# NB - This won't R runs out of memory so converting back to datafram not feasible
sentiment_data <- data.frame(timestamp, sentimentScores)

# get the emotions using the NRC dictionary
emotions <- get_nrc_sentiment(postVector)
emo_bar = colSums(emotions)
emo_sum = data.frame(count=emo_bar, emotion=names(emo_bar))
emo_sum$emotion = factor(emo_sum$emotion, levels=emo_sum$emotion[order(emo_sum$count, decreasing = TRUE)])

view(Crypto_title_frame)



plot_ly(sentiment_data, x=~timestamp, y=~nrc_sent, type="scatter", mode="jitter", name="nrc") %>% 
  layout(title="Sentiments of titles in CryptoCurrency subreddit in the last 12 months",
       yaxis=list(title="score"), xaxis=list(title="date"))



#Make a data frame with just title (no timestamp)
title_df <- Crypto_title_frame 
title_df$timestamp <- NULL
view(title_df)

#Clean data 
converted <- tolower(title_df)
converted<- gsub("[[:punct:]]", "", converted)
converted <-gsub("http\\w+", "", converted)
converted <- gsub("^ ", "", converted)
converted <- gsub(" $", "", converted)

library("tm")

class(converted)

#getitng emtotions using in-built function
mysentiment_converted <- get_nrc_sentiment(Crypto_df_unnested$title)

#calculating total score for each sentiment 
Sentimentscores_converted<-data.frame(colSums(mysentiment_converted[,]))
names(Sentimentscores_converted)<-"Score"
Sentimentscores_converted<-cbind("sentiment"=rownames(Sentimentscores_converted),Sentimentscores_converted)
rownames(Sentimentscores_converted)<-NULL

#plotting sentiments with scores 
ggplot(data=Sentimentscores_converted,aes(x=sentiment,y=Score))+geom_bar(aes(fill=sentiment),stat = "identity")+
  theme(legend.position="none")+
  xlab("Sentiments")+ylab("scores")+ggtitle("Sentiments of titles on the CryptoCurrency Subreddit")






write_as_csv(CryptoCurrency_12_months, "Crypto_df_unnested.csv", na="", fileEncoding = "UTF-8")
Crypto_df_unnested <- read_csv("Crypto_df_unnested.csv")
view(Crypto_df_unnested)










title_df$title <- as.character(title_df$title)
class(title_df$title)

cryptocurrency_sentiment <- get_nrc_sentiment((title_df))













lexicon <- get
AFINN <- lexicon %>% 
  select(word, afinn_score = value)





#Tokenize titles and merge with words ranked by sentiment 

Crypto_sentiment <- Crypto_title_frame %>% 
  select(title, timestamp) %>%
  unnest_tokens_("word", "title") %>%
  anti_join(stop_words) %>%
  inner_join(AFINN, by = "word") %>%
  group_by(word) %>%
  summarize(sentiment = mean(afinn_score))

Crypto_sentiment

write.csv((Crypto_sentiment),"Crypto_sentiment.csv")












#PRE-PROCESSING

#Convert all text to lower close 
title_df <- tolower(title_df)

#Remove punctuation 
title_df <- gsub("[[:punct:]]", "", title_df)

#Remove Links
title_df <- gsub("http\\w+", "", title_df)

#Remove tabs
title_df <- gsub("[ |\t]{2,}", "", title_df)

#Remove blank spaces at the beginning
title_df <- gsub("^ ", "",title_df)

#Remove blank spaces at the end
title_df <- gsub(" $", "",title_df)

