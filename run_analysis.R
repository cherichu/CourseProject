library(plyr)

run_analysis <- function(data_folder){
# Analyze Human Activity Recognition Using Smartphones data set
# to find average of each variable for each activity and each subject
# This function need to use plyr library so please install it before run this script
#   
# Result will be a tidy dataset saved as a text file, activity_labels_avg.txt, in R workspace
#  
# Args:
#   data_folder: The folder of raw data. eg. "C:\\Getting_and_Cleaning_Data\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\"
#
# Returns:
#   Tidy dataset for average of each variable for each activity and each subject

# ===========================================================================================
# Step 1. Merges the training and the test sets to create one data set.
# ===========================================================================================
  
# Combine Test set and Training set as x_data
test_x_data = read.table(paste(data_folder, "test/X_test.txt", sep=""), header = FALSE)
train_x_data = read.table(paste(data_folder, "train/X_train.txt", sep=""), header = FALSE)
x_data <- rbind(test_x_data, train_x_data)

# Combine Test Activities and Training Activities as y_data
test_y_data = read.table(paste(data_folder, "test/Y_test.txt", sep=""), header = FALSE)
train_y_data = read.table(paste(data_folder, "train/Y_train.txt", sep=""), header = FALSE)
y_data <- rbind(test_y_data, train_y_data)

# Read all features
features = read.table(paste(data_folder, "features.txt", sep=""), header = FALSE)
features <- as.vector(features[,2])

# Add column names. Use current feature names for x_data 
# and "activities"Activity" as column names for y_data
colnames(x_data) <- features
colnames(y_data) <- c('Activity')

# Combine test subject and training subject and add "Subject" as the column name
test_subject_data = read.table(paste(data_folder, "test/subject_test.txt", sep=""), header = FALSE)
train_subject_data = read.table(paste(data_folder, "train/subject_train.txt", sep=""), header = FALSE)
subject_data <- rbind(test_subject_data, train_y_data)
colnames(subject_data) <- c('Subject')

# Combine x_data, subject_data, y_data to one data set, raw_merge_data
raw_merge_data <- cbind(x_data, subject_data, y_data)
# End of Step 1.

# ===========================================================================================
# Step 2. Extracts only the measurements on the mean and standard deviation 
#         for each measurement. 
# ===========================================================================================

# Extract mean, std, Subject, Activity to subset_raw. Exclude meanFreq() at the end.
subset_raw = raw_merge_data[,grep("mean()|std()|Subject|Activity",names(raw_merge_data))]
subset_raw = subset_raw[,grep("meanFreq()",names(subset_raw),invert=TRUE)]
# End of Step 2.

# ===========================================================================================
# Step 3. Uses descriptive activity names to name the activities in the data set 
# ===========================================================================================

# Apply descriptive activity names 
# by transfor activity value to labels described in activity_labels.txt
activity_labels = read.table(paste(data_folder, "activity_labels.txt", sep=""), header = FALSE)
activity_labels = as.vector(activity_labels[,2])
subset_raw$Activity <- activity_labels[subset_raw$Activity]
# End of Step 3.

# ===========================================================================================
# Step 4. Appropriately labels the data set with descriptive variable names. 
# ===========================================================================================
label <- names(subset_raw)
label <- gsub("BodyBody", "Body", label)
label <- gsub("Acc", "Accelerometer", label)
label <- gsub("Mag", "Magnitude", label)
label <- gsub("Gyro", "Gyroscope", label)
label <- gsub("fB","FrequencyofB", label)
label <- gsub("tG","TimeofG", label)
label <- gsub("tB","TimeofB", label)
label <- gsub("std\\(\\)", "Std", label)
label <- gsub("mean\\(\\)", "Mean", label)
label <- gsub("-", "", label)

colnames(subset_raw) <- label
# End of Step 4.

# ===========================================================================================
# Step 5. From the data set in step 4, 
# creates a second, independent tidy data set with the average of each variable for 
# each activity and each subject.
# ===========================================================================================

# Create data frame with tidy Subject and Activity. 
activity_avg_df = ddply(subset_raw, .(Subject, Activity), .fun = function(x){c(discard = "NA")})
activity_avg_df <- activity_avg_df[order(activity_avg_df$Subject, activity_avg_df$Activity),
                                   !(names(activity_avg_df) %in% c("discard"))]
# Create the col_names vector to apply as column names of final data set
col_names = c(names(activity_avg_df))
# Find mean (average) of each variables group by Subject and Activity
for (var in names(subset_raw))
{
  if (!(var %in% c("Subject","Activity")))
  {
    # summarise + mean does not work to take variable in function. Create own function to calculate mean
    avg1 <- ddply(subset_raw, .(Subject, Activity), .fun = function(x){c(Mean = mean(x[,var],na.rm=TRUE))})
    avg1 <- avg1[order(avg1$Subject, avg1$Activity),]
    # cbind mean value of this variable to activity_avg_df
    activity_avg_df <- cbind(activity_avg_df, avg1$Mean)
    # Add "Avg. " in front of each variable to explicitly make label easier to read as the value is reshaped
    col_name = paste("Ave. ", var, sep="")
    col_names = c(col_names, col_name)
  }
}
colnames(activity_avg_df) <- col_names
# End og Step 5.

# Create the text file, activity_labels_avg.txt to submit and return the dataset
write.table(activity_avg_df, file="activity_labels_avg.txt", row.name=FALSE)
return(activity_avg_df)
}