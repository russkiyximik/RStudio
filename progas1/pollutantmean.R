pollutantmean <- function(directory, pollutant, id = 1:332) {
  
  listoffiles <- list.files(paste(getwd(), 
    directory, sep='/'), pattern='*.csv')
  
  listvalues <- numeric()
  
  for (i in id) {
    
    readfile <- read.csv(paste(getwd(), 
    directory, listoffiles[i], sep='/'))
    
    listvalues <- append(listvalues, readfile[,pollutant][!is.na(readfile[,pollutant])])
  }
  
  return(sum(listvalues) / length(listvalues))
}