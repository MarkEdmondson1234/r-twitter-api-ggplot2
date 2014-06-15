# Twitter API and Plots in R

Demo plotting Twitter API data in R.  Plots using library(ggplot2), Twitter imports using library(twitteR)

## To Use
### Get Data using twitteR
1. Register your Twitter app here https://apps.twitter.com/app/new
2. Get your api_key and api_secret, fill in keys in auth.r
3. Source/Run auth.r, then copy the Tiwtter Authentication URL it gives you into your browser
4. The URL will disply a PIN.  Input this displayed PIN into the R terminal at the prompt
5. Repeat every R session you need access to Twitter API (this probably could be improved)

### Process Data
6. tweetdata.r contains helper functions to manage the data.  Use FetchTweets()  and processTweets() to generate data suitable for plots.  They create lists of dataframes with monthly and weekly aggregates to explore.  Note there is not timestamp data for tweets before the end of 2010.
7. There is a 3200 tweet limit on the API.  You can get around this for your own tweets by using the export tweet function, then processing the .csv instead.  Use processTwitterExport() in tweetdata.r to do additional processing to get the csv import into the same format as API data. 

### Plot Data using ggplot2
8. plotTweets.R contains functions to Plot data using plotTweetsDP() and plotLinksTweets()
9. plotTweets.R also contains a custom ggplot2 theme, theme_mark() used in plotTweetsDP()
10. Demo images using my twitter data @HoloMarkeD and theme_mark() are in the images folder

## Feedback welcomed

Any additions, comments or requests can be written on Github or you contact me on twitter at https://twitter.com/holomarked

