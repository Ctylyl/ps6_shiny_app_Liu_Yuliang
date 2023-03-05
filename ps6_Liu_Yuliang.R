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
ui <- fluidPage(
  tabsetPanel(
    tabPanel("Information",
             h2("Students college and market index Dataset"),
             p("This dataset contains information about individuals who have either dropped out of college, graduated, or are currently enrolled."),
             p("Some important variables included in this dataset are:"),
             HTML("<ul>
                 <li>Target: College enrollment status (Dropout/Graduate/Enrolled)</li>
                 <li>Marital Status: Whether the individual is married or not</li>
                 <li>Age: Age of the individual</li>
                 <li>Scholarship: Whether the individual holds any scholarship</li>
                 <li>Grades: Semester-wise grade point average</li>
                 <li>Unemployement rate: Percentage of people unemployeed</li>
                 <li>Inflation rate: Price Index value</li>
                 <li>GDP: Gross domestic product (Market Value)</li></ul>"),
             br(),
             # Add dataset information
             p(paste("The dataset contains ", nrow(data), " rows and ", ncol(data), " columns.")),
             br(),
             h4("Data Quality"),
             br(),
             p(paste("The dataset contains ", sum(is.na(data)), " null values")),
             br(),
             h4("The count distribution for the target variable:"),
             # Display frequency distribution for target variable
             tableOutput("target_counts")
    ),

