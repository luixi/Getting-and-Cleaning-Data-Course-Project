# Getting-and-Cleaning-Data-Course-Project
Getting and Cleaning Data Course Project for the Coursera Getting and Cleaning Data Course

This project was done utilizing the data collected from the accelerometers from the Samsung Galaxy S smartphone.
The first thing done was download the data from the following link: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
it contains a zip file with all the necessary information.

To understand the information better and to learn about the context of the data, I read the original description of the project in the following link:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

After downloading the data, the first thing I did was to read the Readme file inside of the zip, to understand what everything meant.
After a thorough read, I loaded the relevant files to R utilizing the function fread from the library data.table.
The only files I needed were:
  From the test data: X_test, Y_test, subject_test
  From the train data: X_train, Y_train, subject_train
  activity_labels was used to correctly describe each activity, which came in the Y files
  features wsa used to describe the different variables in the dataset in the X files
 
Having all the necessary files loaded, first I used the function colnames() to assign the variable names that came in the fetures text file, to both the x_train and x_test.
Since they both had the same dimensions, features had 561 rows and the X files had 561 columns, it was obvious to me these features were the descriptions of the files.
Since I already had the columns named, I could take only the ones that were relevant to the mean and standard deviation.
To do this, I utilized the functions select() and matches(), both from the dplyr package, to only select the column names that had either: mean(), std() or meanFreq() in their name. I utilized the ignore.case as FALSE since I wanted to match exactly the letter case used. This is because there were other column names that included the word mean in different cases but were not relevant to the actual average.

Having done that, I changed the column names of the subject files to be Subject_ID, As well as changing the column names of the Y files to Activity_ID to be more descriptive.
These only contained numbers that corresponded to the IDs of the different subjects that were part of the data and the different IDs of the activities observed.
For the activity_lables file, since it had two columns, they were named Activity_ID for the column of IDs and Activity_Description for the column of the actual activities done.

Now that everything was correctly described and every column had its correct name, the next step was to merge all of the datra together in a single table.
First I created the train_set utilizing cbind() to the subject_train, y_train and x_train files, to connect them by column.
The same thing was done to the test files, test_set was created by utilizing cbind(_ on the subject_test, y_test and x_test.

Afterwards merged_set was created by utilzing rbind() on the test_set and train_set.
The final step to make it tidy, was to merge the activity lables to the corresponding activity ID. Utilizing the activity_lables file I used the merge() function with the previously created merged_set and matched every eactivity by its ID. This step was done at the very end because the merge() function rearranges the data.
The resulting tidy set was a a table of 10299 rows * 82 columns, with no NAs.

The last step of the project was to create a new tidy data set with the average of each variable for each activity and each subject.
To do this, I first utilized the group_by function from the dplyr library to group the information by Subject_ID and Activity_Description. This was done to create a grouped table and to be able to utilize the summarize function, also from dplyr library.
Since I wanted to summarize all columns and get the average per variable, inside of the summarize() function, I utilized the across(everything(),list(mean), to get the average of each column.
The new resulting tidy set had a the information by Subject ID (1 to 30) and activity description (6 activities), resulting in 180 rows and the average for each variable, resulting in 82 columns total.
