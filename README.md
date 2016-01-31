README
=======
Explanation of how run_analysis.R works.
-----------
 
### Step 1. Load the data files
The program expects to load the data files from the folder called "UCI HAR Dataset."  If this folder is missing, the program gives a simple instruction on how to obtain the data and ends.

The program then attempts to load the following files from the "UCI Har Dataset" folder in succession.  If any of the files are missing, the program ends.
subject_test loads from test/subject_test.txt

* X_test loads from test/X_test.txt
* y_test loads from test/y_test.txt
* subject_train loads from train/subject_train.txt
* X_train loads from train/X_train.txt
* y_train loads from train/y_train.txt
* features from features.txt
* activity_labels from activity_labels.txt

The next step is to rename the column names of subject and y as subject and activity, respectively, for both test and train datasets.

The next step is to bind the subject, y, and x tables for both test and train datasets.

The next step is to combine the test and train data sets with the rbind function into the data.frame named "all".

### Step 2. Clean up column names and extract std and mean columns
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

The next step is to apply the cleaned up list as the column names of the "all" data.frame from columns 3:563.
The first two columns of all shall remain subject and activity as defined in step 1.

The next step is to extract all columns that contain "mean" and "std" into stdAndMean.

### Step 3.  Apply the proper activity labels to the activity column

The labels found in the activity_labels file will now be applied in the activity column, replacing numbers with readable strings.  The following substition shall be applied:

* 1 will be replaced by "WALKING"
* 2 will be replaced by "WALKING_UPSTAIRS"
* 3 will be replaced by "WALKING_DOWNSTAIRS"
* 4 will be replaced by "SITTING"
* 5 will be replaced by "STANDING"
* 6 will be replaced by "LAYING" 

### Step 4.  Summarize the data and create output file
The data.frame will now be summarized to extract the mean for each subject and activity pair to satisfy the one observation per row and one variable per column principle of tidy data.

A file called "TidyData.txt" will be created.

