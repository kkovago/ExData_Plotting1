
## Load libraries
library(data.table)
library(dplyr)

## Define "constants"
# Data file URL
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
# Data file name
dataFileName <- "household_power_consumption.txt"

# Memory requirement estimate for the whole data:
# 2,075,259 rows x 9 columns x 8 bytes = 149,418,648 bytes

# download and extract the zip file if no local copy exists yet
if(!file.exists(dataFileName)){
    print.noquote("Downloading and extracting data files....")
    temp <- tempfile(tmpdir=dataDirName)
    download.file(fileURL,temp)
    # Unzip the zip file, remove the temporary file
    unzip(temp)
    unlink(temp)
}
dat <- fread(dataFileName, data.table=TRUE, na.strings="?")
# Date column is formatted as dd/mm/yyyy. Filter data to required records
dat <- dat[is.element(dat$Date,c("1/2/2007","2/2/2007")),]
# Clean data
d1 <- dat[complete.cases(dat), ]
# Create x axis for diagrams 2,3,4 from data date and time columns
timevector <- paste(d1$Date,d1$Time)
x <- strptime(timevector, "%d/%m/%Y %H:%M:%S")

# Plot the diagram into a PNG file
png(filename="plot4.png",width=480,height=480)

# create 4 plot segments
par(mfrow=c(2,2))
# digarma 4a
plot(x,d1$Global_active_power, type="l",xlab="",ylab="Global Active Power")
# digarma 4b
plot(x,d1$Voltage, type="l",xlab="datetime",ylab="Voltage")
# diagram 4c
plot(x,d1$Sub_metering_1, type="l",xlab="",ylab="Energy Sub Metering")
lines(x,d1$Sub_metering_2, col="red")
lines(x,d1$Sub_metering_3, col="blue")
legend("topright",legend=names(d1)[grep("Sub",names(d1))],col=c("black","red","blue"),lwd=1)
# diagram 4d
plot(x,d1$Global_reactive_power, type="l",xlab="datetime", ylab="Global_Active_Power")
dev.off()
