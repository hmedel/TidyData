#################################
### Get the data for Test set ###
#################################
library(data.table)
library(dplyr)
testsubject<-fread("./test/subject_test.txt")
testy<-fread("./test/y_test.txt")
testX<-fread("./test/X_test.txt")
#
###################################
###  Get the data for Train set ###
###################################
trainsubject<-fread("./train/subject_train.txt")
trainy<-fread("./train/y_train.txt")
trainX<-fread("./train/X_train.txt")
#
###########################################
## Bind the data for Test and Train sets ##
###########################################
TestData<-cbind(testsubject,testy,testX)
TrainData<-cbind(trainsubject,trainy,trainX)
#
#######################################################
## Change names for the Subject and Activity columns ##
#######################################################
colnames(TestData)[c(1,2)]<-c("Subject","Activity")
colnames(TrainData)[c(1,2)]<-c("Subject","Activity")
#
######################################
#### 1.Merging the two data sets  ####
######################################
TTData<- data.frame(rbind(TrainData,TestData))
#
####################################
##### 2.Extracts measurements ######
####################################
# Read measurements
features<- as.data.frame(fread("./features.txt")) ###readLines("./features.txt")
features[,2]<- as.character(features[,2])
#Find columns of mean and std values
vms<-grep("mean|std",features[,2])
# Dataset of mean and sd of each measurement
TMSData<-TTData[,c(1,2,vms+2)]
#
#
#####################################
### 3. Naming Descriptive activity ##
#####################################
library(stringr)
activity<-read.table("./activity_labels.txt") ## Read the activity labels
actnum<-activity$V1  ## Read activity number
actnam<-as.character(activity$V2) ## Read activity name
names(actnam)<-actnum ## Create a table for activity names
TTData[,2]<-str_replace_all(TTData[,2] ,actnam) ## Put names to activities
#
#
######################################
### 4. Naming Descriptive variables ##
######################################
featnam<-features[,-1]    ## Read the name of the variables
names(featnam)<-paste0("V",features[,1]) ## Name the variables by number
names(TTData)<-str_replace_all(names(TTData),featnam) ## Replace the variable number by name
#
#
######################################
### 5. Naming Descriptive variables ##
######################################
# Tidy data set with the average of each activity an
# and each subject
TidyData<-ddply( TTData, c("Subject","Activity"), numcolwise(mean) )
