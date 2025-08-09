library(tidyverse)

zipname <- 'mydata.zip'
if (!file.exists(zipname)) {
  download.file('https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip',
                zipname)
}

unzip(zipname)

## This first line will likely take a few seconds.
NEI <- as_tibble(readRDS("summarySCC_PM25.rds"))
SCC <- as_tibble(readRDS('Source_Classification_Code.rds'))

plot1 <- subset(NEI, year==c(1999, 2002, 2005, 2008))
# I get the sum of emissions per year in the tibble and plot it!
plot(c(1999, 2002, 2005, 2008), tapply(plot1$Emissions, plot1$year, sum), 
     type="o", xlab="Year", ylab="Total Emissions")

balt <- subset(NEI, year==c(1999:2008) & fips=='24510')
# table(plot2$year) shows that we only have years 1999, 2002, 2005, 2008.
plot(c(1999, 2002, 2005, 2008), tapply(balt$Emissions, balt$year, sum), 
     type="o", xlab="Year", ylab="Total Emissions in Baltimore City")

splitbalt <- aggregate(Emissions ~ year + type, data=balt, sum)
g3 <- ggplot(data=splitbalt, aes(year, Emissions, group=type))
g3 + geom_point(aes(color=type)) + geom_line()
# As we can see, NONPOINT saw a decrease, ON-ROAD saw a decrease, POINT saw an
# initial increase but it tapered off, and lastly NON-ROAD saw a very slight 
# increase.

# I split up the SCC to get the Coal stuff, then subset NEI by the corresponding
# SCC values.
sectors <- names(table(SCC$EI.Sector))[grepl('Coal', names(table(SCC$EI.Sector)))]
coalSCC <- subset(SCC, EI.Sector %in% sectors) %>% select(SCC, EI.Sector) %>% droplevels
coal <- left_join(coalSCC, NEI, by='SCC')
g4 <- ggplot(data=aggregate(Emissions ~ year, data=coal, sum), aes(year, Emissions))
g4 + geom_point() + geom_line()

vehicles <- names(table(SCC$EI.Sector))[grepl('Vehicle', names(table(SCC$EI.Sector)))]
vehiclesSCC <- subset(SCC, EI.Sector %in% vehicles) %>% 
  select(SCC, EI.Sector) %>% droplevels
baltvehicles <- inner_join(vehiclesSCC, balt, by='SCC')
# or baltvehicles <- balt %>% filter(SCC %in% baltvehiclesSCC$SCC)
g5 <- ggplot(data=aggregate(Emissions ~ year, data=baltvehicles, sum), aes(year, Emissions))
g5 + geom_point() + geom_line()

la <- subset(NEI, year==c(1999:2008) & fips=='06037')
lavehicles <- inner_join(vehiclesSCC, la, by='SCC')
baltvehicles$city <- 'Baltimore'
lavehicles$city <- 'Los Angeles'
bothcities <- bind_rows(baltvehicles, lavehicles)
bothcities %>% 
  group_by(year, city) %>% 
  summarise(Emissions = sum(Emissions), .groups="drop")
g6 <- ggplot(data=aggregate(Emissions ~ year + city, data=bothcities, sum), 
             aes(year, Emissions, linetype=city))
g6 + geom_point() + geom_line()
