"
This script uses individual household electric power consumption data
from the UC Irvine Machine Learning Repository. The data contains
measurement of electric power consumption in one household with a one
minute sampling rate over a period of 4 years.

The script will use data from 2/1/2007 to 2/2/2007 to create
a histogram of global active power.
"
require("dplyr")
require("lubridate")

drawPlot1 <- function() {
    
    if (is.null(power_df)) {
        message("Reading data from file...")
        power_df <- read.csv("data/household_power_consumption.txt",header=TRUE,
                         sep=";", na.strings="?",stringsAsFactors=FALSE)
    }
    else {
        message("Using cached data")
    }
    # create new column based on combination of Date and Time columns
    df <- mutate(power_df,timestamp=parse_date_time(paste(Date,Time), orders="dmy hms"))
    
    # remove Date and Time columns since they are no longer needed
    df <- select(df, -c(Date,Time))
    
    # extract data from 2/1/2007 to 2/2/2007 and save it
    start <- as.POSIXct("2007-01-31 23:59:59", tz="GMT")
    end <- as.POSIXct("2007-02-03 00:00:00",tz="GMT")
    feb2007 <- filter(df,timestamp > start, timestamp < end)
    
    # save plot to PNG file
    png(file="data/plot1.png",width=480,height=480)
    hist(feb2007$Global_active_power,col="orange",
         xlab="Global Active Power (kilowatts)",main="Global Active Power")
       
    dev.off()
}