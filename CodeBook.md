CodeBook
=======
Describes the variables, the data, and any transformations or work performed to clean up the data.
-----------
Original dataset: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
-----------

### Load the data

* X_test loads from test/X_test.txt
* y_test loads from test/y_test.txt
* subject_train loads from train/subject_train.txt
* X_train loads from train/X_train.txt
* y_train loads from train/y_train.txt
* features from features.txt
* activity_labels from activity_labels.txt

### Rename columns, bind datasets, and combine test and train data

Rename the column names of subject_test and y_test as subject and activity.  Also applies to the subject_test and y_test datasets. 

Bind the subject_test, y_test, and x_test tables
test <-cbind(subject_test,y_test,x_test)

Bind the subject_train, y_train, and x_train tables
train<-cbind(subject_train,y_train,x_train)

Combine the test and train data sets with the rbind function into the data.frame named "all"
all<-rbind(test,train)

### Extract column names

Extract all rows of the 2nd column of features as allColNames.
allColNames will eventually be the column names of the all data.frame from 3:563.  
allColNames<-as.character(features[[2]])

### Clean up column names using regular expressions

Apply the contents of features.txt to a data.frame called features.
The following steps will be applied to the list:
* capitalize characters after "-"
* convert f to freq
* convert t to time
* capitalize mean and std
* replace "," with "."
* replace (,),- with .
* replace multiple . with one .
* remove . at the end of string

Apply the cleaned up list as the column names of the "all" data.frame from columns 3:563. The first two columns are subject and activity.

names(all)[3:563]<-allColNames

Now that the all data.frame has proper column names, extract all columns that contain "mean" and "std" into stdAndMean.

stdAndMean<-all[,grepl("Std|Mean",colnames(all))]

Create a new data.frame called x that binds the first two columns of all and the extracted standard deviation and mean columns.

x<-cbind(all[1:2],stdAndMean)

### Apply the proper activity labels to the activity column
Use the mutate function of the dplyer library to replace numeric data in the activity column of the x dataframe with the proper activity labels
x<-mutate(x,activity=actlbls[activity])

* 1 will be replaced by "WALKING"
* 2 will be replaced by "WALKING_UPSTAIRS"
* 3 will be replaced by "WALKING_DOWNSTAIRS"
* 4 will be replaced by "SITTING"
* 5 will be replaced by "STANDING"
* 6 will be replaced by "LAYING" 

### Summarize
Use the group_by function to arrange x by subject and then by activity.  Store the new dataframe as xx.
xx<-group_by(x,subject,activity)

Use the summarize_each function to apply mean function to each group in the previous step.  Store the new dataframe as tidydata.
tidydata<-summarize_each(xx,funs(mean),3:88)

Finally, write the tidydata table to "TidyData.txt"

write.table(tidydata,tidyDataFilename);

###Variables

subject
- from original data set - an identifier of the subject that carried out the experiment.

activity
- from original data set - the activity the subject participated in which measurements were taken. these include walking, walking upstairs/downstairs, sitting, standing

Variables derived from original dataset
---------------------------------------

'mean' was prepended to denote that mean value was computed for all variables across all experiments for each group (subject, activity)

* Acc/Gyro= accelerometer and gyroscope sensors used in experiments
* Time=time domain signal
* Body/Gravity= the acceleration signal was then separated into body and gravity acceleration signals (meanTimeBodyAccXYZ and meanTimeGravityAccXYZ)
* Jerk=the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (meanTimeBodyAccJerkXYZ and meanTimeBodyGyroJerkXYZ)
* Mag=the magnitude of these three-dimensional signals were calculated using the Euclidean norm (meanTimeBodyAccMag, meanTimeGravityAccMag, meanTimeBodyAccJerkMag, meanTimeBodyGyroMag, meanTimeBodyGyroJerkMag).
* Frequency=finally, Fast Fourier Transform (FFT) was applied to some of these signals producing meanFrequencyBodyAccXYZ, meanFrequencyBodyAccJerkXYZ, meanFrequencyBodyGyroXYZ, meanFrequencyBodyAccJerkMag, meanFrequencyBodyGyroMag, ,meanFrequencyBodyGyroJerkMag
* XYZ=denotes 3-axial raw signals in the X, Y and Z directions

