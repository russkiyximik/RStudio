rankhospital <- function(state, outcome, num = 'best') {
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
  #message(outnum)
  
  
  # Creates a new df which contains only valid state and outcome entries.
  fixeddf <- mydf[!(mydf[,outnum] %in% 'Not Available') & 
                    mydf$State == state, ]
  
  # Sort by rank (and alphabetically to break ties).
  sortedfixeddf <- fixeddf[order(as.numeric(fixeddf[,outnum]), fixeddf[,2]),]
  
  
  # Get the proper hospital
  if (num == 'best') {
    myhosp <- sortedfixeddf[1, 2]
    #message(sortedfixeddf[1, outnum])
  }
  else if (num == 'worst') {
    myhosp <- sortedfixeddf[length(sortedfixeddf[,outnum]), 2]
    #message(sortedfixeddf[length(sortedfixeddf[,outnum]), outnum])
  }
  else {
    myhosp <- sortedfixeddf[num, 2]
    #message(sortedfixeddf[num, outnum])
  }
  
  message(myhosp)
}