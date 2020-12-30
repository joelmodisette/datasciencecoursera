# Getting and Cleaning Data Project
Student: Joel Modisette

## Project Instructions 
1. Merge the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Project Deliverables
Plain Name | Filename | Link to Item
--- | --- | ---
Analysis R Script |  run_analysis.R |  [R Script Link](https://github.com/joelmodisette/datasciencecoursera/blob/master/Course3_Get_Clean_Data/Project/run_analysis.R "run_analysis.R")
Tidy Data Set |  TidyData.txt |  [Data Set Link](https://github.com/joelmodisette/datasciencecoursera/blob/master/Course3_Get_Clean_Data/Project/TidyData.txt "tidyData.txt")
Github Repo | Repo Submitted for Project |  [Repo Link](https://github.com/joelmodisette/datasciencecoursera/tree/master/Course3_Get_Clean_Data/Project "Repo Link submitted to Coursera")
Cookbook | CodeBook.md |  [Markdown Link](https://github.com/joelmodisette/datasciencecoursera/blob/master/Course3_Get_Clean_Data/Project/CodeBook.md "CodeBook.md")
README | README.md  |  [Markdown Link](https://github.com/joelmodisette/datasciencecoursera/edit/master/Course3_Get_Clean_Data/Project/README.md "README.md")

## Script Functionality
I used the TidyVerse R Packages for my script. I find TidyVerse creates a more readable and logical flow. My primary references were:
Resource | Author(s) | Link to Resource
--- | --- | ---
Introduction to Tidyverse : readr, tibbles, tidyr & dplyr | Brian Ward | https://medium.com/@brianward1428/introduction-to-tidyverse-7b3dbf2337d5
R Studio::Conf 2019 / Cheatsheets | Various | https://rstudio.com/wp-content/uploads/2019/01/Cheatsheets_2019.pdf

No other scripts are required. The submitted script follows these steps in order:
1. Setup: Load packages, establish directory paths, download and unzip data package.
2. Read in Data: Each data file is read into a data frame, as is. No modifications.
3. Filter for only the variables needed: mean() and std().
4. Reduce the data sets to only the required variables.
5. Incrementally build the individual data sets for the train and test data in this sequence: Subject-Activity-Data.
6. Combine and Summarize: Combine test and train data set into one complete set. Also, summarize the groupings in this complete set.
7. Write out the complete data set to a csv file following Tidy Data Protocol.
