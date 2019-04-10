## Predicitve Modeling

#### FROM HISTORICAL
historical <- read.csv("data_files/historical_details_withdayonunit.csv",
                       header =TRUE)

distance = historical$distance
duration = historical$duration
speed = historical$speed

#### FROM FINAL COHORTS
finalPatients <- read.csv("data_files/Final_patients.csv",
                          header = FALSE, skip = 3)

finalPatients <- head(finalPatients,-3)

readmission = finalPatients$V4
location = finalPatients$V5
icu = finalPatients$V6

#### FROM PATIENT INFO 
## load data from local csv file
patientInfo <- read.csv("data_files/patient_info.csv",
                        header =TRUE, skip = 0)

patientInfo <- head(patientInfo,-20)

admissionDays = patientInfo$admission_date
dischargeDays = patientInfo$discharge_date
transferDays = patientInfo$transfer_date

patientInfo$a2d <- (as.Date(transferDays, format="%m/%d/%Y") - as.Date(admissionDays, format="%m/%d/%Y"))
patientInfo$t2d <- (as.Date(dischargeDays, format="%m/%d/%Y") - as.Date(transferDays, format="%m/%d/%Y"))

for (i in 1:length(patientInfo)){
  patID = patientInfo$patient_ID[i]
  icunew = finalPatients$V6[patID]
  patientInfo$icuDay[i] <- icunew/24
}

for (i in 1:length(patientInfo)){
  if (patientInfo$a2d[i]>patientInfo$icuDay[i]){
    patientInfo$a2i[i] <- patientInfo$a2d[i] - patientInfo$icuDay[i]
  } else {
    patientInfo$a2i[i] <- 0
  }
  
}

patientInfo$dischargeWeekday <- weekdays(as.Date(dischargeDays, '%m/%d/%Y'))
patientInfo$transferWeekday <- weekdays(as.Date(transferDays, '%m/%d/%Y'))

transferWeekdays = patientInfo$transferWeekday
weekdays = patientInfo$dischargeWeekday
lengthOfStay = patientInfo$length_of_stay.days.
transferCounts = rep(0, 7)
counts = rep(0, 7)

my.array <- array(counts, dim=c(1,7))

for (i in 1:length(weekdays)){
  
  if (identical(weekdays[i], "Monday")){
    
    counts[1] = counts[1] + 1
    
  } else if (identical(weekdays[i], "Tuesday")){
    
    counts[2] = counts[2] + 1
    
  } else if (identical(weekdays[i], "Wednesday")){
    
    counts[3] = counts[3] + 1
    
  } else if (identical(weekdays[i], "Thursday")){
    
    counts[4] = counts[4] + 1
    
  } else if (identical(weekdays[i], "Friday")){
    
    counts[5] = counts[5] + 1
    
  } else if (identical(weekdays[i], "Saturday")){
    
    counts[6] = counts[6] + 1
    
  } else if (identical(weekdays[i], "Sunday")){
    
    counts[7] = counts[7] + 1
    
  } else {
    
  }
  
} 

for (i in 1:length(transferWeekdays)){
  
  if (identical(transferWeekdays[i], "Monday")){
    
    transferCounts[1] = transferCounts[1] + 1
    
  } else if (identical(transferWeekdays[i], "Tuesday")){
    
    transferCounts[2] = transferCounts[2] + 1
    
  } else if (identical(transferWeekdays[i], "Wednesday")){
    
    transferCounts[3] = transferCounts[3] + 1
    
  } else if (identical(transferWeekdays[i], "Thursday")){
    
    transferCounts[4] = transferCounts[4] + 1
    
  } else if (identical(transferWeekdays[i], "Friday")){
    
    transferCounts[5] = transferCounts[5] + 1
    
  } else if (identical(transferWeekdays[i], "Saturday")){
    
    transferCounts[6] = transferCounts[6] + 1
    
  } else if (identical(transferWeekdays[i], "Sunday")){
    
    transferCounts[7] = transferCounts[7] + 1
    
  } else {
    
  }
  
} 
df2 <- data.frame(dis=rep(c("Discharge", "Transfer"), each=7),
                  day= rep(c("Monday", "Tuesday","Wednesday","Thursday","Friday", "Saturday","Sunday")), 2,
                  count=c(counts, transferCounts))
