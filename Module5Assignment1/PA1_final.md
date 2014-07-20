# Reproducible Research: Peer Assessment 1

## Loading and preprocessing the data

```r
Data <- read.csv('activity.csv');
```
### Convert the given Data in a Interval No./Day No. data frame:
### Each Day is treated as a variable and goes in a single column
### while each Interval is treated as an observation and holds a single row.
### This is done by use of the melt and dcast commands of reshape2 package:

```r
library(reshape2);
stepMelt <- melt(Data,id = c("interval","date"), measure.vars = "steps");
pre_stepData <- dcast(stepMelt, interval ~ date);
stepData <- pre_stepData[,2:62];
rownames(stepData) <- pre_stepData[,1]; 
```

## What is mean total number of steps taken per day?

### 1. Making of a histogram of the total number of steps taken each day:

```r
totalStepsperDay <- colSums(stepData, na.rm = TRUE, dims = 1);
plot(totalStepsperDay, type = "h", xlab = "Day Index", ylab = "Total Steps per Day"
                                 , main = "Histogram of Total Number of Steps per Day" )
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3.png) 

### 2. Calculation of the mean and median total number of steps taken per day:

```r
  meanTotalperDay <-   mean(totalStepsperDay, na.rm = TRUE)
medianTotalperDay <- median(totalStepsperDay, na.rm = TRUE)
meanTotalperDay
```

```
## [1] 9354
```

```r
medianTotalperDay
```

```
## [1] 10395
```

## What is the average daily activity pattern?
### 1. Making of a time series plot of the 5-minute interval (x-axis) and the 
###    average number of steps taken, averaged across all days (y-axis):

```r
meanStepsperInterval <- rowMeans(stepData, na.rm = TRUE, dims = 1);
plot(meanStepsperInterval, type = "l", xlab = "5' Interval Index", 
             ylab ="Average Number of Steps", main = "Time Series of Walking Activity per 5' Interval")
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5.png) 

### 2. Finding the 5-minute interval, on average across all the days in the dataset, contains the 
###    maximum number of steps:

```r
  which.max(meanStepsperInterval)
```

```
## 835 
## 104
```


## Imputing missing values
### 1. Calculation of the total number of missing values in the dataset (i.e. the total number of rows with NAs).

```r
  missingval <- is.na(stepData);
       Aux1 <-colSums(missingval, na.rm = TRUE, dims = 1);
   TotalNAs <- sum(Aux1)
TotalNAs
```

```
## [1] 2304
```

### 2. Here we fill the missing values with the corresponding average value for that interval.

```r
filledStepData <- pre_stepData;
for (i in 1:288) {
   for (j in 1:61) {
       if(is.na(filledStepData[i,j]))
             filledStepData[i,j] <- meanStepsperInterval[i];
   }
}
```

### 3. Creation of a new dataset that is equal to the original dataset but with the missing data filled in.

```r
SecondDataSet <- melt(filledStepData, id = "interval")
head(SecondDataSet)
```

```
##   interval   variable   value
## 1        0 2012-10-01 1.71698
## 2        5 2012-10-01 0.33962
## 3       10 2012-10-01 0.13208
## 4       15 2012-10-01 0.15094
## 5       20 2012-10-01 0.07547
## 6       25 2012-10-01 2.09434
```


### 4. Making of a histogram of the total number of steps taken each day.

```r
totalStepsperDay2 <- colSums(filledStepData[,2:62], na.rm = TRUE, dims = 1);
plot(totalStepsperDay2, type = "h", xlab = "Day #", ylab = "Total Steps per Day"
                      , main = "Histogram of Total Number of Steps per Day Using 2nd Dataset")
```

![plot of chunk unnamed-chunk-10](figure/unnamed-chunk-10.png) 

### Calculation of the mean and median total number of steps taken per day. 
### These values differ from the estimates from the first part of the assignment.
### The impact of imputing missing data on the estimates of the total daily number of steps
### is an increase on their mean and median values.

