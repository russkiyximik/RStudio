***IMPORTANT*** : I messed up the labeling part of the .R script. Instead of the line ''' extracted$label <- activities[extracted$label, 2] ''' , I should have written ''' extracted <- extracted %>% left_join(activities, by = c("label" = "label")) %>% select(subject, activity, everything(), -label) ''' to rename activities.


This is a project created for the final project of the "Getting and Cleaning Data" online course.

This project uses the UCI HAR Dataset. The goal is to filter the data by mean and standard deviation measurements, subsequently finding the mean of those measurements by subject and activity.

#### Files

-   CodeBook.md is a code book that describes the variables, data, and work that I performed to clean up the data

-   run_analysis.R performs the transformations as described in CodeBook.md

-   FinalData.txt is the output file containing the results.
