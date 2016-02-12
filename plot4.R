setwd("~/workSOURCECODE/datasciencespecialization/exploratorydataanalysis")
library(lubridate)

weekday.labels <- c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")

# only using data from the dates 2007-02-01 and 2007-02-02. 
startDate = ymd("2007-02-01")
endDate = ymd("2007-02-02")

tempData = read.table("./data/household_power_consumption.txt", sep = ";", header = TRUE, na.strings = "?")
tempData$Date <- dmy(tempData$Date)
tempData$Time <- hms(tempData$Time)
## subset to useful columns
subsetData <- subset(tempData, (Date == startDate) | (Date == endDate))
datetimes <-paste(subsetData$Date, subsetData$Time)
subsetData["DateTime"]<- datetimes

## find valid weekday labels and start indexes on axis
subsetData["Weekday"] <- wday(subsetData$Date, label = TRUE, abbr = TRUE)
subsetData$Weekday <- gsub(pattern  ="Thurs", replacement = "Thu", x = subsetData$Weekday)
valid.weekdays <- unique(subsetData$Weekday)
valid.weekdayindexes <- c(NA)*(length(valid.weekdays)+1)
## find first index of each valid day in the plot
valid.weekdayindexes[1] <- which(subsetData$Weekday == valid.weekdays[1])[1]
valid.weekdayindexes[2] <- which(subsetData$Weekday == valid.weekdays[2])[1]
## find last index of last valid day in the plot
valid.weekdayindexes[3] <- which(subsetData$Weekday == valid.weekdays[2])[length(which(subsetData$Weekday == valid.weekdays[2]))]
last.day.index <- which(weekday.labels == valid.weekdays[length(valid.weekdays)])+1
last.day <- weekday.labels[last.day.index]

# construct and save the plot
png("plot4.png", width=480, height=480)
dev.cur()

par(mfrow = c(2,2))
with(subsetData, plot( xaxt = "n", x= 1: length(DateTime), y = Global_active_power, pch = ".", xlab = "", ylab = "Global Active Power (kilowatts)"))
with(subsetData, lines(x= 1: length(DateTime), y = Global_active_power))
axis(1, at=valid.weekdayindexes, labels=c(valid.weekdays, last.day), las=1)

with(subsetData, plot( xaxt = "n", x= 1: length(DateTime), y = Voltage, pch = ".", xlab = "datetime", ylab = "Voltage"))
with(subsetData, lines(x= 1: length(DateTime), y = Voltage))
axis(1, at=valid.weekdayindexes, labels=c(valid.weekdays, last.day), las=1)

with(subsetData, plot( xaxt = "n", x= 1: length(DateTime), y = Sub_metering_1, pch = ".", xlab = "", ylab = "Energy sub metering"))
with(subsetData, lines(x= 1: length(DateTime), y = Sub_metering_1))
with(subsetData, lines(x= 1: length(DateTime), y = Sub_metering_2, col = "red"))
with(subsetData, lines(x= 1: length(DateTime), y = Sub_metering_3, col = "blue"))
axis(1, at=valid.weekdayindexes, labels=c(valid.weekdays, last.day), las=1)
legend("topright",pch=c("-","-", "-"), lty = 1, col=c("black", "blue","red"),legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

with(subsetData, plot( xaxt = "n", x= 1: length(DateTime), y = Global_reactive_power, pch = ".", xlab = "datetime"))
with(subsetData, lines(x= 1: length(DateTime), y = Global_reactive_power))
axis(1, at=valid.weekdayindexes, labels=c(valid.weekdays, last.day), las=1)


dev.off()

