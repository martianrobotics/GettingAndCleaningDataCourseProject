## Merges the training and the test sets to create one data set.
## Extracts only the measurements on the mean and standard deviation for each measurement.
## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive variable names.
## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


if(!(file.exists("UCI HAR Dataset")))
	stop("The folder 'UCI HAR Dataset' could not be located.  Please download and unzip the required data here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")
	
#----- Step 1
#load data
print("Loading test data.....");flush.console()
theFile<-".//UCI HAR Dataset//test//X_test.txt"
if(file.exists(theFile)) x_test<-read.table(theFile,sep="",header=FALSE) else stop("X_test missing.")
theFile<-".//UCI HAR Dataset//test//y_test.txt"
if(file.exists(theFile)) y_test<-read.table(theFile,sep="",header=FALSE) else stop("y_test missing.")
theFile<-".//UCI HAR Dataset//test//subject_test.txt"
if(file.exists(theFile)) subject_test<-read.table(theFile,sep="",header=FALSE) else stop("subject_test missing.")

print("Loading train data....");flush.console()
theFile<-".//UCI HAR Dataset//train//X_train.txt"
if(file.exists(theFile)) x_train<-read.table(theFile,sep="",header=FALSE) else stop("X_train missing.")
theFile<-".//UCI HAR Dataset//train//y_train.txt"
if(file.exists(theFile)) y_train<-read.table(theFile,sep="",header=FALSE) else stop("y_test missing.")
theFile<-".//UCI HAR Dataset//train//subject_train.txt"
if(file.exists(theFile)) subject_train<-read.table(theFile,sep="",header=FALSE) else stop("subject_train missing.")

theFile<-".//UCI HAR Dataset//features.txt"
if(file.exists(theFile)) features<-read.table(theFile,sep="",header=FALSE) else stop("features.txt missing.")

#rename columns 1:2
print("Renaming subject and activity columns....");flush.console()
colnames(subject_test)[colnames(subject_test)=="V1"]<-"subject"
colnames(subject_train)[colnames(subject_train)=="V1"]<-"subject"
colnames(y_test)[colnames(y_test)=="V1"]<-"activity"
colnames(y_train)[colnames(y_train)=="V1"]<-"activity"



#Bind columns of test and train
print("Binding test columns....");flush.console()
test<-cbind(subject_test,y_test,x_test)
print("Binding train columns....");flush.console()
train<-cbind(subject_train,y_train,x_train)

#merge test and train
print("Merging test and train data....");flush.console()
all<-rbind(test,train)
#end of step 1


#------ step 2
# Extracts only the measurements on the mean and standard deviation for each measurement.
#apply features.txt to all(v1+2:v561+2)
#features contains names of x_test,x_train
#Clean it up to be more readable


#create a vector of names from the 2nd column of features
allColNames<-as.character(features[[2]])

#apply step 4 here to allColNames
# t to time, f to freq
# remove -(), etc
# letters, numbers and points only
# in order: 1) f-wholeword, 2) t-wholeword, 3), capitalize mean and std, 4) dots and alphanumeric only 
print("Cleaning up column names....");flush.console()
allColNames<-gsub("(-[a-z])","\\U\\1",allColNames,perl=TRUE) # capitalize characters after "-"
allColNames<-gsub("^f","freq",allColNames,perl=TRUE) # f to freq
allColNames<-gsub("^t","time",allColNames,perl=TRUE) # t to time
allColNames<-gsub("(mean)|(std)","\\U\\1",allColNames,perl=TRUE) # capitalize mean and std
allColNames<-gsub("(,)",".",allColNames,perl=TRUE) # replace "," with "."
allColNames<-gsub("[()-]",".",allColNames,perl=TRUE) # replace ()- with .
allColNames<-gsub("[\\.]+",".",allColNames,perl=TRUE) # replace multiple . with one .
allColNames<-gsub("\\.$","",allColNames,perl=TRUE) # remove . at the end of string

#apply allColNames as column names of all[3:563] (first two are subject and activity)
names(all)[3:563]<-allColNames

#extract std and mean
print("Extractubg std and mean....");flush.console()
stdAndMean<-all[,grepl("Std|Mean",colnames(all))]

print("Binding....");flush.console()
x<-cbind(all[1:2],stdAndMean)


#------ step 3 
#replace values of activity with labels
activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt",sep="",header=FALSE)
actlbls<-as.character(activity_labels[[2]])

#------ step 5
if(!("package:dplyr" %in% search()))
	install.packages("dplyr")
library(dplyr)
x<-mutate(x,activity=actlbls[activity])
xx<-group_by(x,subject,activity)
tidydata<-summarize_each(xx,funs(mean),3:88)
print("Creating tidy data....");flush.console()
tidyDataFilename<-"TidyData.txt"
write.table(tidydata,tidyDataFilename);
cat("Tidy data written to ",tidyDataFilename)