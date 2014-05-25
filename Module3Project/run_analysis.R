## Module # 3 - Getting and Cleaning Data Project Solution.



## Step 1.1: Read Training Features and Label Them:

# Provide colClasses to read.table() for faster reading:
initial1 <- read.table("Dataset/train/X_train.txt", nrows = 10)
classes1 <- sapply(initial1, class)
TrainFeatures <- read.table("Dataset/train/X_train.txt", colClasses = classes1)

# Read the names of the features:
VariableNames <- read.table("Dataset/features.txt")

# Assign them to the TrainFeatures read above:
colnames(TrainFeatures) <- VariableNames[,2]

# Read the Subject No. of Train features:
TrainSubject <- read.table("Dataset/train/subject_train.txt", colClasses = "numeric")

# Read the Activitie Codes of Train features:
TrainActivities <- read.table("Dataset/train/y_train.txt", colClasses = "numeric")

# Join columnwise Subject No. and Activity Codes to the Train_Features data frame:
LabeledTrainFeatures <- cbind(TrainSubject[,1],TrainActivities[,1],TrainFeatures);

# Label the two recently added columns accordingly: 
colnames(LabeledTrainFeatures)[1] <- "Subject.No."
colnames(LabeledTrainFeatures)[2] <- "Activity"



## Step 1.2: Read Testing Features and Label Them:

# Provide colClasses to read.table() for faster reading:
initial2 <- read.table("Dataset/test/X_test.txt", nrows = 10)
classes2 <- sapply(initial2, class)
TestFeatures <- read.table("Dataset/test/X_test.txt", colClasses = classes2)

# Assign the Feature Names to the Test_Features read above:
colnames(TestFeatures) <- VariableNames[,2]

# Read the Subject No. of Test features:
TestSubject <- read.table("Dataset/test/subject_test.txt", colClasses = "numeric")

# Read the Activity Codes of Test features:
TestActivities <- read.table("Dataset/test/y_test.txt", colClasses = "numeric")

# Join columnwise Subject No. and Activity Codes to the Test_Features data frame:
LabeledTestFeatures <- cbind(TestSubject[,1],TestActivities[,1],TestFeatures);

# Label the two recently added columns accordingly: 
colnames(LabeledTestFeatures)[1] <- "Subject.No."
colnames(LabeledTestFeatures)[2] <- "Activity"

# Remove from memory non-needed data:
# remove(classes1, classes2, initial1, initial2, 
#       TestActivities, TestFeatures, TestSubject,
#       TrainActivities, TrainFeatures, TrainSubject,VariableNames)



## Step 2: Merging and Sorting the 2 Data Sets.

## Merge the Labeled Train and Labeled Test Features:
MergedFeatures <- rbind(LabeledTrainFeatures, LabeledTestFeatures)
# remove(LabeledTrainFeatures, LabeledTestFeatures)

## For a nicer presentation, sort them according to the Subject No. and then according to Activity:
SortedMergedFeatures <- MergedFeatures[order(MergedFeatures$Subject.No., MergedFeatures$Activity) ,]
# remove(MergedFeatures)


## Step 3: Extract the mean and std for each feature. This is based on their names containing mean() or std():
ExtractedFeatures <- cbind(SortedMergedFeatures[,3:8],     SortedMergedFeatures[,43:48],   SortedMergedFeatures[,83:88],
                           SortedMergedFeatures[,123:128], SortedMergedFeatures[,163:168], SortedMergedFeatures[,203:204],
                           SortedMergedFeatures[,216:217], SortedMergedFeatures[,229:230], SortedMergedFeatures[,242:243],
                           SortedMergedFeatures[,255:256],
                           SortedMergedFeatures[,268:273], SortedMergedFeatures[,347:352], SortedMergedFeatures[,426:431],
                           SortedMergedFeatures[,505:506], SortedMergedFeatures[,518:519], SortedMergedFeatures[,531:532],
                           SortedMergedFeatures[,544:545])


## Step 4: Calculate the Average Value of every feature for every different activity and subject.
## This is going to be our new "tidy" dataset:
AveragedFeatures <- matrix(nrow = 0, ncol = 563)

for (subj in 1:30) {
  for (act in 1:6) {
    
    subtable <- SortedMergedFeatures[(SortedMergedFeatures$Subject.No == subj & SortedMergedFeatures$Activity == act) ,]
    AveragedFeatures <- rbind(AveragedFeatures, colMeans(subtable))     
    
  }
}

# Provide New Names for the Averaged Features:
colnames(AveragedFeatures)[3:563] <- paste("Average",colnames(SortedMergedFeatures)[3:563])
colnames(AveragedFeatures)[1] <- "Subject.No."
colnames(AveragedFeatures)[2] <- "Activity"

## Label Activities in: SortedMergedFeatures
ind1 <- SortedMergedFeatures$Activity == 1
SortedMergedFeatures$Activity[ind1] <- "WALKING"

ind2 <- SortedMergedFeatures$Activity == 2
SortedMergedFeatures$Activity[ind2] <- "WALKING_UPSTAIRS"

ind3 <- SortedMergedFeatures$Activity == 3
SortedMergedFeatures$Activity[ind3] <- "WALKING_DOWNSTAIRS"

ind4 <- SortedMergedFeatures$Activity == 4
SortedMergedFeatures$Activity[ind4] <- "SITTING"

ind5 <- SortedMergedFeatures$Activity == 5
SortedMergedFeatures$Activity[ind5] <- "STANDING"

ind6 <- SortedMergedFeatures$Activity == 6
SortedMergedFeatures$Activity[ind6] <- "LAYING"

## Save Merged Features in .csv format (optional - not required by project):
# file1 = "Merged Dataset/merged_features.csv"
# write.csv(SortedMergedFeatures, file1)


## Label Activities in AveragedFeaturesvin a similar way:
ind11 <- AveragedFeatures[,"Activity"] == 1
AveragedFeatures[ind11,"Activity"] <- "WALKING"

ind22 <- AveragedFeatures[,"Activity"] == 2
AveragedFeatures[ind22, "Activity"] <- "WALKING_UPSTAIRS"

ind33 <- AveragedFeatures[,"Activity"] == 3
AveragedFeatures[ind33,"Activity"] <- "WALKING_DOWNSTAIRS"

ind44 <- AveragedFeatures[,"Activity"] == 4
AveragedFeatures[ind44,"Activity"] <- "SITTING"

ind55 <- AveragedFeatures[,"Activity"] == 5
AveragedFeatures[ind55,"Activity"] <- "STANDING"

ind66 <- AveragedFeatures[,"Activity"] == 6
AveragedFeatures[ind66,"Activity"] <- "LAYING"

# Save the new tidy dataset into a newly created "Tidy Dataset" directory:
dir.create("Tidy Dataset")
file2 = "Tidy Dataset/tidy.txt"
write.table(AveragedFeatures,file2, col.names = TRUE, row.names = TRUE)

# Remove unneeded variables:
remove(file1, file2, ind1, ind2, ind3, ind4, ind5, ind6, ind11,
       ind22, ind33, ind44, ind55, ind66,
       act, subj, subtable)