df2$day <- factor(df2$day, levels=c("Monday", "Tuesday","Wednesday","Thursday","Friday", "Saturday","Sunday"))
head(df2)

df3 <- data.frame(los=lengthOfStay)
head(df3)

readmission <- head(readmission,-3)
df4 <- data.frame(read=readmission)
head(df4)

location <- head(location,-1)
df5 <- data.frame(loc=location)
head(df5)

df6 <- data.frame(spe=speed)
head(df6)

df7 <- data.frame(dis=distance)
head(df7)

df8 <- data.frame(dur=duration)
head(df8)

df9 <- data.frame(id=c(patientInfo$patient_ID),
                  a2i= c(patientInfo$a2i),
                  icuDay=c(patientInfo$icuDay),
                  t2d = c(patientInfo$t2d))
head(df9)

library(reshape2)
DF9 <- melt(df9, id.var="id")
#DF9<- DF9[seq(dim(df)[1],1),]

df2 <- data.frame(dis=rep(c("Discharge", "Transfer"), each=7),
                  day= rep(c("Monday", "Tuesday","Wednesday","Thursday","Friday", "Saturday","Sunday")), 2,
                  count=c(counts, transferCounts))
df2$day <- factor(df2$day, levels=c("Monday", "Tuesday","Wednesday","Thursday","Friday", "Saturday","Sunday"))
head(df2)
 
#### FROM HISTORICAL
historical <- read.csv("data_files/historical_details_withdayonunit.csv",
                        header =TRUE)

distance = historical$distance
duration = historical$duration
speed = historical$speed

#### FROM FINAL COHORTS
finalPatients <- read.csv("data_files/Final_patients.csv",
                          header = FALSE, skip = 3)
readmission = finalPatients$V4
location = finalPatients$V5
icu = finalPatients$V6

#### FROM PATIENT INFO 
## load data from local csv file
patientInfo <- read.csv("data_files/patient_info.csv",
               header =TRUE, skip = 0)

patientInfo <- head(patientInfo,-3)

admissionDays = patientInfo$admission_date
dischargeDays = patientInfo$discharge_date
transferDays = patientInfo$transfer_date

patientInfo$dischargeWeekday <- weekdays(as.Date(dischargeDays, '%m/%d/%Y'))
patientInfo$transferWeekday <- weekdays(as.Date(transferDays, '%m/%d/%Y'))


patientInfo$a2d <- as.Date(transferDays, format="%m/%d/%Y") - as.Date(admissionDays, format="%m/%d/%Y")
patientInfo$t2d <- as.Date(dischargeDays, format="%m/%d/%Y") - as.Date(transferDays, format="%m/%d/%Y")

for (i in 1:87){
  patID = patientInfo$patient_ID[i]
  icunew = finalPatients$V6[patID]
  patientInfo$icuDay[i] <- icunew/24
}

for (i in 1:86){
  if (patientInfo$a2d[i] > patientInfo$icuDay[i]){
    patientInfo$a2i[i] <- patientInfo$a2d[i] - patientInfo$icuDay[i]
  } else {
    patientInfo$a2i[i] <- 0
  }
    
}

df8 <- data.frame(id=c(patientInfo$patient_ID),
                  a2i= c(patientInfo$a2i),
                  icuDay=c(patientInfo$icuDay),
                  t2d = c(patientInfo$t2d))
head(df8)

df8 <- head(df8,-20)

library(reshape2)
DF8 <- melt(df8, id.var="id")

transferWeekdays = patientInfo$transferWeekday
weekdays = patientInfo$dischargeWeekday
lengthOfStay = patientInfo$length_of_stay.days.
transferCounts = rep(0, 7)
counts = rep(0, 7)

my.array <- array(counts, dim=c(1,7))

