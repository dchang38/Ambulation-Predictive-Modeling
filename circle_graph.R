library(tidyverse)

hd <- read.csv("data_files/historical_details.csv",
               header =TRUE)
pi <- read.csv("data_files/patient_info.csv",
               header =TRUE)
max_hour <- max(hd$hours_of_stay, na.rm=TRUE)
max_day <- max(hd$Day.on.Unit, na.rm=TRUE)
discharge_hours <- (pi$length_of_stay.days. * 24)
discharge_dates <- data.frame(patient_id = pi$patient_ID, discharge = discharge_hours)
ggplot(hd, aes(x=hours_of_stay, y=patient_ID, size=distance^(1/.7))) +
  geom_point(alpha=0.2) +
  scale_size_continuous(range = c(0.5, 10)) +
  geom_point(data=discharge_dates, aes(x=discharge, y=patient_id), inherit.aes = FALSE, color='red') +
  scale_x_continuous(breaks=seq(0,max_hour,24)) +
  ggtitle("Patient Ambulation Distance by Time") +
  xlab("Hour of Stay") + 
  ylab("Patient ID")

