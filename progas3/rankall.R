rankall <- function(outcome, num='best') {
  mydf <- read.csv('outcome-of-care-measures.csv', colClasses = 'character')
  if (!any(c('heart attack', 'heart failure', 'pneumonia') %in% outcome)) {
    stop('invalid outcome')
  }
  
  # 30 day mortality rates for heart attack, heart failure, and pneumonia are
  # stored in columns 11, 17, and 23 of the csv, respectively.
  if (outcome == 'heart attack') outnum <- 11
  else if (outcome == 'heart failure') outnum <- 17
  else if (outcome == 'pneumonia') outnum <- 23
  
  
  # Use split() to make a list of each state and outcome val pair.
  valsbystate <- split(mydf[,outnum], mydf$State) # This is a list
  removeNAsAndSort <- function(myvec) {
    posNAs <- myvec == 'Not Available'
    newvec <- myvec[!posNAs]
    return(as.numeric(newvec)[order(as.numeric(newvec))])
  }
  cleanvals <- lapply(valsbystate, removeNAsAndSort)
  
  
  # And finally, we find the corresponding hospital to 'num'.
  myhospitals <- character()  
  for (i in seq_along(cleanvals)) {
    # Set nums
    indx <- num
    if ('best' %in% num) indx <- 1
    else if ('worst' %in% num) indx <- length(cleanvals[[i]])
    if (length(cleanvals[[i]]) < indx) {
      myhospitals <- append(myhospitals, '<NA>')
    }
    else {
      myval <- cleanvals[[i]][indx]
      myhospitals <- append(myhospitals, sort(mydf[mydf[,outnum] == myval & 
                               mydf$State == names(cleanvals)[i], 2])[1])
    }
  }
  
  
  result <- data.frame(hospital = myhospitals, state = names(cleanvals))
  return(result)
}