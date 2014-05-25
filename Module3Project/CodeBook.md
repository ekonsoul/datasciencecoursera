## Module # 3 - Getting and Cleaning Data Project - Project Solution Codebook.
This codebook describes the content and transformations applied to variables used 
in order to obtain the final "tidy" data.

# Step 1.1: Read Training Features and Label Them:

* TrainFeatures is a 7352X561 data.frame containing the raw, unlabeled traning feature measurements.

* VariableNames is a  561X2 data.frame containing all the training features names.

* TrainSubject is a 7352X1 data.frame containing the subject code for every training feature measurement.

* TrainActivities is a 7352X1 data.frame containing the activity code for every training feature measurement.

* LabeledTrainFeatures is a columnwise joining of Subject No. and Activity Codes to the TrainFeatures data frame.
   It is a 7352X563 data.frame containing all training feature measurements accompanied by the subject no.
   and activity code in the first 2 columns. 

# Step 1.2: Read Testing Features and Label Them:

* TestFeatures is a 2947X561 data.frame containing the raw, unlabeled testing feature measurements.

* VariableNames is the same as above because the features measured are the same.

* TestSubject is a 2947X1 data.frame containing the subject code for every testing feature measurement

* TestActivitie is a 2947X1 data.frame containing the activity code for every testing feature measurement.

* LabeledTestFeatures is a columnwise joining of Subject No. and Activity Codes to the TestFeatures data frame.
   It is a 2947X563 data.frame containing all testing feature measurements accompanied by the subject no.
   and activity code in the first 2 columns. 


# Step 2: Merging and Sorting the 2 Data Sets.

* MergedFeatures is a row-wise merging of the LabeledTrainFeaures and LabeledTestFeatures.
   It is a big 10.299X563 data.frame containing all the available data in a single table.
   The variables are appropriately labeled and the subject no. and activity codes are included in the first two columns.

* SortedMergedFeatures: For a nicer presentation, we sort MergedFeatures according to the Subject No. and then according to Activity.

# Step 3: Extract the mean and std for each feature.
* ExtractedFeatures is a 10299X66 data.frame containing measurements on the mean and standard deviation 
  for each measurement. This manual feature selection is based on their names containing mean() or std():
  ExtractedFeatures the following columns (variables) are extracted :
                           3:8, 43:48, 83:88, 123:128, 163:168, 203:204, 216:217, 229:230, 242:243, 255:256, 268:273, 
                           347:352, 426:431, 505:506, 518:519, 531:532, 544:545.

# Step 4: Calculate the Average Value of every feature for every different activity and subject.
# This is going to be our new "tidy" dataset:
* AveragedFeatures is a 180X563 data matrix that represents our new tidy dataset. It arises from the SortedMergedFeatures
   data.frame when we average all feature measurements for each subject and each activity separately. 
   Finally, each activity is labeled with a name and not a numeric code. Also each averaged feature gets a new
   name as well: "Average"+OldFeatureName.
