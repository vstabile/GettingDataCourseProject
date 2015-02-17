# Load the train set, its labels and subjects
train_set <- read.table("train/X_train.txt")
train_labels <- read.table("train/y_train.txt")
train_subjects <- read.table("train/subject_train.txt")

# Merge activity label and subject columns to the train set
train_set$activity <- train_labels$V1
train_set$subject <- train_subjects$V1

# Load the test set, its labels and subjects
test_set <- read.table("test/X_test.txt")
test_labels <- read.table("test/y_test.txt")
test_subjects <- read.table("test/subject_test.txt")

# Merge activity label and subject columns to the test set
test_set$activity <- test_labels$V1
test_set$subject <- test_subjects$V1

# Create a single data set by merging the train and the test set rows
data_set <- rbind(train_set, test_set)

# Load features names
features <- read.table("features.txt")
# Extract the column indexes of all mean and std of the measurements
mean_std_indexes <- grep("mean|std", features$V2)
# Extract the column indexes of activity and subject
activity_subject_indexes <- grep("activity|subject", names(data_set))
# Combine all column indexes of interest
indexes <- c(mean_std_indexes, activity_subject_indexes)

# Extract only the measurements on the mean, standard deviation, activity and subject
data_set <- data_set[, indexes]

# Change the labels in the data set to descriptive names
label_names <- read.table("activity_labels.txt")
data_set$activity <- label_names[data_set$activity, "V2"]

# Extract feature names from features.txt
feature_names <- features[mean_std_indexes, "V2"]
# Format those names replacing "-" by "." and removing "()"
feature_names <- sapply(feature_names, function(x) { gsub("\\(\\)", "", gsub("-", ".", x)) })
# Appropriately labels the data set with descriptive variable names
names(data_set) <- c(feature_names, c("activity", "subject"))

# Creates a tidy data set with the average of each variable for each activity and each subject
tidy_data <- aggregate(data_set, by = list(activity, subject), mean)

# Saves the tidy data set to a text file
write.table(tidy_data, "tidy_data.txt", row.names = FALSE)