library(tidyverse)

df <- read.csv("data_files/historical_details.csv",
               header =TRUE)
df$patient_ID
ggplot(df, aes(x=ambulation, y=patient_ID, size=distance)) +
  geom_point(alpha=0.2)
