library(data.table)

if (!exists('tbl')) {tbl <- fread(
  'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip')
}
fltrtbl <- subset(tbl, tbl$Date == as.POSIXct('2007-02-01') | 
                    tbl$Date == as.POSIXct('2007-02-02'))

# Opens a png device:
png(file='plot1.png')

with(fltrtbl, hist(as.numeric(Global_active_power), 
                   col='red', main='Global Active Power', 
                   xlab='Global Active Power (kilowatts)'))
dev.off()
