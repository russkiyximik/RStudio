library(dplyr)
library(readr)

filename <- "Coursera_DS3_Final.zip"

# Checking if file already exists
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  

# Checking if folder already exists
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

features <- read_table('UCI HAR Dataset/features.txt', col_names = c('n', 'functions'))
activities <- read_table('UCI HAR Dataset/activity_labels.txt', col_names = c('label', 'activity'))
subject_test <- read_table('UCI HAR Dataset/test/subject_test.txt', col_names = 'subject')
x_test <- read_table('UCI HAR Dataset/test/X_test.txt', col_names = features$functions)
y_test <- read_table('UCI HAR Dataset/test/y_test.txt', col_names = 'label')
subject_train <- read_table('UCI HAR Dataset/train/subject_train.txt', col_names = 'subject')
x_train <- read_table('UCI HAR Dataset/train/X_train.txt', col_names = features$functions)
y_train <- read_table('UCI HAR Dataset/train/y_train.txt', col_names = 'label')

# Merges testing and training into one set
x <- rbind(x_test, x_train)
y <- rbind(y_test, y_train)
subject <- rbind(subject_test, subject_train)
mergedtibble <- cbind(subject, x, y)

# Extracts only the measurements on the mean and standard deviation for each measurement
extracted <- mergedtibble %>% select(subject, label, contains('mean'), contains('std'))

# Uses descriptive activity names to name the activities in the data set
extracted <- extracted %>% left_join(activities, by = c("label" = "label")) %>% 
  select(subject, activity, everything(), -label)

# Appropriately labels the data set with descriptive variable names
names(extracted)[2] = "activity"
names(extracted)<-gsub("Acc", "Accelerometer", names(extracted), ignore.case = TRUE)
names(extracted)<-gsub("Gyro", "Gyroscope", names(extracted), ignore.case = TRUE)
names(extracted)<-gsub("Mag", "Magnitude", names(extracted), ignore.case = TRUE)
names(extracted)<-gsub("^t", "Time", names(extracted), ignore.case = TRUE)
names(extracted)<-gsub("^f", "Frequency", names(extracted), ignore.case = TRUE)
names(extracted)<-gsub("tBody", "TimeBody", names(extracted), ignore.case = TRUE)
names(extracted)<-gsub("-mean()", "Mean", names(extracted), ignore.case = TRUE)
names(extracted)<-gsub("-std()", "STD", names(extracted), ignore.case = TRUE)
names(extracted)<-gsub("-freq()", "Frequency", names(extracted), ignore.case = TRUE)
names(extracted)<-gsub("angle", "Angle", names(extracted), ignore.case = TRUE)
names(extracted)<-gsub("gravity", "Gravity", names(extracted), ignore.case = TRUE)

# From the data set in step 4, creates a second, independent tidy data set with
# the average of each variable for each activity and each subject.
avgextracted <- extracted %>% group_by(subject, activity) %>% 
  summarise(across(where(is.numeric), mean), .groups = "drop")
write.table(avgextracted, "FinalData.txt", row.name=FALSE)
