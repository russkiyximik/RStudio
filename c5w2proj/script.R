library(ggplot2)
library(tidyverse)

if (!file.exists('StormData.bz2')) {
	download.file('https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2', 'StormData.bz2')
}

raw <- read_csv('StormData.bz2')

# Which event types cause the most harm to population health (measured by 
# fatalities)?
fatbyevent <- raw %>% select(FATALITIES, EVTYPE) %>% group_by(EVTYPE) %>% 
	summarise(FATALITIES=sum(FATALITIES)) %>% arrange(desc(FATALITIES)) %>% 
	mutate(EVTYPE = ifelse(row_number() > 20, 'Other', EVTYPE)) %>% 
	group_by(EVTYPE) %>% summarise(FATALITIES=sum(FATALITIES))

g1 <- ggplot(fatbyevent, aes(EVTYPE, FATALITIES))
g1 + geom_col() + theme(axis.text.x = element_blank())
fatbyevent$EVTYPE[[which.max(fatbyevent$FATALITIES)]]
# Tornadoes cause the most damage to human health with a total of 
# 288661 recorded fatalities.

# Which types of events have the greatest economic consequences? (measured by 
# property damage)?
dmgbyevent <- raw %>% select(PROPDMG, EVTYPE) %>% group_by(EVTYPE) %>% 
	summarise(PROPDMG=sum(PROPDMG)) %>% arrange(desc(PROPDMG)) %>% 
	mutate(EVTYPE = ifelse(row_number() > 20, 'Other', EVTYPE)) %>% 
	group_by(EVTYPE) %>% summarise(PROPDMG=sum(PROPDMG))

g2 <- ggplot(dmgbyevent, aes(EVTYPE, PROPDMG))
g2 + geom_col() + theme(axis.text.x = element_blank())
dmgbyevent$EVTYPE[[which.max(dmgbyevent$PROPDMG)]]
# Again, tornadoes are the most harmful event type, this time by 
# property damage.