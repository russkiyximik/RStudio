complete <- function(directory, id = 1:332) {
  # wd is progas1
  listoffiles <- list.files(path = 
    file.path(getwd(), directory),
    pattern = '*.csv')
  
  mydf <- data.frame(
    id = numeric(),
    nobs = numeric()
  )

  for (i in id) {
    
    readfile <- read.csv(paste(getwd(), 
      directory, listoffiles[i], sep='/'))
    
    completecolumns <- readfile[complete.cases(readfile[,c('sulfate', 'nitrate')]), c('sulfate', 'nitrate')]
    nobs_val <- length(completecolumns[,1])
    # More succinctly, I could just use
    # complete.cases to find logical vectors
    # and sum the logics, since TRUE is 1
    # and FALSE is 0. Better than finding
    # the length of the new column.
    
    mydf <- rbind(mydf, data.frame(id=i, nobs=nobs_val))
  }
  return(mydf)
}