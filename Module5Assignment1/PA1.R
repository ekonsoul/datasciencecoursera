# Reproducible Research: Peer Assessment 1


## Loading and preprocessing the data
Data <- read.csv('activity.csv');

### Convert the given Data in a Interval No./Day No. data frame:
### Each Day is treated as a variable and goes in a single column
### while each Interval is treated as an observation and holds a single row.
### We do that by using the melt and dcast commands of reshape2 package:
library(reshape2);
stepMelt <- melt(Data,id = c("interval","date"), measure.vars = "steps");
pre_stepData <- dcast(stepMelt, interval ~ date);
stepData <- pre_stepData[,2:62];
rownames(stepData) <- pre_stepData[,1]; 


## What is mean total number of steps taken per day?

### 1. Make a histogram of the total number of steps taken each day:
totalStepsperDay <- colSums(stepData, na.rm = TRUE, dims = 1);
#### DayNames <- colnames(stepData)
#### Create Time Axis. Read Time Strings in POSIXlt time format.
# DayTime <- strptime(DayNames, "%Y-%m-%d")
plot(totalStepsperDay, type = "h", xlab = "Day Index", ylab = "Total Steps per Day",
                                   main = "Histogram of Total Number of Steps per Day" )

### 2. Calculate and report the mean and median total number of steps taken per day:
meanTotalperDay   <-   mean(totalStepsperDay, na.rm = TRUE)
medianTotalperDay <- median(totalStepsperDay, na.rm = TRUE)

## What is the average daily activity pattern?
### 1. Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the 
###    average number of steps taken, averaged across all days (y-axis)
meanStepsperInterval <- rowMeans(stepData, na.rm = TRUE, dims = 1);
plot(meanStepsperInterval, type = "l", xlab = "5' Interval Index", 
                 ylab ="Average Number of Steps", main = "Time Series of Walking Activity per 5' Interval")

### 2. Which 5-minute interval, on average across all the days in the dataset, contains the 
###    maximum number of steps?
which.max(meanStepsperInterval)


## Imputing missing values
### 1. Calculate and report the total number of missing values in the dataset (i.e. the total
###    number of rows with NAs).
missingval<- is.na(stepData);
Aux1<-colSums(missingval, na.rm = TRUE, dims = 1);
TotalNAs<- sum(Aux1)


### 2. Devise a strategy for filling in all of the missing values in the dataset. The strategy does
###    not need to be sophisticated. For example, you could use the mean/median for that day, or the 
###    mean for that 5-minute interval, etc.
###    Here we fill the missing values with the corresponding average value for each interval.
filledStepData <- pre_stepData;
for (i in 1:288) {
  for (j in 1:62) {
    if(is.na(filledStepData[i,j]))
      filledStepData[i,j] <- meanStepsperInterval[i];
  }
}


### 3. Create a new dataset that is equal to the original dataset but with the missing data filled in.
SecondDataSet <- melt(filledStepData, id = "interval")


### 4. Make a histogram of the total number of steps taken each day and ...
totalStepsperDay2 <- colSums(filledStepData[,2:62], dims = 1);
plot(totalStepsperDay2, type = "h", xlab = "Day Index", ylab = "Total Steps per Day",
                        main = "Histogram of Total Number of Steps per Day Using 2nd Dataset")

### ... Calculate and report the mean and median total number of steps taken per day. Do these values 
### differ from the estimates from the first part of the assignment? What is the impact of imputing missing 
### data on the estimates of the total daily number of steps?
meanTotalperDay2   <-   mean(totalStepsperDay2, na.rm = TRUE)
medianTotalperDay2 <- median(totalStepsperDay2, na.rm = TRUE)


## Are there differences in activity patterns between weekdays and weekends?
### 1. Create a new factor variable in the dataset with two levels – “weekday” and “weekend” indicating
### whether a given date is a weekday or weekend day.
Days   <- strptime(SecondDataSet$variable, "%Y-%m-%d")
DayInd <- vector("character",length = nrow(SecondDataSet))

for (i in 1:nrow(SecondDataSet)) {
  if(weekdays(Days[i]) == "ÓÜââáôï" || weekdays(Days[i]) == "ÊõñéáêÞ") 
    DayInd[i] <- "Weekend"
  else
    DayInd[i] <- "Weekday"
}

DayClass      <- as.factor(DayInd);
ExtSecDataSet <- cbind(SecondDataSet,DayClass)

### 2. Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) 
###    and the average number of steps taken, averaged across all weekday days or weekend days (y-axis).
library(plyr)
AverageWeeklyAct<-ddply(ExtSecDataSet, .(interval, DayClass), summarise, av_act = mean(value))
AveWeekend <- AverageWeeklyAct[AverageWeeklyAct$DayClass == "Weekend" ,]
AveWeekday <- AverageWeeklyAct[AverageWeeklyAct$DayClass == "Weekday" ,]

### Finally, plot the average walking activity per weekend or weekday intrval:
par(mfrow = c(2, 1), mar = c(2, 3, 0.0, 0.5), oma = c(1,0.5,2,0.5), mgp = c(1,0.25,0), tcl = -0.25
    , cex.axis = 0.8, bg = "lightgray")
plot(AveWeekend$av_act, type = "l", xlab = "" , ylab = "Weekend", col = "black", ylim=c(0,250)
     , xaxt = "n", lwd = 2)
grid(nx = NULL, ny = NULL, col = "gray", lty = "dotted", lwd = par("lwd"))
plot(AveWeekday$av_act, type = "l", xlab = "5 min Interval Index", ylab = "Weekday", col = "red" 
     , ylim=c(0,250) , lwd = 2)
grid(nx = NULL, ny = NULL, col = "gray", lty = "dotted", lwd = par("lwd"))
mtext("Walking Activity Profiles (in Average Number of Steps)", outer = TRUE, font = 2)
                                                                         
### Since knitR cannot knit the combined plot correctly, I broke down the above plot in two
### dinstinct plots:
### Weekend Activity Plot:
par(mfrow = c(1, 1), mar = c(2, 3, 0.0, 0.5), oma = c(1,0.5,2,0.5), mgp = c(1,0.25,0), tcl = -0.25
                                            , cex.axis = 0.8, bg = "lightgray")
plot(AveWeekend$av_act, type = "l", xlab = "5 min Interval Index", ylab = "Average Number of Steps"
                                  , col = "black", ylim=c(0,250), lwd = 2)
grid(nx = NULL, ny = NULL, col = "gray", lty = "dotted", lwd = par("lwd"))
mtext("Weekend Walking Activity Profile", outer = TRUE, font = 2)

### Weekday Activity Plot:
plot(AveWeekday$av_act, type = "l", xlab = "5 min Interval Index", ylab = "Average Number of Steps"
                                  , col = "red" , ylim=c(0,250) , lwd = 2)
grid(nx = NULL, ny = NULL, col = "gray", lty = "dotted", lwd = par("lwd"))
mtext("Weekday Walking Activity Profile", outer = TRUE, font = 2)