# Coder: Joel Modisette
# Getting and Cleaning Data Project, John Hopkins Coursera

# Objectives of this code:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# These R packages are required. They are all from the TidyVerse family.
#   readr 
#   stringr
#   dplyr
#   data.table   

# Load Packages and download the Data

packages <- c("data.table","readr", "dplyr", "stringr")
sapply(packages, require, character.only=TRUE, quietly=TRUE)
path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(path, "dataFiles.zip"))
unzip(zipfile = "dataFiles.zip")

# Read in the data files as provided.
# There are some duplicate column names in the TestData and TrainData,
# but these dups are not part of the desired columns, so I will ignore.

Activities      <- read_delim(file.path(path, "UCI HAR Dataset/activity_labels.txt")
                     , delim = " " , col_names = c("activityIndex", "activity"))
Features        <- read_delim(file.path(path, "UCI HAR Dataset/features.txt")
                     , delim = " " , col_names = c("featureIndex", "feature"))

TrainData       <- read_table(file.path(path, "UCI HAR Dataset/train/X_train.txt")
                     , col_names = Features$feature, col_types = cols(.default = col_double()))
TrainSubjects   <- read_delim(file.path(path, "UCI HAR Dataset/train/subject_train.txt")
                     , delim = " " , col_names = c("subject"))
TrainActivities <- read_delim(file.path(path, "UCI HAR Dataset/train/y_train.txt")
                     , delim = " " , col_names = c("activityIndex"))


TestData       <- read_table(file.path(path, "UCI HAR Dataset/test/X_test.txt")
                     , col_names = Features$feature, col_types = cols(.default = col_double()))
TestSubjects   <- read_delim(file.path(path, "UCI HAR Dataset/test/subject_test.txt")
                     , delim = " " , col_names = c("subject"))
TestActivities <- read_delim(file.path(path, "UCI HAR Dataset/test/y_test.txt")
                     , delim = " " , col_names = c("activityIndex"))

# Build a numerical vector with the positions of the column names that contain words 
# mean or standard deviation.   

MeanStd_Features <- Features %>% 
                      filter(str_detect( feature, ( pattern = ("(mean|std)\\(\\)") ))) %>%  
                      pull(var = featureIndex)       #we just need the index of the columns 

# Reduce the raw data files to only the data columns selected above.

TrainData <- TrainData %>%
            select(MeanStd_Features)
TestData <- TestData %>%
            select(MeanStd_Features)
 
# Now incrementally build the individual data sets in sequence: Subject-Activity-Data.

TrainSet <- right_join(TrainActivities, Activities) 
TrainSet <- bind_cols(TrainSubjects, TrainSet, TrainData)
TrainSet <- TrainSet %>% 
               arrange(subject, activityIndex)

TestSet <- right_join(TestActivities, Activities) 
TestSet <- bind_cols(TestSubjects, TestSet, TestData)
TestSet <- TestSet %>% 
               arrange(subject, activityIndex)

CompleteSet <- TrainSet %>%
                  add_row(TestSet) %>% 
                  arrange(subject, activityIndex)

MeanCompleteSet <- CompleteSet %>% 
                      group_by(subject, activity) %>%  
                      summarise(across(everything(), mean)) %>% 
                      arrange(subject, activityIndex) %>% 
                      select(-activityIndex)          #remove the index column

# and let's remove the activity index column in the final output file and write out.

CompleteSet <- CompleteSet %>% select(-activityIndex)

write_delim(CompleteSet, file.path(path, "TidyData.csv"), delim = ",")

# now write the final output exactly as specified by the project instructions.

write.table(CompleteSet, file = "TidyData.txt", row.names = FALSE)
