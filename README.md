# Twitter API and Plots in R

/r-twitter-api-ggplot2

Demo plotting Twitter API data in R, using library(ggplot2) and library(twitteR)

## To Use
### Get Data
1. Register your Twitter app here https://apps.twitter.com/app/new
2. Get your api_key and api_secret, fill in keys in auth.r
3. Source auth.r, copy the Tiwtter Authentication URL into your browser
4. Input the displayed PIN in your browser into the R terminal
5. Repeated every R session you need access to Twitter API (this probably could be improved)

### Process Data
6. tweetdata.r contains helper functions.  Use FetchTweets()  and processTweets() to generate data suitable for plots.  They create lists of dataframes with monthly and weekly aggregates to explore
7. There is a 3200 tweet limit on the API.  You can get around this for your own tweets by using the export tweet function.  Then use processTwitterExport() in tweetdata.r to do additional processing.

### Plot Data
8. plotTweets.R contains functions to Plot data using plotTweetsDP() and plotLinksTweets()
9. plotTweets.R also contains a custom ggplot2 theme, theme_mark() used in plotTweetsDP()
10. Demo images using my twitter data @HoloMarkeD is in the images folder

## Feedback welcomed

Any additions, comments or requests can be written on Github or contact me on twitter https://twitter.com/holomarked

