### Download files from the web###

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(url, "datafile.zip")


###Read headers, training set and test dataset 


headers <- read.table ("./features.txt")
actLab <- read.table ("./activity_labels.txt")

xTest <- read.table ("./test/X_test.txt")
yTest <- read.table ("./test/y_test.txt")
subjTest <- read.table ("./test/subject_test.txt") 

xTrain <- read.table ("./train/X_train.txt")
yTrain <- read.table ("./train/y_train.txt")
subjTrain <- read.table ("./train/subject_train.txt")

### Appropriately label the data set with descriptive variable names ###

names(xTest) <- headers[,2]
names(xTrain) <- headers[,2]

### Adds descriptive activity names###

activityTest <- c()
activityTrain <- c()
activity <- c()

for (i in 1: nrow(yTest)){

  activityTest [i] <-  as.character(actLab[yTest[i, 1], 2]) 

}

for (i in 1: nrow(yTrain)){
  
  activityTrain [i] <-  as.character(actLab[yTrain[i, 1], 2])
  
}



for (i in 1: nrow(yTest)){
  
  activity[i] <- activityTest[i]  
  
}



for (i in (nrow(yTest)+1):(nrow(yTest) + nrow(yTrain)) ){
  
  activity[i] <- activityTrain[i-nrow(yTest)]  
  
}



x <- rbind(data.frame(xTest), data.frame(xTrain))

subj <- rbind(subjTest, subjTrain)

names(subj) <- "subject"


mainData <- data.frame(subj, activity, x)



### Appropriately label the data set with descriptive variable names ###

names(f)[1] <- "subject"
names(f)[2] <- "activity"


###Extract Mean and standard deviation###

checkNames <- (grepl('mean',names(mainData))|grepl('std',names(mainData)))&(!grepl('meanFreq',names(mainData)))


meanStdExtract <- data.frame(subj, activity, mainData[, checkNames])



###From the data set in step 4, creates a second, ###
###independent tidy data set with the average of ###
###each variable for each activity and each subject.###


summData <- aggregate(meanStdExtract[3:ncol(meanStdExtract)], 
                   by = meanStdExtract[c("subject","activity")], FUN=mean)

write.table(summData, "./Final Project/summData.txt", sep="\t", row.name=FALSE)
