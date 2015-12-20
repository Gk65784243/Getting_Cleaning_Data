# Import the dplyr library
library(dplyr)
#install.packages("dplyr")
# Reading the X test dataset


# Put your workspace 
#setwd( "?")

x.test <- read.csv("./UCIHARDataset/test/X_test.txt", sep="",
                   header=FALSE)

# printing Dimensions of dataset
#dim(x.test) 
#str(x.test)
# x.test 

# Reading the test labels


y.test <- read.csv("./UCIHARDataset/test/y_test.txt", sep="",
                   header=FALSE)
# printing dimensions of dataset
#dim(y.test) 
#str(y.test)

# Rest in the test subject dataset
subject.test <- read.csv("./UCIHARDataset/test/subject_test.txt",
                         sep="", header=FALSE)
#dim(subject.test)
#str(subject.test)
# subject.test


# Merging   test datasets into a single dataframe
test <- data.frame(subject.test, y.test, x.test)

#dim(test) 
#str(test)

# Reading in the X training dataset

x.train <- read.csv("./UCIHARDataset/train/X_train.txt", sep="",
                    header=FALSE)


#dim(x.train) 
# Read in the training labels
y.train <- read.csv("./UCIHARDataset/train/y_train.txt", sep="",
                    header=FALSE)
#dim(y.train) 
# Read in the training subject dataset
subject.train <- read.csv("./UCIHARDataset/train/subject_train.txt",
                          sep="", header=FALSE)
#dim(subject.train) 
#head(subject.train )
#summary(subject.train )
#table(subject.train$V1)
#attributes(subject.train)
#attributes(subject.train$V1)
#attributes(subject.train["v1"])
#subject.train["V1"]
#names(subject.train)
#class(subject.train )

# Merging test training datasets into a single dataframe
train <- data.frame(subject.train, y.train, x.train)
#dim(train)

#  train dataframe has 7352 rows

# Combine the training and test running datasets
run.data <- rbind(train, test)
#dim(run.data )
# Remove the files we don't need anymore from
# the environment.

# colnames(run.data)
#dim(run.data)


# rund.data dataframe  has 10299 rows


# remove old dataframes, not neede anymore
remove(subject.test, x.test, y.test, subject.train,
       x.train, y.train, test, train)

# Read in the measurement labels dataset
features <- read.csv("./UCIHARDataset/features.txt", sep="", header=FALSE)
# Convert the 2nd column into a vector
#features
#dim( features)
#str(features)
#table(features$V2)
#features[2,2]
column.names <- as.vector(features[, 2])
#column.names 


# Apply the measurement labels as column names to the combined
# running dataset
colnames(run.data) <- c("subject_id", "activity_labels", column.names)

# Select only the columns that contain mean or standard deviations.
# Make sure to bring along the subject and label columns.
# Exclude columns with freq and angle in the name.

# delete Duplicates

run.data <- run.data[ !duplicated(names(run.data)) ]
run.data <- select(run.data, contains("subject"), contains("label"),
                   contains("mean"), contains("std"), -contains("freq"),
                   -contains("angle"))


#dim(run.data)

#dim(run.data)
#colnames(run.data)


# Read in the activity labels dataset
activity.labels <- read.csv("./UCIHARDataset/activity_labels.txt", 
                            sep="", header=FALSE)
#dim(activity.labels)

#activity.labels


# Replace the activity codes in the trimmed down running
# dataset with the labels from the activity labels dataset.
run.data$activity_labels <- as.character(activity.labels[
  match(run.data$activity_labels, activity.labels$V1), 'V2'])

#?match
# the natch function will search a vector for a particular value and return teh position
#dim(run.data)


# make transformation of colnames needed
colnames(run.data) <- gsub("\\(\\)", "", colnames(run.data))
# setNames(run.data, colnames(run.data), gsub("\\(\\)", "", colnames(run.data)))
colnames(run.data) <- gsub("-", "_", colnames(run.data))
# setnames(run.data, colnames(run.data), gsub("-", "_", colnames(run.data)))
colnames(run.data) <- gsub("BodyBody", "Body", colnames(run.data))
# setnames(run.data, colnames(run.data), gsub("BodyBody", "Body", colnames(run.data)))


# gsub perform replacement of the first and all matches respectively.

# Group the running data by subject and activity, then
# calculate the mean of every measurement.
run.data.summary <- run.data %>%
  group_by(subject_id, activity_labels) %>%
  summarise_each(funs(mean))
#colnames(run.data)


# Write run.data to file

write.table(run.data.summary, file="run_data_summary.txt", row.name=FALSE)

