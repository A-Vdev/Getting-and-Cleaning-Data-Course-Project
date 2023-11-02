
#Getting and unzipping the .zip file
FileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(FileUrl,destfile = "dataset.zip")


unzip("dataset.zip")

# Reading the Feature info file for column name
featureNames <- read.table("UCI HAR Dataset/features.txt")

#Reading Test Data
X_test<-read.table("UCI HAR Dataset/test/X_test.txt",col.names = featureNames$V2)
Y_test<-read.table("UCI HAR Dataset/test/Y_test.txt",col.names = "activityID")
Subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt",col.names = "subjectID")

#Reading Train Data
X_train<-read.table("UCI HAR Dataset/train/X_train.txt",col.names = featureNames$V2)
Y_train<-read.table("UCI HAR Dataset/train/Y_train.txt",col.names = "activityID")
Subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt",col.names = "subjectID")



#Using cbind() method for merging the data sets with same  Number of rows
Train<-cbind(X_train,Y_train,Subject_train)
Test<-cbind(X_test,Y_test,Subject_test)


#Using rbind() method for merging the data sets with same  Number of rows
merged_data<-rbind(Train,Test)

#Extracting measurements on the mean and std

mean_std_data<-merged_data[,grepl(c("subject|activity|mean|std"),names(merged_data))]

# Reading the the activity name data
act_name<-read.table("UCI HAR Dataset/activity_labels.txt",col.names = c("activityID","activity"))

# Activity label
mean_std_names <- merge(mean_std, act_name, by = "activityID", all.x = TRUE)

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(dplyr)

tidydata <- mean_std_names %>% arrange(subjectID, activityID) %>% select(-activityID)
finaldata <- tidydata %>% group_by(subjectID, activity) %>% summarise_all( mean)

write.table(finaldata, "TidyData.txt", row.name = FALSE)
