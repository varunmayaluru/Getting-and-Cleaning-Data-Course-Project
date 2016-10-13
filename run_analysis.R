# Getting and Cleaning data Peer graded assignment

# Set working directory

setwd("~/Coursera/3. Getting an cleaning data")

# Create Week 4 directory

if(!file.exists("./Week 4")){
        dir.create("./Week 4")
}

# set working directory as Week 4

setwd(file.path(getwd(),"Week 4"))


# Download the required data

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(url = url, destfile = "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" )

unzip("getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")

# Set working directory

setwd("~/Coursera/3. Getting an cleaning data/Week 4/UCI HAR Dataset")

# Import features and activity lables

features <- read.table("features.txt")

# As features so obtained as rownumber as seperate variable obtain the second column as variable names

features <- as.character(features[,2])

activity_labels <- read.table("activity_labels.txt")

# As activity_labels so obtained as rownumber as seperate variable obtain the second column 
# as activity_labels names

activity_labels <- activity_labels[,2]

# Train dataset

subject_train <- read.table("train/subject_train.txt")

train <- read.table("train/X_train.txt")

train_labels <- read.table("train/y_train.txt")

Train <- cbind(subject_train,train_labels,train)

# Test dataset

subject_test <- read.table("test/subject_test.txt")

test <- read.table("test/X_test.txt")

test_labels <- read.table("test/y_test.txt")

Test <- cbind(subject_test,test_labels,test)

# 1. rbind of Train and Test datasets 

fullData <- rbind(Train,Test)

colnames(fullData) <- c("Subject","Activity",features)

# 2. Extracts only the measurements on the mean and standard deviation for each 
# measurement.

varnames <- names(fullData)

vars_required <- grep(".*-mean().*| .*-std().*",varnames)

Data <- cbind(fullData[,c(1,2)],fullData[,vars_required])

# 3. Uses descriptive activity names to name the activities in the data set

Data$Activity <- factor(Data$Activity, levels = c(1,2,3,4,5,6), labels = activity_labels)


# 4. Appropriately labels the data set with descriptive variable names.

colNames <-names(Data)

colNames = gsub('-mean', 'Mean', colNames)
colNames = gsub('-std', 'Std', colNames)
colNames <- gsub('[-()]', '', colNames)

colnames(Data) <- colNames

# Convert the categorical variables into factors as they have fixed values

Data$Subject <- factor(Data$Subject, levels = c(1:30))


# 5. From the data set in step 4, creates a second, independent tidy data set with 
# the average of each variable for each activity and each subject.

library(reshape2)

meltData <- melt(Data, id.vars = c("Subject","Activity"))

# Average for each variable and each activity

finalData <- dcast(meltData, Subject + Activity ~ variable, mean)

# Submission file

write.table(finalData, "tidy.txt", row.names = F)





























































































