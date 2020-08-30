library(dplyr)

#
# download data
#
fname<-"getdata_projectfiles_UCI HAR Dataset.zip"
if (!file.exists(fname))
{
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url, fname, method="curl")
}

#
# extract data
#
path <- "UCI HAR Dataset"
if (!file.exists(path))
{
  unzip(fname)
}

#
# build data frames
#
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","signal"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
testSubject <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "sub")
testX <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$signal)
testY <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
trainSubject <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "sub")
trainX <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$signal)
trainY <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#
# Start: Merges the training and the test sets to create one data set
#
x <- union_all(testX, trainX)
y <- union_all(testY, trainY)
subject <- union_all(testSubject, trainSubject)

#
# Uses descriptive activity names to name the activities in the data set
#
y <- mutate(y, activity=activities[code,2])

#
# Finish: Merges the training and the test sets to create one data set
#
data <- cbind(subject, y, x)

#
# Extracts only the measurements on the mean and standard deviation for each measurement
#

selectedData <- select(data, sub, code, activity, contains("mean"), contains("std"))

#
# Appropriately labels the data set with descriptive variable names
#

names(selectedData) <- gsub("^t", "time", names(selectedData))
names(selectedData) <- gsub("^f", "frequency", names(selectedData))
names(selectedData) <- gsub("Acc", "Accelerometer", names(selectedData))
names(selectedData) <- gsub("Gyro", "Gyroscope", names(selectedData))
names(selectedData) <- gsub("Mag", "Magnitude", names(selectedData))
names(selectedData) <- gsub("Freq", "Frequency", names(selectedData))
names(selectedData) <- gsub("tBody", "TimeBody", names(selectedData))

#
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
#

grp <- group_by(selectedData, sub, activity)
tiddyData <- summarize_at(grp, vars(timeBodyAccelerometer.mean...X:frequencyBodyBodyGyroscopeJerkMagnitude.std..), mean, na.rm=TRUE)
write.table(tiddyData, file="submission.txt", row.names=FALSE)
