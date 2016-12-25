#Rusan Getting and Cleaning Data Week4 Final Assignment

###Summary of the code

The first portion of the code is concerned with reading in the X, y and subject data correctly before merging them. After converting the activity numbers, and mean and standard deviation-related variable names to descriptive types the data is ready to be subsetted. Subsetting involves melting the data to each combination of subject ID and activity followed by a dcast operation to calculate the means for each pair of subject+activity. The R script is thoroughly commented as well for additional details.

###Inputting and formatting the raw data

The relevant data for each of the training and test sets are in .txt files with names including 'X','y' and 'subject'. The X data is read in as tab-delimited to give the correct number of rows that match the other two data types, but the feature vector is squashed into one column. The feature vector is separated by spaces, so a subsequent string-splitting is performed on the X data followed by removing empty ("") strings. After this is accomplished, the X data are coerced/cast back into data.frame objects. Next, the appropriate subject ID and y-labels are column-bound to the X data for each of the test and training sets. Finally, the test and training sets are row-bound to create the merged AllData set and feature names are loaded from a file and assigned to the column names of AllData.

###Selecting columns related to mean and standard deviation variables

A grep command is utilized on the column-names to find variables related to the mean and standard deviation ('ean' and 'std'). The data is then simply subsetted for the appropriate columns, along with the subject ID and activity name columns.

###Renaming the activities

The map from number to activity label is performed by loading the labels from the .txt files then reassigning the levels of the activity column in the AllData frame to these character values. The activity column was of course first treated as a factor with as.factor().

###Creating descriptive variable names

Reading the material included with the data (README.txt and features_info.txt) provided the necessary information to make the variable names human-readable. Examining the column names identified the abbreviations and typos that needed changing. The changes made with gsub() were:

* t: time domain (at start of variable name of after "(" )
* f: frequency domain (at start of variable name)
* std: standard deviation (anywhere)
* [Body]BodyAcc: Body linear acceleration (handle their typos of double Body)
* [Body]BodyGyro: Body angular velocity (handle their typos of double Body)
* GravityAcc: Gravity linear acceleration
* gravityMean: put a space between these two, later replaced with a period
* JerkMean: put a space between these two, later replaced with a period
* JerkMag: put a space between these two, later replaced with a period
* Mag: magnitude
* meanFreq: mean frequency
* () : remove these useless symbols
* angle: angle between (at start of variable name)
* , : comma for 'angle between' variables, change it to "and"

Finally, the changed variable names were then set to the column names of AllData

###Producing the requested tidy data set

Having setup the data, there remained an appropriate data manipulation and saving to file. To obtain rows of every subject ID and activity combinations, the data was melted using the reshape2 package setting those two variable as the IDs and the rest of the columns were set to the values. Having produced this tall and skinny melted data set, the final procedure involved casting the data back into a wider format by averaging all of the measured variables and keeping unique subject ID/activity label rows. This finalized data set was then saved to a file using write.table() and submitted on the Coursera website.