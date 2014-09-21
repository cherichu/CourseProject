CourseProject
=============

This program is to analyzeHuman Activity Recognition Using Smartphones data set
to find average of each variable for each activity and each subject

Result will be a tidy dataset saved as a text file, activity_labels_avg.txt, in R workspace

Args:
=============
   data_folder: The folder of raw data. eg. "C:\\\\Getting_and_Cleaning_Data\\\\getdata-projectfiles-UCI HAR Dataset\\\\UCI HAR Dataset\\\\"
   
   Please note: If you are in Windows you will need to type "\\\\" to escape in order to correctly read the folder structure

Returns:
=============
   Tidy dataset for average of each variable for each activity and each subject

How to run:
=============
1. Source run_analysis.R into R Studio and type:
2. run_analysis("your_data_folder") to start analyzing

As a result, you should get a text file, activity_labels_avg.txt which is a tidy data set 
of average of each variable for each activity and each subject

run_analysis function will also return a data frame. You can also run:

1. avg_test_df <- run_analysis("your_data_folder")
2. View(avg_test_df) to verify data in R Studio

What exactly run_analysis do:
=============
Step 1. Merges the training and the test sets to create one data set.

Step 2. Extracts only the measurements on the mean and standard deviation 
         for each measurement. 
         
Step 3. Uses descriptive activity names to name the activities in the data set

Step 4. Appropriately labels the data set with descriptive variable names.

Step 5. From the data set in step 4, 
 creates a second, independent tidy data set with the average of each variable for 
 each activity and each subject.
 
