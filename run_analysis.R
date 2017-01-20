setwd("/Users/simpson/Desktop/Coursera/Data Science/Course 3 Getting and Cleaning Data/Assignment/Week 4")

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")

# Reading trainings tables:
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Reading Testing table:
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Reading Feature Table
features <- read.table("./data/UCI HAR Dataset/features.txt")

# Reading Activity labels
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

#Assigning Column Names
colnames(x_train) <- features[,2]
colnames(y_train) <- "activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2]
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activity_labels) <-c("activityId", "activityType")

# Merging the dataset

train_data <- cbind(subject_train,x_train,y_train)
test_data <- cbind(subject_test,x_test,y_test)
merged_data <- rbind(train_data,test_data)

colNames <- colnames(merged_data)

mean_and_std <- (grepl("activityId" , colNames) | 
                     grepl("subjectId" , colNames) | 
                     grepl("mean.." , colNames) | 
                     grepl("std.." , colNames) 
)
setForMeanAndStd <- merged_data[ , mean_and_std == TRUE]
setWithActivityNames <- merge(setForMeanAndStd, activity_labels,by = 'activityId',all.x=TRUE)

Tidy_data <- aggregate(. ~subjectId + activityId, setWithActivityNames,mean)

Tidy_data <- Tidy_data[order(Tidy_data$subjectId, Tidy_data$activityId),]

write.table(Tidy_data, "Tidy_data.txt", row.name=FALSE)
write.csv(Tidy_data, "Tidy_data.csv")