All measurements are in Hz

"subject"                             "activity"                           
"timeBodyAcc.Mean.X"                  "timeBodyAcc.Mean.Y"                 
"timeBodyAcc.Mean.Z"                  "timeBodyAcc.Std.X"                  
"timeBodyAcc.Std.Y"                   "timeBodyAcc.Std.Z"                  
"timeGravityAcc.Mean.X"               "timeGravityAcc.Mean.Y"              
"timeGravityAcc.Mean.Z"               "timeGravityAcc.Std.X"               
"timeGravityAcc.Std.Y"                "timeGravityAcc.Std.Z"               
"timeBodyAccJerk.Mean.X"              "timeBodyAccJerk.Mean.Y"             
"timeBodyAccJerk.Mean.Z"              "timeBodyAccJerk.Std.X"              
"timeBodyAccJerk.Std.Y"               "timeBodyAccJerk.Std.Z"              
"timeBodyGyro.Mean.X"                 "timeBodyGyro.Mean.Y"                
"timeBodyGyro.Mean.Z"                 "timeBodyGyro.Std.X"                 
"timeBodyGyro.Std.Y"                  "timeBodyGyro.Std.Z"                 
"timeBodyGyroJerk.Mean.X"             "timeBodyGyroJerk.Mean.Y"            
"timeBodyGyroJerk.Mean.Z"             "timeBodyGyroJerk.Std.X"             
"timeBodyGyroJerk.Std.Y"              "timeBodyGyroJerk.Std.Z"             
"timeBodyAccMag.Mean"                 "timeBodyAccMag.Std"                 
"timeGravityAccMag.Mean"              "timeGravityAccMag.Std"              
"timeBodyAccJerkMag.Mean"             "timeBodyAccJerkMag.Std"             
"timeBodyGyroMag.Mean"                "timeBodyGyroMag.Std"                
"timeBodyGyroJerkMag.Mean"            "timeBodyGyroJerkMag.Std"            
"freqBodyAcc.Mean.X"                  "freqBodyAcc.Mean.Y"                 
"freqBodyAcc.Mean.Z"                  "freqBodyAcc.Std.X"                  
"freqBodyAcc.Std.Y"                   "freqBodyAcc.Std.Z"                  
"freqBodyAcc.MeanFreq.X"              "freqBodyAcc.MeanFreq.Y"             
"freqBodyAcc.MeanFreq.Z"              "freqBodyAccJerk.Mean.X"             
"freqBodyAccJerk.Mean.Y"              "freqBodyAccJerk.Mean.Z"             
"freqBodyAccJerk.Std.X"               "freqBodyAccJerk.Std.Y"              
"freqBodyAccJerk.Std.Z"               "freqBodyAccJerk.MeanFreq.X"         
"freqBodyAccJerk.MeanFreq.Y"          "freqBodyAccJerk.MeanFreq.Z"         
"freqBodyGyro.Mean.X"                 "freqBodyGyro.Mean.Y"                
"freqBodyGyro.Mean.Z"                 "freqBodyGyro.Std.X"                 
"freqBodyGyro.Std.Y"                  "freqBodyGyro.Std.Z"                 
"freqBodyGyro.MeanFreq.X"             "freqBodyGyro.MeanFreq.Y"            
"freqBodyGyro.MeanFreq.Z"             "freqBodyAccMag.Mean"                
"freqBodyAccMag.Std"                  "freqBodyAccMag.MeanFreq"            
"freqBodyBodyAccJerkMag.Mean"         "freqBodyBodyAccJerkMag.Std"         
"freqBodyBodyAccJerkMag.MeanFreq"     "freqBodyBodyGyroMag.Mean"           
"freqBodyBodyGyroMag.Std"             "freqBodyBodyGyroMag.MeanFreq"       
"freqBodyBodyGyroJerkMag.Mean"        "freqBodyBodyGyroJerkMag.Std"        
"freqBodyBodyGyroJerkMag.MeanFreq"    "angle.tBodyAccMean.gravity"         
"angle.tBodyAccJerkMean.gravityMean"  "angle.tBodyGyroMean.gravityMean"    
"angle.tBodyGyroJerkMean.gravityMean" "angle.X.gravityMean"                
"angle.Y.gravityMean"                 "angle.Z.gravityMean"      