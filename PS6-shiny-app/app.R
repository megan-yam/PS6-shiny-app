#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)

osuranking <- read_delim("data/osuranking.csv")

# Define UI for application that draws a histogram
ui <- fluidPage(
  tabsetPanel(
    tabPanel("About",
             titlePanel("About osu! ranking"),
             p("osu! is a rhythm game in which players hit circles to the beat
               of a song!"),
             p("The data set used showcases the top 100 osu players, as of 
                October 26th, 2017, and infomation regarding their gameplay."),
             p("Here is a small random sample of data!"))
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
