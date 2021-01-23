#Cek beberapa data dari file counties.rds
#counties <- readRDS("D:/Kuliah/Skripsi/Learn Shiny/App-5/data/counties.rds")
#head(counties)
#source("D:/Kuliah/Skripsi/Learn Shiny/App-5/helpers.R")
#counties <- readRDS("D:/Kuliah/Skripsi/Learn Shiny/App-5/data/counties.rds")
#percent_map(counties$white, "darkgreen", "% White")

library(shiny)
library(maps)
library(mapproj)
source("helpers.R")
counties <- readRDS("data/counties.rds")

# Define UI for app that draws a histogram ----
ui <- fluidPage(
  titlePanel("censusVis"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with 
        information from the 2010 US Census."),
      
      selectInput("var", 
                  label = "Choose a variable to display",
                  choices = c("Percent White" = "white",
                              "Percent Black" = "black",
                              "Percent Hispanic" = "hispanic",
                              "Percent Asian" = "asian"),
                  selected = "white"),
      
      sliderInput("range", 
                  label = "Range of interest:",
                  min = 0, max = 100, value = c(0, 100))
    ),
    
    mainPanel(plotOutput("map"))
  )
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {
  output$map <- renderPlot({
    data <- switch(input$var, 
                   "white" = counties$white,
                   "black" = counties$black,
                   "hispanic" = counties$hispanic,
                   "asian" = counties$asian)
    
    color <- switch(input$var, 
                   "white" = "darkgreen",
                   "black" = "black",
                   "hispanic" = "darkorange",
                   "asian" = "darkviolet")
    #percent_map(data, "darkorange", paste("% ",input$var))
    percent_map(var = data, color = color, legend.title = paste("% ",input$var), max = input$range[2], min = input$range[1])
  })
  
}

# Run App
shinyApp(ui = ui, server = server)