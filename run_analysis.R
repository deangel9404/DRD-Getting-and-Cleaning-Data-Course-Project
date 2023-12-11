##The first portion of this script reads the first part of the data set, the "Test Data," into a dataframe.

TestData <- read.table("./UCI HAR Dataset/test/X_test.txt") ##Reads raw values into dataframe
ColLabels <- read.table("./UCI HAR Dataset/features.txt") ##Reads column labels into dataframe
ColLabels <- as.vector(ColLabels$V2)
MeanTF<-grep("[Mm]ean\\(\\)", ColLabels) ##finds all instances of "mean()" and "std" within the column labels
StdTF<-grep("[Ss]td", ColLabels)
LabelNo <- append(MeanTF, StdTF) ##merges "mean()" and "std" into one ordered list
LabelNo <- sort(LabelNo)
TestData <- TestData[,LabelNo] ##removes all other column labels other than those containing "mean()" or "std", and removes the corresponding columns from the raw data dataframe
ColLabels <- ColLabels[LabelNo] 
colnames(TestData) <- ColLabels ##applies the vector of column labels generated in the previous step to the raw data dataframe
TestSubjectNo <- read.table("./UCI HAR Dataset/test/subject_test.txt") ##reads the subject number for each measurement into a dataframe
colnames(TestSubjectNo)<-"SubjectNumber"
TestActivity<-read.table("./UCI HAR Dataset/test/y_test.txt") ##reads the raw activity number for each measurement into a dataframe
colnames(TestActivity)<-"Activity"
TestData <- cbind(TestSubjectNo, TestActivity, TestData) ##merges the raw data, subject number, and raw activity number into a single dataframe

##The second portion of this script reads the second part of the data set, the "Train Data," into a dataframe, repeating many of the steps from the first part of the script.

TrainData <- read.table("./UCI HAR Dataset/train/X_train.txt") ##Reads raw values into dataframe
TrainData <- TrainData[,LabelNo] ##removes all columns that do not correspond to either a mean or a standard deviation from the preceding dataframe
colnames(TrainData)<- ColLabels ##applies the column labels obtained in the previous section to the dataframe
TrainSubjectNo <- read.table("./UCI HAR Dataset/train/subject_train.txt")  ##reads the subject number for each measurement into a dataframe
colnames(TrainSubjectNo)<-"SubjectNumber"
TrainActivity<-read.table("./UCI HAR Dataset/train/y_train.txt") ##reads the raw activity number for each measurement into a dataframe
colnames(TrainActivity)<-"Activity"
TrainData <- cbind(TrainSubjectNo, TrainActivity, TrainData) ##merges the raw data, subject number, and raw activity number into a single dataframe

##The final portion of this script merges the "Test" and "Train" dataframes into one dataframe, takes the mean for the repeated measurements in each column for each subject/activity pair, and converts the raw activity numbers into a human-readable format.
##Finally, the script outputs the tidy dataset to a text file in the current working directory

AllData <- rbind(TestData, TrainData) ##combines Test and Train dataframes into a single dataframe
SplitData <- split(AllData, ~AllData$SubjectNumber + AllData$Activity) ##Splits the dataframe according to activity and subject, producing a list of 180 elements (6 activities * 30 subjects)
MeanData <- as.data.frame(lapply(SplitData, function(x) colMeans(x)))  ##applies the mean function to each element of the list generated in the previous step, then outputs the result in a dataframe
MeanData <- as.data.frame(t(MeanData)) ##Transposes the data, so that the parameters measured are the columns
MeanData$Activity <- gsub(1, "Walking", MeanData$Activity)  ##Applies human-readable names to each of the six activities
MeanData$Activity <- gsub(2, "Walking Upstairs", MeanData$Activity)
MeanData$Activity <- gsub(3, "Walking Downstairs", MeanData$Activity)
MeanData$Activity <- gsub(4, "Sitting", MeanData$Activity)
MeanData$Activity <- gsub(5, "Standing", MeanData$Activity)
MeanData$Activity <- gsub(6, "Laying", MeanData$Activity)
write.table(MeanData, "./GaCD_Course_Project_Tidy_Data.txt", row.names = FALSE) ##outputs the tidy dataset to a text file