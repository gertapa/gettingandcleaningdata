#Getting and Cleaning Data CodeBook

The code book describes the variables, data, and transformations performed to clean up the data 

##Data

The data in the `results.csv` file contains mean and standard deviation values measured during different activities. The activities can be found in the `activity` column:
* WALKING
* WALKING_UPSTAIRS
* WALKING_DOWNSTAIRS
* SITTING
* STANDING
* LAYING

The column names apart from the `activity` have the following format:
`BODY_OR_GRAVITY`.`TYPE_OF_MEASURE`.`TIME_OR_FREQUENCY`.`FUNCTION`.`AXIS`
e.g. body.gyroscope.jerk.bytime.sd.x


* `BODY_OR_GRAVITY`: Columns that start with `body` contain body acceleration signals, Columns that start with `gravity` contain gravity acceleration signals.
* `TYPE_OF_MEASURE`: Columns with the value `acceleration` contain measurements from an accelerometer, the value `gyroscope` stands for measurements from an gyroscope. If the type ends with an `.jerk` this means that the columns contains Jerk signals of either acceleration or gyroscope.
* `TIME_OR_FREQUENCY`: values collected either over `time` with a rate of 50 Hz or over `frequency` where a Fast Fourier Transform was used to calculate the values.
* `FUNCTION`: The function that was used to calculate the data. This can be `mean` for mean or `sd` for standard deviation.
* `AXIS`: is the axis on which the value was measured.


##Data grouped by activity

The features in the grouped data file `activity_results.csv` are the same as above with the difference that all the values are grouped by the activity. That means each activity makes up one row in the data set and values for the features are the average values calculated for each activity.

## Getting the Data

The raw data is downloaded from [archive.ics.uci.edu](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) at the start of the analysis.

## Processing the Data

In order to clean up the data we perform the following steps:

 1. Downloading the data
 2. Adding the feature names to the data sets for training an test
 3. Adding the activity names to the data sets
 4. Merging the test and training set
 5. Selecting only columns with mean and standard deviation features
 6. Renaming column names to a format that is easier to understand
 7. Grouping the data by acceleration
 8. Writing the data sets to files
