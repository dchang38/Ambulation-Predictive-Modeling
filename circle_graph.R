library(tidyverse)

hd <- read.csv("data_files/historical_details.csv",
               header =TRUE)
pi <- read.csv("data_files/patient_info.csv",
               header =TRUE)
hd$hms <- format(hd$time_of_day, format = "%H:%M:%S")
ggplot(hd, aes(x=hours_of_stay, y=ï..patient_ID, size=distance)) +
  geom_point(alpha=0.2) +
  scale_size_continuous(range = c(0.5, 16)) +
  xlim(0, 15)