## Getting and Cleaning Data Project
Joel Modisette

### Description
Additional information about the variables, data and transformations used in the course project for the Johns Hopkins Getting and Cleaning Data course.

### Variables

561 variables from SmartPhone data acquired from subjects (30) performing various activities (6).
Variables are described by their specific accelerometer/gyroscope measurements.

For each record in the dataset it is provided: 
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

 The only variables of interest are those involving mean() and std(). There are 66 of these in the 561 total variables.

### Source Data

Data + Description can be found here [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

### Transformations Used
- The only variables of interest were those that contained the terms mean() or std(). Other variables describing max(), min(), energy(), entropy(), etc. were discarded.
- The original data sets used exponential notation. I transformed exponential notation to double numerical format to support subsequent mathematical functions.
- The data was originally separated into two files: test and train. Test and Train contained data on the same 30 subjects performing the same 6 activities. These were combined into one data set.
- Subject, Activity, and Variable data was also separated for test data and train data. These were combined appropriately to create a single data set that listed, for each subject and activity, and the 66 recorded variables. 
- The combined data set was written to a TidyData.txt file following Tidy Date norms.
- The data was also grouped by subject, activity and the variable data for the groupings was summarized with a mean.
