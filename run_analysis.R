library(dplyr)
library(data.table)

#Use data table fread to read the test data text files
x_test<-data.table::fread("UCI HAR Dataset/test/X_test.txt")
y_test<-data.table::fread("UCI HAR Dataset/test/Y_test.txt")
subject_test<-data.table::fread("UCI HAR Dataset/test/subject_test.txt")

#Use data table fread to read the train data text files
x_train<-data.table::fread("UCI HAR Dataset/train/X_train.txt")
y_train<-data.table::fread("UCI HAR Dataset/train/Y_train.txt")
subject_train<-data.table::fread("UCI HAR Dataset/train/subject_train.txt")

#Use data table fread to read the activity labels and features text files
activity_labels<-data.table::fread("UCI HAR Dataset/activity_labels.txt")
features<-data.table::fread("UCI HAR Dataset/features.txt")

#assigning the feature names to the columns of the sets
colnames(x_train)<-features$V2
colnames(x_test)<-features$V2

#keep only the column names related to the mean,standard deviation
#and mean frequency
x_train<-select(x_train,matches("mean()|std()|meanFreq()",ignore.case=FALSE))
x_test<-select(x_test,matches("mean()|std()|meanFreq()",ignore.case=FALSE))

#Change the column name to Subject Id to both subject files to be more descriptive
colnames(subject_test)<-"Subject_ID"
colnames(subject_train)<-"Subject_ID"

#Change the column names to y activity files and activity labels to be more 
#descriptive and to later merge without confusion
colnames(y_test)<-"Activity_ID"
colnames(y_train)<-"Activity_ID"
colnames(activity_labels)<-c("Activity_ID","Activity_Description")

#merge the training sets together by columns
train_set<-cbind(subject_train,y_train,x_train)
test_set<-cbind(subject_test,y_test,x_test)

#merge all the sets together
merged_set<-rbind(test_set,train_set)

#merge labels with the corresponding Y file
#done last so reordering of merge function does not matter
merged_set<-merge(activity_labels,merged_set,by.x = "Activity_ID",by.y = "Activity_ID")


#create a new tidy data set with the average of each variable
#for each activity and each subject.
grouped_set<-group_by(merged_set,Subject_ID,Activity_Description)
summarized<-summarize(grouped_set,across(everything(),list(mean)))
