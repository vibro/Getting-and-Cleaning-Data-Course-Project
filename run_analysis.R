#Create one R script called run_analysis.R that does the following.
 
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each 
#   measurement. 
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names. 
#5. From the data set in step 4, creates a second, independent tidy data set 
#   with the average of each variable for each activity and each subject.


library(plyr)


#Load data

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)
features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt", header = FALSE)

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt", header = FALSE)

#Assign column names

colnames(x_train) <- features[, 2]
colnames(x_test) <- features[, 2]

colnames(y_train) <- "activity_id"
colnames(y_test) <- "activity_id"

colnames(subject_train) <- "subject_id"
colnames(subject_test) <- "subject_id"

colnames(activity_labels) <- c("activity_id", "activity_label")

#Replace activity ids with activity labels

y_train <- data.frame(join(y_train, activity_labels, by = "activity_id")[, 2])
y_test <- data.frame(join(y_test, activity_labels, by = "activity_id")[, 2])

colnames(y_train) <- "activity_label"
colnames(y_test) <- "activity_label"

#Create combined test and training datasets

train_data <- cbind(subject_train, y_train, x_train)
test_data <- cbind(subject_test, y_test, x_test)

#Combine test and training datasets

all_data <- rbind(train_data, test_data)

#Subset columns with measurements of mean and standard deviation

all_data <- all_data[, grep("mean|std|activity|subject", colnames(all_data))]
all_data <- all_data[, -grep("meanFreq", colnames(all_data))]

#Clean column names

descriptive_names <- colnames(all_data)

descriptive_names <- gsub("^t", "Time_", descriptive_names)
descriptive_names <- gsub("^f", "Frequency_", descriptive_names)
descriptive_names <- gsub("Acc", "Acceleration", descriptive_names)
descriptive_names <- gsub("Gravi", "Gravity", descriptive_names)
descriptive_names <- gsub("Mag", "Magnitude", descriptive_names)

colnames(all_data) <- descriptive_names

