corr <- function(directory, threshold = 0) {
  # wd is progas1
  listoffiles <- list.files(path = 
    file.path(getwd(), directory),
    pattern = '*.csv')
  
  myfiles <- complete(directory)[complete(directory)$nobs>threshold,]
  selectedfiles <- listoffiles[myfiles$id]
  
  # We need to correlate the sulfate and
  # nitrate levels of each independent file
  # and then append the results to "cr",
  # which is a vector of correlations.

  cr <- numeric()
  for (i in seq_along(selectedfiles)) {
    readfile <- read.csv(file.path(getwd(), 
      directory, selectedfiles[i]))
    
    goodrows <- complete.cases(readfile$sulfate, readfile$nitrate)
    correlation <- cor(readfile$sulfate[goodrows], readfile$nitrate[goodrows])
    cr <- c(cr, correlation)
  }
  return(cr)
}