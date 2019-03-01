library(tidyverse)

hd <- read.csv("data_files/historical_details.csv",
               header =TRUE)
pi <- read.csv("data_files/patient_info.csv",
               header =TRUE)
max_hour <- max(hd$hours_of_stay, na.rm=TRUE)
max_day <- max(hd$Day.on.Unit, na.rm=TRUE)
hd$hms <- format(hd$time_of_day, format = "%H:%M:%S")
ggplot(hd, aes(x=hours_of_stay, y=ï..patient_ID, size=distance)) +
  geom_point(alpha=0.2) +
  scale_size_continuous(range = c(0.5, 10)) +
  scale_x_continuous(breaks=seq(0,max_hour,24))
ggplot(hd, aes(x=Day.on.Unit, y=ï..patient_ID, size=distance)) +
  geom_point(alpha=0.2) +
  scale_size_continuous(range = c(0.5, 10)) +
  scale_x_continuous(breaks=seq(0,max_day,1))
