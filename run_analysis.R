


#loading training data to R
xtrain <- read.table(file.choose())
ytrain <- read.table(file.choose())
subject_train <- read.table(file.choose())

#loading testing data to R
xtest <- read.table(file.choose())
ytest <- read.table(file.choose())
subject_test <- read.table(file.choose())

#loading features data to R
features <- read.table(file.choose())

#loading labels data to R
activityLabels <- read.table(file.choose())



#assigning new column names to the train dataset
colnames(xtrain) = features[,2]
colnames(ytrain) = "activityId"
colnames(subject_train) = "subjectId"

#assigning new column names to the test dataset
colnames(xtest) = features[,2]
colnames(ytest) = "activityId"
colnames(subject_test) = "subjectId"

#assigning new column names to the activityLabels dataset
colnames(activityLabels) <- c('activityId','activityType')


#joining together the test and train datasets 
TrainMerged = cbind(ytrain, subject_train, xtrain)
TestMerged = cbind(ytest, subject_test, xtest)

#joining together TrainMerged and TestMerged datasets
FinalData = rbind(TrainMerged, TestMerged)



#extracts only the measurements on the mean and standard deviation for each measurement  

colNames = colnames(FinalData)

MeanStd = (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))

MeanStdData <- FinalData[ , MeanStd == TRUE]


#assigning descriptive activity names to name the activities in the data set
MeanStdDataNamed = merge(MeanStdData, activityLabels, by='activityId', all.x=TRUE)


#reshaping the data to get the mean of variables for each subject and activity
library(reshape2)
TidyData<- melt(MeanStdDataNamed, id=c("subjectId","activityId", "activityType"), 
                measure.vars = 3:81)

TidyData1 <- dcast(TidyData,subjectId +activityType  ~ variable, mean)


#creating a csv file
write.table(TidyData1, "TidyData1.txt", row.name=FALSE)




