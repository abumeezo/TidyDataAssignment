#Rusan Getting and Cleaning Data Week4 Final Assignment Codebook

###Raw data

trainingSubjects:   integer vector of subject IDs between 1 – 30

testSubjects:       integer vector of subject IDs between 1 – 30

trainingYdata:      integer vector of activities between 1 – 6

testYdata:          integer vector of activities between 1 – 6

trainingXdata:      data.frame of characters corresponding to 
                    linear acceleration (standard gravity units 'g')
                    and angular veolocity (radians/second) normalized
                    and bounded within [-1 – 1], and summary statistics
                    and other metrics computed from these data

testXdata:          data.frame of characters corresponding to 
                    linear acceleration (standard gravity units 'g')
                    and angular veolocity (radians/second) normalized
                    and bounded within [-1 – 1], and summary statistics
                    and other metrics computed from these data

feature_names:      character vector corresponding to measured feature
                    names

activity_labels:    character vector corresponding to human-readable 
                    data labels


###Transformed and combined data
trainingXdata (data.frame) ---> trainingXdata list produced by apply()
                                that splits feature character vector
                                by a " " (space)
trainingXdata (list)       ---> trainingXdata list produced by lapply()
                                that removes erroneous "" characters
trainingXdata (list)       ---> trainingXdata data.frame produced by
                                as.data.frame()

testXdata (data.frame)     ---> testXdata list produced by apply()
                                that splits feature character vector
                                by a " " (space)
testXdata (list)           ---> testXdata list produced by lapply()
                                that removes erroneous "" characters
testXdata (list)           ---> testXdata data.frame produced by
                                as.data.frame()

trainingData (data.frame):      produced by cbind() of trainingSubjects,
                                trainingXdata and trainingYdata

testData (data.frame):          produced by cbind() of testSubjects,
                                testXdata and testYdata

AllData (data.frame):           produced by rbind() of trainingData and
                                testData

changedColnames (vector):       character vector repeatedly changed by
                                gsub() calls changing the variable names
                                to human-readable, verbose form (see README). 
                                Assigned to colnames of AllData

melted_data (data.frame):       data.frame produced by reshape2::melt() on 
                                AllData that uses subject-ID,activity label IDs 
                                and the rest of the measured variables as the values

final_tidy_dataset(data.frame): data.frame produced by dcast() on melted_data
                                that uses subject-ID,activity label IDs and 
                                averages the measured variable to assign to the
                                unique ID rows. Returned as result of assignment.

###Indices and logicals
MeanSTDevColnames:   character vector produced by grep() on colnames of AllData that finds variables
                     with "mean" and "std" as part of the name



