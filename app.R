library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)
library(reshape2)
# Define UI 

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
    tabPanel("Plot",
             h3("Scatter plot"),
             sidebarLayout(
               sidebarPanel(
                 width = 2,
                 selectInput("xvar", "X-axis variable", choices = c("Unemployment_rate", "Inflation_rate", "GDP")),
                 selectInput("yvar", "Y-axis variable", choices = c("Unemployment_rate", "Inflation_rate", "GDP"))
               ),
               mainPanel(
                 fluidRow(
                   offset = 2,
                   width = 5,
                   plotOutput("scatter_plot", height = "600px", width = "1000px"),
                   verbatimTextOutput("corr_info")
                   
                 )
               )
             ),
             h4("Therefore, unemployment rate, inflation rate and GDP have nearly no relationship to the academic success of students.")
    ),
    
    tabPanel("Table",
             sidebarPanel(
               h4("Pivot Table Filters"),
               checkboxGroupInput("col_select",
                                  "Select Columns to Summarize:",
                                  choices = names(data)[sapply(data, is.character)],
                                  selected = names(data)[sapply(data, is.character)][1:2]),
             ),
             h3("Value count by target variable"),
             tableOutput("pivot_table")
    )
    
  )
)

# Define server
server <- function(input, output) {
  
  
  output$target_counts <- renderTable(
    {
      table(data$Target)
    }
  )
  
  output$corr_info <- renderPrint({
    # Select the data based on x and y variable selections
    cor <- data.frame(x = data[[input$xvar]], y = data[[input$yvar]], target = data$Target)
    
    # Compute the correlation value
    corr <- cor(cor$x, cor$y)
    
    # Return the correlation information
    paste("The correlation between", input$xvar, "and", input$yvar, "is", round(corr, 2))
  })
  
  # Function to create scatter plot
  createScatterPlot <- function(xvar, yvar, data) {
    ggplot(data, aes_string(x = xvar, y = yvar, color = "Target")) + 
      geom_point(size = 3) + 
      labs(x = xvar, y = yvar, title = paste0("Scatter plot of ", xvar, " vs. ", yvar), color = "Target") +
      theme_bw() +
      theme(plot.title = element_text(hjust = 0.5, vjust = 1))
  }
  
  # Scatter plot output
  scatter_data <- reactive({
    createScatterPlot(input$xvar, input$yvar, data)
  })
  
  output$scatter_plot <- renderPlot({
    scatter_data()
  })
  
  output$pivot_table <- renderTable({
    # Reshape the data into a pivot table
    data_pivot <- dcast(data, input$col_select ~ Target,length )
    
    # Set the size of the table
    options(paged.print = FALSE, width = 1000, height = 1000)
    
    data_pivot
  })
}

# Run the application
shinyApp(ui = ui, server = server)
