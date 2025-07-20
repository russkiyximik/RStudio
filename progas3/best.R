best <- function(state, outcome) {
  mydf <- read.csv('outcome-of-care-measures.csv', colClasses = 'character')
  if (!any(mydf[,7] %in% state)) {
    stop('invalid state')
  } 
  else if (!any(c('heart attack', 'heart failure', 'pneumonia') %in% outcome)) {
    stop('invalid outcome')
  }
  
  
  # 30 day mortality rates for heart attack, heart failure, and pneumonia are
  # stored in columns 11, 17, and 23 of the csv, respectively.
  
  if (outcome == 'heart attack') outnum <- 11
  else if (outcome == 'heart failure') outnum <- 17
  else if (outcome == 'pneumonia') outnum <- 23

  
  # Creates a new df which contains only valid state and outcome entries.
  # Computes the minimum and then finds hospital name which matches the minimum.
  
  fixeddf <- mydf[!(mydf[,outnum] %in% 'Not Available') & 
                                  mydf$State == state, ]
  outmin <- min(as.numeric(fixeddf[,outnum]))
  minhosp <- fixeddf[as.numeric(fixeddf[,outnum]) == outmin,2]
  message(minhosp)
}