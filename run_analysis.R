#Loading dplyr package
library(dplyr)

#Download the dataset
filename <- "Course3_Final.zip"
if (!file.exists(filename)) {
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileURL, filename)
}

if(!file.exists("UCI HAR Dataset")) {
        unzip(filename)
}

#Working Directory
setwd("~/COURSERA/DATA SCIENCE/getting and cleaning data/UCI HAR Dataset")

#Assigning all data frames
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code","activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#1. Merges the training and the test sets to create one data set
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)

#2. Extracts only measurments on the mean and standard deviation for each measurment.
KeepData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))

#3. Uses descriptive activity names to name the activities in the data set.
KeepData$code <- activities[KeepData$code, 2]

#4. Appropriately labels the data set with descriptive variable names. 
names(KeepData)[2] = "activity"
names(KeepData) <- gsub("Acc", "Accelerometer", names(KeepData))
names(KeepData) <- gsub("Gyro", "Gyroscope", names(KeepData))
names(KeepData) <- gsub("BodyBody", "Body", names(KeepData))
names(KeepData) <- gsub("Mag", "Magnitude", names(KeepData))
names(KeepData) <- gsub("^t", "Time", names(KeepData))
names(KeepData) <- gsub("^f", "Frequency", names(KeepData))
names(KeepData) <- gsub("tBody", "TimeBody", names(KeepData))
names(KeepData) <- gsub("-mean()", "Mean", names(KeepData), ignore.case = TRUE)
names(KeepData) <- gsub("-std()", "STD", names(KeepData), ignore.case = TRUE)
names(KeepData) <- gsub("-freq()", "Frequency", names(KeepData), ignore.case = TRUE)
names(KeepData) <- gsub("angle", "Angle", names(KeepData))
names(KeepData) <- gsub("gravity", "Gravity", names(KeepData))

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
FinalData <- KeepData %>%
        group_by(subject, activity) %>%
        summarise_all(funs(mean))
write.table(FinalData, "FinalData2.txt", row.name=FALSE)

#Checking if it works!
str(FinalData)
FinalData

