## Getting and Cleaning Data - Course project
## Jozef M H  Dassen
##

library(plyr)
library(dplyr)
#setwd("F:\\Coursera\\03_GettingData\\Course Project")

######   READ DATAFILES 

## Read the data sets into variables
fn <- "subject_test.txt"
subject_test<- read.table(fn)
fn <- "X_test.txt"
x_test<- read.table(fn)
fn <- "Y_test.txt"
y_test<- read.table(fn)
fn <- "subject_train.txt"
subject_train<- read.table(fn)
fn <- "X_train.txt"
x_train<- read.table(fn)
fn <- "Y_train.txt"
y_train<- read.table(fn)

fn<-"activity_labels.txt"
act_labels <- read.table(fn)
fn<-"features.txt"
feature_labels <- read.table(fn)

######  CLEANUP and SUBSETTING  


## Add ACTIVITY names to the Y sets and combine them
y_test$act_label <- as.character(act_labels[match(y_test[,1],act_labels[[1]]),][[2]])
y_train$act_label <- as.character(act_labels[match(y_train[,1],act_labels[[1]]),][[2]])
y_data<- rbind(y_train, y_test)
names(y_data) <- c("ACT_TYPE")

## For traceability add a SOURCE column to the X data sets and then 
## combine into a single data set called x_data
x_test<-mutate(x_test, SOURCE= "TEST")
x_train<-mutate(x_train, SOURCE= "TRAIN")
x_data <- rbind(x_train, x_test)

## Replace the column variable names with the proper labels
feature_vector<-as.character(feature_labels[[2]])
feature_vector[562]<- "SOURCE"
names(x_data) <- feature_vector

## Merge Subject data also
subject_data <- rbind(subject_train, subject_test)
names(subject_data) <- c("subject")


## There are duplicates column names; we remove them 
## Remove duplicates first; they do not contain and mean or std columns
feature_vector<-as.character(feature_labels[[2]])
x_nodup<-x_data[,duplicated(feature_vector)==FALSE]

## Next we select the column names that contain Mean/mean or Std/std in the name.
#get the mean columns
x_data_mean<-select(x_nodup,contains("mean()", ignore.case=TRUE))
#get the std  columns
x_data_std <-select(x_nodup,contains("std()", ignore.case=TRUE))

######  MERGE, GROUP and SUMMARISE

#combine with SUBJECT and y_data into one frame
x_data_merged<-cbind(x_data[,"SOURCE"], subject_data, y_data[,2], x_data_mean, x_data_std)

names(x_data_merged)[1] <- "source"
names(x_data_merged)[3] <- "activity"

## remove first column (SOURCE), group by SUBJECT and ACTIVITY and average all other columns

x_data_avg <- x_data_merged[,-1] %>% group_by(subject,activity) %>% summarise_each(funs(mean))

x_data_tidy <- as.data.frame(x_data_avg)

write.table(x_data_tidy, file='x_tidy.txt', row.name=FALSE)
