---
editor_options: 
  markdown: 
    wrap: 72
---

The run_analysis.R script performs the data manipulation.

Dataset downloaded and extracted under the folder called UCI HAR
Dataset.

#### Assign all data to variables

features \<- features.txt : Full list of recorded variables in raw data

activities \<- activity_labels.txt : List of activities performed mapped
numerically

subject_test \<- subject_test.txt : Enumerates test data of 9/30
subjects

x_test \<- X_test.txt : Contains recorded test data

y_test \<- y_test.txt : Enumerates test data of activities

subject_train \<- subject_train.txt : Enumerates training data of 21/30
subjects

x_train \<- X_train.txt : Contains recorded train data

y_train \<- y_train.txt : Enumerates train data of activities

#### Merges the training and the test sets to create one data set 

x is created by merging x_train and x_test using rbind(). y is created
by merging y_train and y_test using rbind(). subject is created by
merging subject_train and subject_test using rbind(). mergedtibble is
created by merging subject, x, and y using cbind().

#### Extracts only the measurements on the mean and standard deviation for each measurement 

extracted is created by subsetting mergedtibble, selecting columns
subject, label and the measurements on the mean and standard deviation.

#### Uses descriptive activity names to name the activities in the data set

Numbers in label column of extracted are replaced with corresponding
activity taken from second column of the activities variable.

#### Appropriately labels the data set with descriptive variable names 

All 88 chosen variables in extracted are renamed for clarity. See
run_analysis.R source code.

#### From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

Tibble avgextracted is created by summarizing extracted, grouping by
subject and activity and taking the mean of each variable. avgextracted
exported into FinalData.txt file.