for (i in 1:length(weekdays)){
  
  if (identical(weekdays[i], "Monday")){
    
    counts[1] = counts[1] + 1
    
  } else if (identical(weekdays[i], "Tuesday")){
    
    counts[2] = counts[2] + 1
    
  } else if (identical(weekdays[i], "Wednesday")){
    
    counts[3] = counts[3] + 1
    
  } else if (identical(weekdays[i], "Thursday")){
    
    counts[4] = counts[4] + 1
    
  } else if (identical(weekdays[i], "Friday")){
    
    counts[5] = counts[5] + 1
    
  } else if (identical(weekdays[i], "Saturday")){
    
    counts[6] = counts[6] + 1
    
  } else if (identical(weekdays[i], "Sunday")){
    
    counts[7] = counts[7] + 1
    
  } else {
    
  }
  
} 

for (i in 1:length(transferWeekdays)){
  
  if (identical(transferWeekdays[i], "Monday")){
    
    transferCounts[1] = transferCounts[1] + 1
    
  } else if (identical(transferWeekdays[i], "Tuesday")){
    
    transferCounts[2] = transferCounts[2] + 1
    
  } else if (identical(transferWeekdays[i], "Wednesday")){
    
    transferCounts[3] = transferCounts[3] + 1
    
  } else if (identical(transferWeekdays[i], "Thursday")){
    
    transferCounts[4] = transferCounts[4] + 1
    
  } else if (identical(transferWeekdays[i], "Friday")){
    
    transferCounts[5] = transferCounts[5] + 1
    
  } else if (identical(transferWeekdays[i], "Saturday")){
    
    transferCounts[6] = transferCounts[6] + 1
    
  } else if (identical(transferWeekdays[i], "Sunday")){
    
    transferCounts[7] = transferCounts[7] + 1
    
  } else {
    
  }
  
} 

counts
transferCounts

dat <- read.table(text = "Monday   Tuesday   Wednesday   Thursday   Friday   Saturday    Sunday
1 18 22 17 15 13 10  13
                  2 5 16 16 23 21 13 13", header = TRUE)
mat = as.matrix(dat)

#barplot(mat, main = "Date", col=terrain.colors(2), beside = TRUE)
#legend("topright", c("Discharge","Transfer"), fill=terrain.colors(2))
#barplot(counts, main="Discharge Date", horiz=FALSE,
        #names.arg=c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
        #, cex.names=0.5)

#hist(lengthOfStay,  main = "Length of Stay", xlab = "Length of Stay (Days)", las =1, breaks = 15)

#hist(readmission,  main = "Readmission", xlab = "Readmission", las =1, breaks = 2, col=terrain.colors(2))
#legend("topright", c("No","Yes"), fill=terrain.colors(2), horiz=TRUE)

#hist(location,  main = "Location", xlab = "Location", las =1, breaks = 2, col=terrain.colors(2))
#legend("topright", c("Home or Hotel","Rehab"), fill=terrain.colors(2), horiz=TRUE)

#hist(duration,  main = "Duration", las =1, breaks = 15)

#hist(distance,  main = "Distance", las =1, breaks = 25)

#hist(speed,  main = "Speed", las =1, breaks = 15)
#a2d = transferDays - admissionDays 


readmission <- head(readmission,-3)
df4 <- data.frame(read=readmission)
head(df4)
yesno = rep(0, length(readmission))
my.array <- array(yesno, dim=c(1,length(readmission)))

df3 <- data.frame(los=lengthOfStay)
head(df3)

readmission <- head(readmission,-3)
df4 <- data.frame(read=readmission)
head(df4)

location <- head(location,-1)
df5 <- data.frame(loc=location)
head(df5)

patientInfo$before <- (as.Date(admissionDays, format="%m/%d/%Y") - as.Date(firstAdmission, format="%m/%d/%Y"))

df10 <- data.frame(id=c(patientInfo$patient_ID),
                   a2i= c(patientInfo$a2i),
                   icuDay=c(patientInfo$icuDay),
                   t2d = c(patientInfo$t2d), 
                   before = c(patientInfo$before))

head(df10)

df10 <- head(df10,-20)
library(reshape2)
DF10 <- melt(df10)
DF10$variable <- factor(DF10$variable, levels=c("t2d", "icuDay","a2i", "before"))

library(ggplot2)

ggplot(DF10, aes(x = id, y = value, fill = variable)) +
  geom_bar(stat = "identity") + labs(y = "Time (Day)")
