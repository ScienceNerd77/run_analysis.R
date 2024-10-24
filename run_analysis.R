# Load necessary libraries
library(dplyr)

# Step 1: Merge training and test sets
# Load training data
train_data <- read.table("UCI HAR Dataset/train/X_train.txt")
train_labels <- read.table("UCI HAR Dataset/train/y_train.txt")
train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")

# Load test data
test_data <- read.table("UCI HAR Dataset/test/X_test.txt")
test_labels <- read.table("UCI HAR Dataset/test/y_test.txt")
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Merge the datasets
combined_data <- rbind(train_data, test_data)
combined_labels <- rbind(train_labels, test_labels)
combined_subjects <- rbind(train_subjects, test_subjects)

# Step 2: Extract mean and standard deviation measurements
features <- read.table("UCI HAR Dataset/features.txt")
mean_std_indices <- grep("mean\\(\\)|std\\(\\)", features[, 2])
mean_std_data <- combined_data[, mean_std_indices]

# Step 3: Use descriptive activity names
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
combined_labels[, 1] <- activity_labels[combined_labels[, 1], 2]
colnames(combined_labels) <- "Activity"

# Step 4: Label the dataset with descriptive variable names
colnames(mean_std_data) <- features[mean_std_indices, 2]
colnames(mean_std_data) <- gsub("\\(\\)", "", colnames(mean_std_data))
colnames(mean_std_data) <- gsub("BodyBody", "Body", colnames(mean_std_data))

# Combine all data into a final dataset
final_data <- cbind(combined_subjects, combined_labels, mean_std_data)
colnames(final_data)[1] <- "Subject"

# Step 5: Create a second tidy dataset with averages
tidy_data <- final_data %>%
  group_by(Subject, Activity) %>%
  summarize(across(everything(), mean))

# Write the tidy dataset to a file
write.table(tidy_data, "tidy_data.txt", row.names = FALSE)
