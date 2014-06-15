### auth.r
### Authenticate R session using library(twitteR)
### 15th June 2014
### Mark Edmondson @HoloMarkeD
###
### 1. Register your Twitter app here https://apps.twitter.com/app/new
### 2. Get your api_key and api_secret, fill in below
### 3. Source this file, copy the Twitter Authentication URL 
### 4. Input the PIN every session you need access to Twitter API

require(twitteR)

api_key = "XXXXX"
api_secret = "XXXXX"

TwitterOAuth<-function(){
  reqURL <- "https://api.twitter.com/oauth/request_token"
  accessURL <- "https://api.twitter.com/oauth/access_token"
  authURL <- "https://api.twitter.com/oauth/authorize"
  twitCred <- OAuthFactory$new(consumerKey=api_key,
                               consumerSecret=api_secret,
                               requestURL=reqURL,
                               accessURL=accessURL,
                               authURL=authURL)
  options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package =  "RCurl")))
  twitCred$handshake()
  registerTwitterOAuth(twitCred)
}

TwitterOAuth()