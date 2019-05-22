library(shiny)
library(shinythemes)
library(dplyr)
library(ggplot2)

# Data from the Social Security Administration
data <- read.csv("wa_unhealthy_air.csv", stringsAsFactors = FALSE)

ui <- fluidPage(
  theme = shinytheme("superhero"),
  titlePanel("WA Unhealthy Air"),
  
  p("We are examining the percentage of days with unsafe PM2.5 percentages in different counties of Washington State."),
  p("PM2.5 refers to particles in the air that are tiny and dangerous to inhale."),
  p("We want to see how this has changed over time."),
    
  sidebarLayout(
    sidebarPanel(
      selectInput("chosenCounties",
                  label = "Counties to view:",
                  choices = unique(data$CountyName),
                  selected = unique(data$CountyName),
                  multiple = TRUE),
      
      sliderInput("chosenYears",
                  "Year",
                  min = min(data$ReportYear),
                  max = max(data$ReportYear),
                  value = c(min(data$ReportYear), max(data$ReportYear)),
                  sep = "",
                  step = 1)
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Plot over time", plotOutput("airQualityPlot")),

        tabPanel("Text summary", textOutput("airQualityText")),

        tabPanel("Table", tableOutput("airQualityTable"))
      )
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  chosen_data <- reactive({
    data %>%
      filter(CountyName %in% input$chosenCounties,
             ReportYear >= input$chosenYears[1],
             ReportYear <= input$chosenYears[2])
  })
  
  output$airQualityPlot <- renderPlot({
    chosen_data() %>% 
      ggplot() +
      geom_line(aes(x = ReportYear, y = Value, color = CountyName)) +
      labs(title = "Washington state air quality over time",
           subtitle = "Percent of days with PM2.5 levels over the National Ambient Air Quality Standard (NAAQS)",
           x = "Year",
           y = "Percent of unsafe days")
  })
  
  output$airQualityText <- renderText({
    lowest <- chosen_data() %>% 
      group_by(CountyName) %>% 
      summarize(mean_percent = mean(Value)) %>% 
      filter(mean_percent == min(mean_percent))
    
    paste0("For chosen years and chosen counties, the average percent of days with PM2.5 levels over the air quality standard was ",
           round(mean(chosen_data()$Value), 2), "%. ",
           "The county with the lowest percentage of unsafe days was ", lowest$CountyName, " at ", round(lowest$mean_percent, 2), "%!")
  })
  
  output$airQualityTable <- renderTable({
    chosen_data()
  })
}

# Run the application
shinyApp(ui = ui, server = server)