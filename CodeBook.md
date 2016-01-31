CodeBook
=======
Code book that describes the variables, the data, and any transformations or work performed to clean up the data.

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

Rename the column names of subject and y as subject and activity, respectively, for both test and train datasets 

Bind the subject, y, and x tables for both test and train datasets

Combine the test and train data sets with the rbind function into the data.frame named "all"

### Clean up column names
Clean up column names and extract std and mean columns
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

Apply the cleaned up list as the column names of the "all" data.frame from columns 3:563. 
Extract all columns that contain "mean" and "std" into stdAndMean.

### Apply the proper activity labels to the activity column
The labels found in the activity_labels file will now be applied in the activity column, replacing numbers with readable strings.  The following substition shall be applied:

* 1 will be replaced by "WALKING"
* 2 will be replaced by "WALKING_UPSTAIRS"
* 3 will be replaced by "WALKING_DOWNSTAIRS"
* 4 will be replaced by "SITTING"
* 5 will be replaced by "STANDING"
* 6 will be replaced by "LAYING" 

### Summarize
Use the group_by function to arrange the table by subject and then by activity.
xx<-group_by(x,subject,activity)

Use the summarize_each function to apply mean function to each group in the previous step.
tidydata<-summarize_each(xx,funs(mean),3:88)

