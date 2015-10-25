# Read train data in
dataTrainX <- read.table("train/X_train.txt")
dataTrainY <- read.table("train/y_train.txt")
dataTrainSubject <- read.table("train/subject_train.txt")

# Read test data in
dataTestX <- read.table("test/X_test.txt")
dataTestY <- read.table("test/y_test.txt")
dataTestSubject <- read.table("test/subject_test.txt")

# Adjust titles in y and subject data frames
names(dataTrainY)[1] <- "y"
names(dataTestY)[1] <- "y"
names(dataTrainSubject)[1] <- "subject"
names(dataTestSubject)[1] <- "subject"

# read in features data
features <- read.table("features.txt")

# filter out mean and std features
features_filter <- features[grep("mean|std", features$V2, ignore.case = TRUE),]

# combine train and test feature data
data <- rbind(dataTrainX, dataTestX)

library(dplyr)

# extract mean and std features from data using filter
data_filtered <- select(data, features_filter$V1)

library(plyr)

# combine train and test activity/result data
dataY <- rbind(dataTrainY, dataTestY)
dataY$y <- revalue(as.character(dataY$y), c("1"="Walk","2"="WalkUp","3"="WalkDown","4"="Sit","5"="Stand","6"="Lay"))

# combine train and test subject data
dataSubject <- rbind(dataTrainSubject, dataTestSubject)

# Combine features , activity and subject
dataComb <- cbind(data_filtered, dataY, dataSubject)

dataComb$y <- as.factor(dataComb$y)
dataComb$subject <- as.factor(dataComb$subject)

meanBySubjectActivity <- aggregate(.~dataComb$y+dataComb$subject, data = dataComb[,1:86], FUN = function(x) mean(x,na.rm = T))
names(meanBySubjectActivity)[1] <- "activity"
names(meanBySubjectActivity)[2] <- "subject"

write.table(meanBySubjectActivity, file = "tidydata.txt", row.names = FALSE)
