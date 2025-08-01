library(data.table)

if (!exists('tbl')) {tbl <- fread(
  'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip')
}
fltrtbl <- subset(tbl, tbl$Date == as.POSIXct('2007-02-01') | 
                    tbl$Date == as.POSIXct('2007-02-02'))

# Opens a png device:
png(file='plot3.png')

# Converts POSIXct to character
convdate <- format(fltrtbl$Date)
# Reverts to POSIXct after adding Time
xaxis <- as.POSIXct(paste(convdate, fltrtbl$Time))

plot(xaxis, fltrtbl$Sub_metering_1, type='n', xlab='', ylab = 'Energy Sub Metering')
points(xaxis, fltrtbl$Sub_metering_1, type='l', col='black')
points(xaxis, fltrtbl$Sub_metering_2, type='l', col='red')
points(xaxis, fltrtbl$Sub_metering_3, type='l', col='blue')
legend('topright', c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), 
       col=c('black', 'red', 'blue'), lty=1)

dev.off()
