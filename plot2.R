
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
png(filename="plot2.png",width=480,height=480)
plot(x,d1$Global_active_power, type="l",xlab="",ylab="Global Active Power (kilowatts)")
dev.off()
