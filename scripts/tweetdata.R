### tweetdata.r
### Fetch Twitter data and Data Transformations 
### Requires you have authenticated in auth.R
### 15th June 2014
### Mark Edmondson @HoloMarkeD
###

### For use with Twitter API, processTweets() takes the df$tweetDF data.frame as input
### And calculates/transforms data for the plots
processTweets <- function(tweetDF, 
                          timeToTweet=1, 
                          timeToReply=2, 
                          timeToRetweet=0.5){

  require(lubridate)
  require(reshape2)
  require(stringr)
  
  tweetDF$URL  <- str_extract(tweetDF$text, "https?\\://[\\.\\/a-zA-Z0-9]+")
  tweetDF$URL_B <- str_detect(tweetDF$text, "https?\\://[\\.\\/a-zA-Z0-9]+")
  tweetDF$week <- gsub(" ","0",sprintf("%2d", week(tweetDF$created)))
  tweetDF$hour <- hour(tweetDF$created)
  tweetDF$day <-  day(tweetDF$created)
  tweetDF$month <- gsub(" ","0",sprintf("%2d", month(tweetDF$created)))
  tweetDF$year <- year(tweetDF$created)
  tweetDF$ymd <- paste(tweetDF$year,tweetDF$month,tweetDF$day,sep="-")
  tweetDF$ym  <- paste(tweetDF$year,tweetDF$month,sep="-")
  tweetDF$yw  <- paste(tweetDF$year, tweetDF$week, sep="_")
  
  tweetDF$daypart <- ifelse(tweetDF$hour < 6,"early",tweetDF$hour)
  tweetDF$daypart <- ifelse(tweetDF$hour < 12 & tweetDF$hour >= 6,"morning",tweetDF$daypart)
  tweetDF$daypart <- ifelse(tweetDF$hour < 18 & tweetDF$hour >= 12,"afternoon",tweetDF$daypart)
  tweetDF$daypart <- ifelse(tweetDF$hour < 24 & tweetDF$hour >= 18,"evening",tweetDF$daypart)
  
  tweetDF$daypart <- factor(tweetDF$daypart, levels=c("early","morning","afternoon","evening"), ordered=TRUE)
  tweetDF$hour <- as.factor(hour(tweetDF$created))
  tweetDF$timespent <- ifelse(is.na(tweetDF$replyToSN), timeToTweet, timeToReply)
  tweetDF$timespent <- ifelse(tweetDF$retweeted, timeToRetweet, tweetDF$timespent)
  
  m <- melt(tweetDF[,c("yw","daypart","timespent")])
  tweetTimeDate <- dcast(m, yw + daypart ~ variable, sum)
  #   tweetTimeDate$ymd <- as.Date(tweetTimeDate$ymd, format="%Y-%m-%d")
  tweetTimeDate <- tweetTimeDate[order(tweetTimeDate$yw),]

  mMonth <- melt(tweetDF[,c("ym","daypart","timespent")])
  tweetTimeDateMonth <- dcast(mMonth, ym + daypart ~ variable, sum)
  tweetTimeDateMonth <- tweetTimeDateMonth[order(tweetTimeDateMonth$ym),]

  m2 <- melt(tweetDF[,c("yw","hour","timespent")])
  tweetTimeDate2 <- dcast(m2, yw + hour ~ variable, sum)
  tweetTimeDate2 <- tweetTimeDate2[order(tweetTimeDate2$yw),]

  m3 <- melt(tweetDF[,c("yw","URL_B","timespent")])
  tweetTimeDate3 <- dcast(m3, yw + URL_B ~ variable, sum)
  tweetTimeDate3 <- tweetTimeDate3[order(tweetTimeDate3$yw),]

  m3Month <- melt(tweetDF[,c("ym","URL_B","timespent")])
  tweetTimeDate3Month <- dcast(m3Month, ym + URL_B ~ variable, sum)
  tweetTimeDate3Month <- tweetTimeDate3Month[order(tweetTimeDate3Month$ym),]

  ### output is a list of dataframes for use in plots
  return(list(df1=tweetDF,
              tweetTD=tweetTimeDate,
              tweetTDm=tweetTimeDateMonth,
              tweetHour=tweetTimeDate2,
              tweetLinks=tweetTimeDate3,
              tweetLinksMonth=tweetTimeDate3Month
              ))
}

### extra processing needed for twitter exports, which is then fed into processTweets()
processTwitterExport <- function(export){
  export$created <- strftime(as.character(export$timestamp))
  ## there is no time in timestamps from 2010-11-04 21:46:36 in Twitter API response - just dates
  
  export$text    <- as.character(export$text)
  export$replyToSN <- export$in_reply_to_user_id
  export$retweeted <- !is.na(export$retweeted_status_id)
  
  tweetList <- processTweets(export)
  
  return(tweetList)
}


### Fetch and process the tweets in one step
processFetchTweets <- function(user="holomarked", number=10, timeToTweet=1, timeToReply=2, timeToRetweet=0.5){
  require(twitteR)
  tweetDF <- twListToDF(userTimeline(user,n=number, includeRts = TRUE))
  listResult <- processTweets(tweetDF,timeToTweet,timeToReply, timeToRetweet)
  return(listResult)
}

### Fetch the tweets only
FetchTweets <- function(user="holomarked", number=10){
  require(twitteR)
  tweetDF <- twListToDF(userTimeline(user,n=number, includeRts = TRUE))
  return(tweetDF)
}



### example of use - 3200 is maximum tweets available from Twitter API
### original API data is available in tweetsUserMark$df1
tweetsUserMark <- processFetchTweets("holomarked",n=3200)

### For use with Twitter Exports - take the .csv in zipped file
tweetsMeFull <- read.csv("./data/exported/tweets.csv")

### example processing .csv export
tweetsUserMe <- processTwitterExport(tweetsMeFull)
