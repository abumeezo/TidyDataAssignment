#Load packages
library(dplyr)
library(tidyr)
library(reshape2)

#Read in the data
trainingSubjects <- read.delim("./train/subject_train.txt",header = F)
trainingXdata <- read.delim("./train/X_train.txt",sep="\t",header = F)
trainingYdata <- read.delim("./train/y_train.txt",header = F)
testSubjects <- read.delim("./test/subject_test.txt",header = F)
testXdata <- read.delim("./test/X_test.txt",sep="\t",header = F)
testYdata <- read.delim("./test/y_test.txt",header = F)

#Begin separating the data that is all merged into one column by spaces
trainingXdata <- apply(trainingXdata,MARGIN = 1,strsplit,split = " ",fixed = T)
testXdata <- apply(testXdata,MARGIN = 1,strsplit,split = " ",fixed = T)

#Now remove the empty ("") strings, leaving the 561-sized feature vectors
trainingXdata <- lapply(trainingXdata,FUN = function(x) x[[1]][nchar(x[[1]])>0])
testXdata <- lapply(testXdata,FUN = function(x) x[[1]][nchar(x[[1]])>0])

#Data are in list form, so coerce/cast them into data.frames and transpose them correctly
trainingXdata <- t(as.data.frame(trainingXdata))
testXdata <- t(as.data.frame(testXdata))

#Load in the raw feature vector names to create column names for X data sets
feature_names <- read.delim("./features.txt",sep = "",header = F,colClasses = "character")

#Assign the feature names to colnames of X data sets
colnames(trainingXdata) <- feature_names[,2]
colnames(testXdata) <- feature_names[,2]

#Coerce/cast all the data to numeric
trainingXdata <- apply(X = trainingXdata,MARGIN = 2,FUN = as.numeric)
testXdata <- apply(X = testXdata,MARGIN = 2,FUN = as.numeric)

#Column-bind the subject IDs and y data (labels) to the data sets
trainingData <- cbind(trainingSubjects,trainingXdata,trainingYdata)
testData <- cbind(testSubjects,testXdata,testYdata)

#Merge the training and test data with row-bind
AllData <- rbind(trainingData,testData)

#Fill in the last two column names for subjects and labels with useful names
colnames(AllData)[c(1,563)]<-c("Subject ID","Activity name")

################### END of step #1 ##################################

#Find measurements (colnames/variables) related to mean and standard deviation
MeanSTDevColnames <- grep(colnames(AllData),pattern = "[Mm]ean|std")

#Subset the data related to means, standard deviations, subject IDs and activities
AllData <- AllData[,c(1,MeanSTDevColnames,563)]

################### END of step #2 ##################################

#Load the activity name labels and fix underscores with make.names 
activity_labels <- read.delim("./activity_labels.txt",sep=" ",header = F,colClasses = "character")
activity_labels <- make.names(activity_labels[,2],allow_ = FALSE)

#Treat the activity name column as a factor, currently with numeric values
AllData$`Activity name` <- as.factor(AllData$`Activity name`)

#Reset the levels 1:6 to the activity labels (strings)
levels(AllData$`Activity name`) <- activity_labels

################### END of step #3 ##################################

#Tidying and renaming variables based on insights from provided README and feature_info .txts
#t: time domain (at start of variable name of after "(" )
#f: frequency domain (at start of variable name)
#std: standard deviation (anywhere)
#[Body]BodyAcc: Body linear acceleration (handle their typos of double Body)
#[Body]BodyGyro: Body angular velocity (handle their typos of double Body)
#GravityAcc: Gravity linear acceleration
#gravityMean: put a space between these two, later replaced with a period
#JerkMean: put a space between these two, later replaced with a period
#JerkMag: put a space between these two, later replaced with a period
#Mag: magnitude
#meanFreq: mean frequency
#() : remove these useless symbols
#angle: angle between (at start of variable name)
#, : comma for 'angle between' variables, change it to and
changedColnames <- colnames(AllData)
changedColnames <- gsub(changedColnames,pattern = "meanFreq",replacement = "mean frequency ")
changedColnames <- gsub(changedColnames,pattern = "GravityAcc",replacement = "Gravity linear acceleration ")
changedColnames <- gsub(changedColnames,pattern = "gravityMean",replacement = "gravity mean")
changedColnames <- gsub(changedColnames,pattern = "JerkMean",replacement = "Jerk mean")
changedColnames <- gsub(changedColnames,pattern = "JerkMag",replacement = "Jerk mag")
changedColnames <- gsub(changedColnames,pattern = "mag",replacement = "magnitude")
changedColnames <- gsub(changedColnames,pattern = "BodyBodyAcc",replacement = "Body linear acceleration ")
changedColnames <- gsub(changedColnames,pattern = "BodyAcc",replacement = "Body linear acceleration ")
changedColnames <- gsub(changedColnames,pattern = "BodyBodyGyro",replacement = "Body angular velocity ")
changedColnames <- gsub(changedColnames,pattern = "BodyGyro",replacement = "Body angular velocity ")
changedColnames <- gsub(changedColnames,pattern = "\\()",replacement = "")
changedColnames <- gsub(changedColnames,pattern = ",",replacement = " and ")
changedColnames <- gsub(changedColnames,pattern = "std",replacement = "standard deviation")
changedColnames <- gsub(changedColnames,pattern = "^angle",replacement = "angle between ")
changedColnames <- gsub(changedColnames,pattern = "\\(t",replacement = "time domain ")
changedColnames <- gsub(changedColnames,pattern = "^t",replacement = "time domain ")
changedColnames <- gsub(changedColnames,pattern = "^f",replacement = "frequency domain ")
changedColnames <- gsub(changedColnames,pattern = " -",replacement = " ")

#Change everything to lower case
changedColnames <- tolower(changedColnames)

#Use make.names to remove spaces and others and replace with periods
changedColnames <- make.names(changedColnames)

#Swap double periods for singles
changedColnames <- gsub(changedColnames,pattern = "\\.\\.",replacement = ".")

#Set Data colnames to the finalized descriptive (and verbose) variable names
colnames(AllData) <- changedColnames

################### END of step #4 ##################################

#Now to create the final tidy data, first we melt to all subject + activity combination IDs
melted_data <- melt(data = AllData,id.vars = c("subject.id","activity.name"),
                    measure.vars = colnames(AllData)[2:87])

#Now we just want one row for every subject + activity combination (30*6 = 180)
#The value for these 180 rows is the mean of the variables, so we use dcast
final_tidy_dataset <- dcast(data = melted_data,subject.id + activity.name ~ variable,mean)

#Save tidy data set to file
write.table(final_tidy_dataset,file="Rusan_tidy_data.txt",row.names = FALSE)

################### END of step #5 ##################################
