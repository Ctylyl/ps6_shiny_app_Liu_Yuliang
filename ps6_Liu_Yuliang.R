library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)
library(reshape2)
# Define UI 


# Set the working directory to the folder containing the CSV file
setwd("C:/Users/23917/Info201/Assignments/ps6_shiny_app_Liu_Yuliang")

# Read the CSV file and store it in a data frame called 'data'
data <- read.csv("data/dataset.csv")
data <- data.frame(data)
names(data) <- gsub("\\.", "_", names(data))

data['Marital_status'] = as.character(data['Marital_status'])
data['Application_mode'] = as.character(data['Application_mode'])
data['Daytime_evening_attendance'] = as.character(data['Daytime_evening_attendance'])
data['Nacionality'] = as.character(data['Nacionality'])
data['Scholarship_holder'] = as.character(data['Scholarship_holder'])
data['International'] = as.character(data['International'])

