# Coder: Joel Modisette
# Exploratory Data Analysis, John Hopkins Coursera

# Load Packages. I like the Tidyverse packages for readability.
packages <- c("data.table","readr", "dplyr", "stringr", "lubridate", "tidyr")
sapply(packages, require, character.only=TRUE, quietly=TRUE)

# This is my working directory. Anyone else using this will need to modify.
setwd("D:/Users/jmodisette/Desktop/Coursera/Course4_Explore_Data/Project1")
path <- getwd()

# I take the data munging step by step
# Read in data from file
pwr_tbl_0 <- read_delim(file.path(path, "household_power_consumption.txt"), delim = ";", na = c("?"))

# We need to modify the day and time columns so we have consistent day-time format
pwr_tbl_1 <- pwr_tbl_0 %>% 
                mutate(Time = as.character(Time)) %>%    #Change Time to character
                unite("DateTime", Date:Time) %>%        #so we can concat Date & Time
                mutate(DateTime = dmy_hms(DateTime))    #and format DateTime 

# set the interval of day-time we will subset on
int <- interval(dmy("01/02/2007"), dmy("03/02/2007"))

# now subset on this interval
pwr_tbl_2 <- pwr_tbl_1 %>% filter(DateTime %within% int)

# Set up our plot
png("plot3.png", width=480, height=480)

# Plot 3

plot(pwr_tbl_2$DateTime, pwr_tbl_2$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
lines(pwr_tbl_2$DateTime, pwr_tbl_2$Sub_metering_2, col="red")
lines(pwr_tbl_2$DateTime, pwr_tbl_2$Sub_metering_3, col="blue")
legend("topright"
       , col=c("black","red","blue")
       , c("Sub_metering_1  ","Sub_metering_2  ", "Sub_metering_3  ")
       ,lty=c(1,1), lwd=c(1,1))

dev.off()
