### plotTweets.r
### Plot out tweets
### Requires you have authenticated in auth.R and processed in tweetdata.R
### 15th June 2014
### Mark Edmondson @HoloMarkeD
###

library(ggplot2)

######################################################################
###  Custom theme for ggplot, theme_mark()
###
###


### run once to install fonts needed for theme_mark()
installFonts <- function(){
  #install.packages("extrafont")
  require(extrafont)
  font_import("Trebuchet MS")
  font_import("Gill Sans")
}


### custom ggplot2() theme
### Uses BBC font, takes away all gridlines
theme_mark <- function(base_size = 24, base_family = "Gill Sans") {
  require(ggplot2)
  library(grid)
  theme_grey(base_size = base_size, base_family = base_family) %+replace% 
    theme(text = element_text(family = base_family, face = "plain", colour = "black", size = base_size, hjust = 0.5, vjust = 0.5, angle = 0, lineheight = 0.5),
          axis.text = element_text(size = rel(0.8)),
          axis.text.x = element_text(vjust = 0.1),
          axis.text.y = element_text(hjust = 0.1),
          axis.ticks = element_line(colour = "black"),
          axis.ticks.margin = unit(1,"mm"),
          legend.key = element_rect(colour = "grey80"), 
          axis.ticks.length = unit(1, "mm"),
          panel.background = element_rect(fill = "white", colour = NA), 
          panel.border = element_rect(fill = NA,colour = "grey50", size = 0), 
          panel.grid.major = element_line(colour = "grey90", size = 0), 
          panel.grid.minor = element_line(colour = "grey98", size = 0), 
          strip.background = element_rect(fill = "grey80",  colour = "grey50"), 
          strip.background = element_rect(fill = "grey80",  colour = "grey50"))
}

#######################################################################################
### functions for plots below:
##
#
#
### add custom colours to RColorBrewer, used in plotTweetsDP() and plotLinksTweet()
choosePalette <- function(choose = "CB", num=5, name="Blues"){
  require(RColorBrewer)
  if(choose == "mrMustard"){  ### add more custom colours if you like by adding conditions
    c("#325A66",'#FFF8B2','#DEA140','#590D0B','#A32B26')
  } else if (choose == "CB"){
    brewer.pal(num, name)
  }
}

### plot tweets with daypart, use timeAxis to make it year-month or year_week
### cPalette uses choosePalette() to generate colours
plotTweetsDP <- function(df1, name="@HoloMarkeD", timeAxis="yw", cPalette="mrMustard"){
  ## daypart is only possible to calculate from after 2010-11 / 2010_45
  ## filtering data if longer than that
  if (timeAxis == "yw"){
    df1 <- df1[df1$yw >= "2010_45",]
    x_axis_name <- "Year_Week"
  } else if (timeAxis == "ym"){
    df1 <- df1[df1$ym >= "2010-11",]
    x_axis_name <- "Year-Month"
  } else {
    stop("timeAxis not expected format: 'yw' or 'ym'")
  }
  gg <- ggplot(data=df1, aes_string(x=timeAxis, y="timespent", group="daypart")) + theme_mark()
  gg <- gg + geom_area(alpha = 0.7, aes(fill=daypart), position="stack")
  gg <- gg + stat_smooth(aes(colour=daypart), level=0.1)
  gg <- gg + guides(alpha=FALSE, colour=FALSE)
  gg <- gg + ggtitle(name)
  
  ## setting axis so not too crowded for weeks vs months
  if (timeAxis == "yw"){
    gg <- gg + scale_x_discrete("Year_Week", breaks = c(paste(c("2013"),"_",gsub(" ","0", sprintf("%2d", seq(1, 51, 4))), sep=""), paste(c("2014"),"_",gsub(" ","0", sprintf("%2d", seq(1, 51, 4))), sep="")), expand=c(0,0))
    } else {
    gg <- gg + scale_x_discrete("Year", breaks = paste(c("2011","2012","2013","2014"),"-","01", sep=""), labels = c("2011","2012","2013","2014"), expand=c(0,0))
  }
  gg <- gg + scale_y_continuous("Time Spent", expand=c(0,0))
  gg <- gg + scale_fill_manual(name="Day Part", 
                               labels = c("Early","Morning","Afternoon","Evening"),
                               values = choosePalette(cPalette))
  gg <- gg + scale_colour_manual(values = choosePalette(cPalette))
  print(gg)
}

### plotting amount of tweets with links in them.
plotLinksTweets <- function(df=MarkTweetPro$tweetLinks, name="@HoloMarkeD", timeAxis="yw", cPalette="mrMustard"){
  require(ggplot2)
  gg <- ggplot(data=df, aes_string(x=timeAxis, y="timespent", group="URL_B")) + theme_mark()
  gg <- gg + geom_area(aes(alpha=0.7,  fill=URL_B), position="stack")
  gg <- gg + stat_smooth(aes(colour=URL_B), level=0.1)
  gg <- gg + guides(alpha=FALSE)
  
  ## setting axis so not too crowded for weeks vs months
  if (timeAxis == "yw"){
    gg <- gg + scale_x_discrete("Year_Week", breaks = c(paste(c("2013"),"_",gsub(" ","0", sprintf("%2d", seq(1, 51, 4))), sep=""), paste(c("2014"),"_",gsub(" ","0", sprintf("%2d", seq(1, 51, 4))), sep="")), expand=c(0,0))
  } else {
    gg <- gg + scale_x_discrete("Year", breaks = paste(c("2011","2012","2013","2014"),"-","01", sep=""), labels = c("2011","2012","2013","2014"), expand=c(0,0))
  }
  gg <- gg + scale_fill_manual(name="Links In Tweet", 
                               labels=c("No Link","Link"),
                               values = choosePalette(cPalette)) + guides(colour=FALSE)
  gg <- gg + ggtitle(name)
  gg <- gg + scale_y_continuous(name="Time Spent", expand=c(0,0))
  gg <- gg + scale_colour_manual(values = choosePalette(cPalette))
  print(gg)
  
}

#####################################################################################
### Example of how to plot below
##
#
#
### example data processed again to demo processTweets() or could use processFetchTweets("holomarked",n=3200)
MarkTweetPro <- processTweets(tweetsUserMark$df1)

### example plots, using monthly aggregate dataframes
plotTweetsDP(MarkTweetPro$tweetTDm, "@HoloMarkeD's last 3200 tweets timeline", timeAxis="ym")
plotLinksTweets(MarkTweetPro$tweetLinksMonth,"@HoloMarkeD's last 3200 tweets link vs nolink ratio","ym")



