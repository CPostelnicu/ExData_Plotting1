setwd("~/workSOURCECODE/datasciencespecialization/exploratorydataanalysis")
library(lubridate)

# only using data from the dates 2007-02-01 and 2007-02-02. 
startDate = ymd("2007-02-01")
endDate = ymd("2007-02-02")

tempData = read.table("./data/household_power_consumption.txt", sep = ";", header = TRUE, na.strings = "?")
tempData$Date <- dmy(tempData$Date)
## subset to useful columns
subsetData <- subset(tempData, (Date == startDate) | (Date == endDate))

# construct and save the plot
png("plot1.png", width=480, height=480)
dev.cur()
hist(subsetData$Global_active_power,main = "Global Active Power", xlab = "Global Active Power (kilowatts)", col = "red")
dev.off()