```r
meanTotalperDay2   <-   mean(totalStepsperDay2, na.rm = TRUE)
medianTotalperDay2 <- median(totalStepsperDay2, na.rm = TRUE)
meanTotalperDay2
```

```
## [1] 10590
```

```r
medianTotalperDay2
```

```
## [1] 10766
```

## There are noticeable differences in activity patterns between weekdays and weekends.
### 1. Creation of a new factor variable in the dataset with two levels – “weekday” and “weekend” 
### indicating whether a given date is a weekday or weekend day. This factor var. is named DayClass.

```r
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
```

### 2. Making of a panel plot containing a time series plot of the 5-minute interval (x-axis) 
###    and the average number of steps taken, averaged across all weekday days or weekend days (y-axis).

```r
library(plyr)
AverageWeeklyAct <- ddply(ExtSecDataSet, .(interval, DayClass), summarise, av_act = mean(value))
AveWeekend <- AverageWeeklyAct[AverageWeeklyAct$DayClass == "Weekend" ,]
AveWeekday <- AverageWeeklyAct[AverageWeeklyAct$DayClass == "Weekday" ,]
```

### Finally, plot the average walking activity:

```r
par(mfrow = c(2, 1), mar = c(2, 3, 0.0, 0.5), oma = c(1,0.5,2,0.5), mgp = c(1,0.25,0), tcl = -0.25
                                                                  , cex.axis = 0.8, bg = "lightgray")
plot(AveWeekend$av_act, type = "l", xlab = "" , ylab = "Weekend", col = "black", ylim=c(0,250)
                                                                , xaxt = "n", lwd = 2)
grid(nx = NULL, ny = NULL, col = "gray", lty = "dotted", lwd = par("lwd"))
plot(AveWeekday$av_act, type = "l", xlab = "5 min Interval Index", ylab = "Weekday", col = "red" 
                                                                 , ylim=c(0,250) , lwd = 2)
grid(nx = NULL, ny = NULL, col = "gray", lty = "dotted", lwd = par("lwd"))
mtext("Walking Activity Profiles", outer = TRUE, font = 2)
```

![plot of chunk unnamed-chunk-14](figure/unnamed-chunk-14.png) 

### Since knitR cannot knit the combined plot correctly, I broke down the above plot in two
### dinstinct plots:
### Weekend Activity Plot:

```r
par(mfrow = c(1, 1), mar = c(2, 3, 0.0, 0.5), oma = c(1,0.5,2,0.5), mgp = c(1,0.25,0), tcl = -0.25
                                                                  , cex.axis = 0.8, bg = "lightgray")
plot(AveWeekend$av_act, type = "l", xlab = "5 min Interval Index", ylab = "Average Number of Steps"
                                  , col = "black" , ylim=c(0,250), lwd = 2)
grid(nx = NULL, ny = NULL, col = "gray", lty = "dotted", lwd = par("lwd"))
mtext("Weekend Walking Activity Profile", outer = TRUE, font = 2)
```

![plot of chunk unnamed-chunk-15](figure/unnamed-chunk-15.png) 

### Weekday Activity Plot:

```r
par(mfrow = c(1, 1), mar = c(2, 3, 0.0, 0.5), oma = c(1,0.5,2,0.5), mgp = c(1,0.25,0), tcl = -0.25
                                                                  , cex.axis = 0.8, bg = "lightgray")
plot(AveWeekday$av_act, type = "l", xlab = "5 min Interval Index", ylab = "Average Number of Steps"
                                  , col = "black" , ylim=c(0,250) , lwd = 2)
grid(nx = NULL, ny = NULL, col = "gray", lty = "dotted", lwd = par("lwd"))
mtext("Weekday Walking Activity Profile", outer = TRUE, font = 2)
```

![plot of chunk unnamed-chunk-16](figure/unnamed-chunk-16.png) 
