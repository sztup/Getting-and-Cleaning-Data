#Aim: You should create one R script called run_analysis.R that does the following.
#Additional subaims: code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md

#Step0.0:load libraries
########
library(reshape2)

#Step0.1: Download and unzip dataset
########
execute_Step0.1<-FALSE # Change it to TRUE if needed
	if(execute_Step0.1){
	#setwd("F:/Downloads") # I just like defining the directory I am working in
	fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
	download.file(fileURL, method="curl",destfile="HAR_Dataset.zip")
	unzip("HAR_Dataset.zip")
	setwd(paste0(getwd(),"/HAR_Dataset/","UCI HAR Dataset"))
	#Let's have a look at the downloaded files:
	list.files()
	}

#Start by reading in some data about features and activity labels
features_names<-read.table("./features.txt", sep="",header=F, stringsAsFactors=F)
features_names<-features_names$V2 #This is not nice, sorry
activity_names<-read.table("./activity_labels.txt", sep="",header=F, stringsAsFactors=F)

#Step1: Merge the training and the test sets to create one data set.
######
# It is very ugly just rbinding the rows/columns, but there are no additional identifiers in the files, so I have to live with it
#train
train <- read.table("./train/X_train.txt", sep="",header=F, stringsAsFactors=F)
train_activities <- read.table("./train/Y_train.txt", sep="",header=F, stringsAsFactors=F)
train_subjects <- read.table("./train/subject_train.txt", sep="",header=F, stringsAsFactors=F)
train <- cbind(train_subjects, train_activities, train)
#Let's give them column names
colnames(train) <- c("subject", "activity", features_names)

#test
test <- read.table("./test/X_test.txt", sep="",header=F, stringsAsFactors=F)
test_activities <- read.table("./test/Y_test.txt", sep="",header=F, stringsAsFactors=F)
test_subjects <- read.table("./test/subject_test.txt", sep="",header=F, stringsAsFactors=F)
test <- cbind(test_subjects, test_activities, test)
colnames(test) <- c("subject", "activity", features_names)

#"merge"
#mydata<-merge(train, test, by=subject)
mydata <- rbind(train, test)


#Step2: Extract only the measurements on the mean and standard deviation for each measurement.
######
mydata2 <- mydata[,grepl("subject | activity | .*[Mm]ean.*|.*[Ss]td.*", colnames(mydata))]
#Lets check the size of mydata2, and the names of the selected columns
dim(mydata2)
colnames(mydata2)
#Oops, some of the selected columns are unwanted results like fBodyAccMag-meanFreq() or angle(Z,gravityMean), so let's change our tactic:
mydata2 <- mydata[,grepl("subject|activity|.*mean\\(\\)|.*std\\(\\)", colnames(mydata))]
dim(mydata2)
colnames(mydata2)
#It works fine now


#Step3&4: Use descriptive activity names to name the activities in the data set and Appropriately labels the data set with descriptive variable names.
######
# turn activities and subjects into factors, 
mydata2$activity <- factor(mydata2$activity, levels = activity_names[,1], labels = activity_names[,2])
mydata2$subject <- as.factor(mydata2$subject)


#Step5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
allData.melted <- melt(mydata2, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)
dim(allData.mean)
#save results:
write.table(allData.mean, "tidy_HAR_dateset.txt", row.names = FALSE, quote = FALSE, sep="\t")