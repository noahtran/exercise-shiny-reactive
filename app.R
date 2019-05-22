library(shiny)
library(shinythemes)
library(dplyr)
library(ggplot2)

# Data from the Social Security Administration
data <- read.csv("wa_unhealthy_air.csv", stringsAsFactors = FALSE)


# UI
ui <- fluidPage(
  titlePanel("WA Unhealthy Air"),
  
  # A few paragraphs to give context
  p("We are examining the percentage of days with unsafe PM2.5 percentages in different counties of Washington State."),
  p("PM2.5 refers to particles in the air that are tiny and dangerous to inhale."),
    
  sidebarLayout(
    sidebarPanel(
      # Put a widget here for the user to interact with!
      # You could filter by year, by county, etc.
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Plot", plotOutput("airQualityPlot")),
        tabPanel("Table", tableOutput("airQualityText"))
      )
    )
  )
)

# Server
server <- function(input, output) {
  # A plot of air quality
  # This can be over time, by county, etc.
  output$airQualityPlot <- renderPlot({
    
  })
  
  # A table of the filtered data
  output$airQualityTable <- renderTable({
    
  })
}

# Run the application
shinyApp(ui = ui, server = server)