# Introduction

This `CodeBook.md` is a code book that describes the variables, the data, and any transformations or work that was performed to clean up the data called.
The script `run_analysis.R` performs the 5 steps described in the course project's description.

# The data
As described before: The analysed dateset is from an experiment of 30 volunteers performing six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone on the waist. Using its embedded accelerometer and gyroscope, 3-axial linear acceleration and 3-axial angular velocity were captured at a constant rate of 50Hz.
The experiment itself is about classification and clustering (i.e. identifying the activity based on the meassurements), but this exercise is just about boring stuff.

The dataset is available from the UC Irvine Machine Learning Repository: [Human Activity Recognition Using Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

# Variables used in the analysis
`features_names`: names of the features
`activity_names`: codes and names of the activities
`train`: X_train.txt and Y_train.txt merged, colnames:  c("subject", "activity", features_names)
`test`: X_test.txt and Y_test.txt merged, colnames:  c("subject", "activity", features_names)
`mydata`: merged train and test
`mydata2`: data frame only containing columns with std(), mean(), "subject" and "activity" in their names (activityand subject are converted to be factors)
`allData.melted`: long format transformed mydata2`
`allData.mean`: mean for each of the meassurements for each of the activities and subjects, saved as **tidy_HAR_dateset.txt**

# Transformations used
Step0.0: Load libraries
Step0.1: Download and unzip dataset
I also like to set the working directory, just to be sure. Then I read in some data about features and activity labels
Step1: Merge the training and the test sets to create one data set.
First the data is read in for the training and the test set, and the column are renamed using the names of the features loaded in the previous step.
It is very ugly just rbinding the rows/columns, but there are no additional identifiers in the files, so I have to live with it. So the "merging" needs to be done via rbind.
Step2: Extract only the measurements on the mean and standard deviation for each measurement.
I was searching for Mean, mean, Std ord std using grepl("subject|activity|.*mean\\(\\)|.*std\\(\\)", colnames(mydata))
Step3&4: Applied factor command to use descriptive activity names to name the activities in the data set
Step5: On the data set from step 4, I used melt() command to change it to long format, and then used dcast() command to calculate the mean for each of the variables. This step may also be carried out using plyr package or apply in some for. These methods were not benchmarked in my analysis.
Last step: saving the results.
