## Derek Chang and Dante Navarro
## JHU INBT Lab Patient Ambulation Predictive Modeling Study
## 2019

## load data from local csv file
df <- read.csv("data_files/patient_info.csv",
                 header =TRUE)
df$weekday <- weekdays(as.Date(df$admission_date)) ## get days of the week for admission
df
