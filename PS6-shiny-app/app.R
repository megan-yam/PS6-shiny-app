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

ui <- fluidPage(
  tabsetPanel(
    tabPanel("About",
             titlePanel("Analyzing osu! ranking"),
             p("osu! is a rhythm game in which players hit circles to the beat
               of a song!"),
             p("The data set used showcases the top 100 osu! players, as of 
                October 26th, 2017, and infomation regarding their gameplay."),
             p("Here is a small random sample of data!"),
             tableOutput("sample")),
    tabPanel("Plots"),
    tabPanel("Tables")
  )
)

server <- function(input, output) {

    output$sample <- renderTable(
        osuranking %>%
          sample_n(size = 5, replace = TRUE) %>%
          arrange(rank)
    )
    
}

# Run the application 
shinyApp(ui = ui, server = server)
