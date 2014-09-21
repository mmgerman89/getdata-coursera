# Download and extract data
# fileUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# if (!file.exists("./data")) {dir.create("./data")}
# download.file(fileUrl, destfile="./data/project.zip",method="curl")
# unzip("./data/project.zip", exdir="./data")


# Merges training and test (Step 1)
xTest <- read.table(file="./data/UCI HAR Dataset/test/X_test.txt",header=F)
yTest <- read.table(file="./data/UCI HAR Dataset/test/y_test.txt", header=F)
subjectTest <- read.table(file="./data/UCI HAR Dataset/test/subject_test.txt", header=F)

xTrain <- read.table(file="./data/UCI HAR Dataset/train/X_train.txt",header=F)
yTrain <- read.table(file="./data/UCI HAR Dataset/train/y_train.txt", header=F)
subjectTrain <- read.table(file="./data/UCI HAR Dataset/train/subject_train.txt", header=F)

test <- cbind(xTest, subjectTest, yTest)
train <- cbind(xTrain, subjectTrain, yTrain)

data <- rbind(train, test)


# Appropiately labels the data set (Step 4)
features <- read.table("./data/UCI HAR Dataset/features.txt", header=F)
colnames(data) <- c(as.character(features$V2),"Subject", "Activity")


# Extracts only the mean and std for each measurement (Step 2)
data <- data[c(grep("mean\\(\\)|std\\(\\)", features$V2),562,563)]


# Uses descriptive activity names (Step 3)
data$Activity[data$Activity == 1] <- "WALKING"
data$Activity[data$Activity == 2] <- "WALKING_UPSTAIRS"
data$Activity[data$Activity == 3] <- "WALKING_DOWNSTAIRS"
data$Activity[data$Activity == 4] <- "SITTING"
data$Activity[data$Activity == 5] <- "STANDING"
data$Activity[data$Activity == 6] <- "LAYING"


# Create a tidy data set with avarage of each variable for each activity and each subject (Step 5)
library(plyr)
data <- data[order(data$Subject,data$Activity),]

data$Subject <- as.factor(data$Subject)
data$Activity <- as.factor(data$Activity)
tidy <- aggregate(data, by=list(actvity=data$Activity, subject = data$Subject), mean)
tidy <- tidy[,1:68]

write.table(tidy,file="./data/tidy.txt", row.name=F)
