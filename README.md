---
title: "README"
author: "Jozef M H Dassen"
date: "Monday, April 20, 2015"
output: html_document
---

This README describes the files in this repository and the processes by which they were created.

There is one output data file called x_tidy.txt which contains the processed results. It shows one row of data for each Subject-Activity combination. There are 30 subjects (1-30) and 6 Activities. The Acivities are: LAYING, SITTING,STANDAING, WALKING, WALKING_DOWNSTAIRS and WALKING_UPSTAIRS. Each row contains a set of accelerometer data as described in the CodeBook.

The processing steps to generate the data set from the available raw data are as follows:

1. Read in all the raw data files. 
There are two sets of data, a Training set and a Test set. For each of these we have the X files with the features, the Y file with the experiment outcomes and then, separate, a list of the subject identifiers for each of the experiments.
Furthermore we load the files for activity labels and feature labels.

2. Clean up and selection.
The Y data files contain the activity code. We use the activity labels to match the labels with the code and add a descriptive label column to the Y data files. We then row bind the training and test Y data sets to get a y_data data frame with all Y data.
The X data files contain all the feature data but do no have the proper column names loaded. 
We use the feature labels to set the column names of the X data frames. For traceability purposes we add a SOURCE column as well.
We then row bind the training and test datasets into one x_data dataframe.
We also row bind the subject identifiers into a single subject_data data frame.
We want to select only the mean() and std() features, but the select function that we want to use can not handle duplicate column names. We remove duplicate column names first and put the result in a x_nodup dataframe.
From this we select mean() and std() measurements and put them in 2 temporary data frames, x_data_mean and x_data_std.

3. Merging, grouping and summarizing.
We now have separate data frames for subject, activity (Y), X mean and X std. We merge them into a single data frame x_data_merged.
Next we use group_by and summarise_each to average all columns by subject and activity. This results in a data frame x_data_tidy which has one row of averaged mean and std measurements for each subject and activity. 

4. Output the dataframe to a text file.
The data frame x_data_tidy is written to a file x_tidy.txt.




