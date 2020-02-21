##loading dplyr package
library(dplyr)

##to download and unzip the project data

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "C:/Users/USER-KOLO/Desktop/Getting-and-Cleaning-Data/projectdata.zip")
unzip("C:/Users/USER-KOLO/Desktop/Getting-and-Cleaning-Data/projectdata.zip")

##Reading the subject information from Train and Test files in the project data
subjtrain <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
subjtest <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

##Reading the activity information from y_train.txt and y_test.txt files
activitytrain <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "activity")
activitytest <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "activity")

##Reading the activity information from X_train.txt and X_test.txt files 
datatrain <- read.table("UCI HAR Dataset/train/X_train.txt")
datatest <- read.table("UCI HAR Dataset/test/X_test.txt")

##Binding both datatrain and datatest dataframes in one dataframe called mergeddata
mergeddata <- rbind(datatrain, datatest)

##Reading the features.txt file which contains information about the measurements taken
features <- read.table("UCI HAR Dataset/features.txt")

##Assigning the measurement names from features as column names of mergeddata.
names(mergeddata) <- features$V2

##Extracts only the measurements on the mean and standard deviation for each measurement from mergeddata
extrmeansd <- c(grep("mean\\(",names(mergeddata)),grep("std\\(", names(mergeddata)))
##Reorder extrmeansd vector so the column indexes extracted are in the same order as in mergeddata
extrmeansd <- extrmeansd[order(extrmeansd)]

##Binding the cols from mergeddata with mean and std in their names together in new data.frame extracteddata
extracteddata <- mergeddata[,extrmeansd]

##Binding both subjtrain and subjtest dataframes in one data.frame called allsubjects.
allsubjects <- rbind(subjtrain, subjtest)
##Binding both activitytrain and activitytest dataframes in one data.frame called allactivity
allactivity <- rbind(activitytrain, activitytest)
##Binding allsubjects and allactivity to extracteddata as last two columns
extracteddata <- cbind(mergeddata[,extrmeansd], allsubjects, allactivity)

#Reading data from activity_labels.txt and assigning the data to actlabels
actlabels <- read.table("UCI HAR Dataset/activity_labels.txt")
##Using factor() function substitutes the activity indexes with their corresponding names
##and assigns them back to activity column in extracteddata dataframe.
extracteddata$activity <- factor(extracteddata$activity, labels = actlabels$V2)

library(data.table) ##Load data.table package
dtalldata <- data.table(extracteddata) #Convert extracteddata to data.table with name dtalldata

#Makes new data.table called tidydata by averaging of the each variable for each activity and each subject
tidydata <- dtalldata[,lapply(.SD,mean), by = .(activity, subject)]

#Wrtiting tidydata in a text file named tidydata.txt
write.table(tidydata, file = "tidydata.txt", row.names = FALSE)

