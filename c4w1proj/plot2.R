library(data.table)

if (!exists('tbl')) {tbl <- fread(
  'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip')
}
fltrtbl <- subset(tbl, tbl$Date == as.POSIXct('2007-02-01') | 
                    tbl$Date == as.POSIXct('2007-02-02'))

# Opens a png device:
png(file='plot2.png')

# Converts POSIXct to character
convdate <- format(fltrtbl$Date)
# Reverts to POSIXct after adding Time
xaxis <- as.POSIXct(paste(convdate, fltrtbl$Time))

plot(xaxis, fltrtbl$Global_active_power, type='l', xlab = "", 
     ylab = "Global Active Power (kilowatts)")

dev.off()
