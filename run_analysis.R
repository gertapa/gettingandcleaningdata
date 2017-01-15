
# remove load required libraries
library(dplyr)


# run the script for cleaning up the data. It will download the file from 
# the internet and clean it as described in the CodeBook.md file.
runAnalysis <- function() {
    
    # download the data and extract the required files from the zip
    data <- downloadAndExtractData()

    print("Processing data ...")
    
    # 3. Uses descriptive activity names to name the activities in the data set
    data <- addActivityLabels(data)
    
    
    # 1. Merges the training and the test sets to create one data set.
    data <- rbind(data$testResults, data$trainingResults)
    data <- tbl_df(data)
    
    # 2. Extracts only the measurements on the mean and standard deviation for each measurement
    data <- data %>% 
        select(matches("(.*-(mean|std)\\(\\)-.*)|activity")) # extract mean and standard deviation values, 
                                                             # keep activity column
    
    # 4. Appropriately labels the data set with descriptive variable names.
    data <- prettifyColumnNames(data)
    
    
    # 5. From the data set in step 4, creates a second, independent tidy data set with the 
    # average of each variable for each activity and each subject
    groupedData <- data %>% group_by(activity) %>% summarise_each(funs(mean))
    
    
    # save results as csv file
    write.csv(data,        file = "results.csv")
    write.csv(groupedData, file = "activity_results.csv")
    
    print("Finished analysis. Result exported to files results.csv and activity_results.csv")

    # return both results as list
    list(data = data, groupedData = groupedData)
}

# add the activities as lables as separate columns to the test and training data set
addActivityLabels <- function(data) {
    
    activityLabels <- data$activityLabels
    
    data$testResults$activity     = activityLabels$label[activityLabels$index[data$testActivities]]
    data$trainingResults$activity = activityLabels$label[activityLabels$index[data$trainingActivities]]
    
    data
}

# this function converts the column names of the data into a normalzed
# and more descriptive for by lower casing them and replacing some
# abbreviations with their long form
prettifyColumnNames <- function(data) {
    
    # make everything lower case
    names(data) = tolower(names(data))
    
    # remove numbers from name
    names(data) = sub("^[0-9]{1,3} ", "", names(data))
    
    # remove other special character like -, ( or ) from the name
    names(data) = sub("-mean\\(\\)-", ".mean.", names(data))
    names(data) = sub("-std\\(\\)-",  ".sd.",   names(data))
    
    # separate with dot for better readability
    names(data) = sub("body",    "body.",    names(data))
    names(data) = sub("gravity", "gravity.", names(data))
    names(data) = sub("jerk",    ".jerk",    names(data))
    
    # replace abbreviations with fill names for better understanding
    names(data) = sub("acc",  "acceleration", names(data))
    names(data) = sub("gyro", "gyroscope",    names(data))
    
    # replace t and f with descriptive text
    names(data) = sub("^t(.*)\\.(mean|sd)\\.(.*)$", "\\1.bytime.\\2.\\3",      names(data))
    names(data) = sub("^f(.*)\\.(mean|sd)\\.(.*)$", "\\1.byfrequency.\\2.\\3", names(data))
    
    data
}


# download the data file from the internet and extract the datasets for
# test and training data directly from the zip file with the unz command.
# Returns a list with all data extracted from the ZIP file.
downloadAndExtractData <- function() {
    
    print("Downloading data ...")
    
    # create a temporary file where we temporarily store the downloaded zip file
    temp <- tempfile()
    
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                  temp)
    
    print("Reading data ...")
    
    testResults    <- read.table(unz(temp,   "UCI HAR Dataset/test/X_test.txt"))
    testActivities <- readLinesFromZip(temp, "UCI HAR Dataset/test/y_test.txt")
    
    trainingResults    <- read.table(unz(temp,   "UCI HAR Dataset/train/X_train.txt"))
    trainingActivities <- readLinesFromZip(temp, "UCI HAR Dataset/train/y_train.txt")
    
    activityLabels <- read.table(unz(temp,   "UCI HAR Dataset/activity_labels.txt"), 
                                 col.names = c("index", "label"))
    features       <- readLinesFromZip(temp, "UCI HAR Dataset/features.txt")
    
    unlink(temp)
    
    # set column names from the features list file
    names(testResults)     = features
    names(trainingResults) = features
    
    # return the list of extracted data
    list(testResults     = testResults,     testActivities     = as.integer(testActivities), 
         trainingResults = trainingResults, trainingActivities = as.integer(trainingActivities),
         activityLabels  = activityLabels)
}

# helper function that reads lines from a file in the zip and closes
# the connection afterwards in order to avoid warnings about not closind the 
# connection
readLinesFromZip <- function(zipfile, filename) {
    file     <- unz(zipfile, filename)
    fileData <- readLines(file)
    close(file)
    
    fileData
}