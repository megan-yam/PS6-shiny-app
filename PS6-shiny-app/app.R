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
    tabPanel("Plot", 
             sidebarLayout(
               sidebarPanel(
                 radioButtons("color",
                              "What color pallet would you like to see the data
                               presented in: ",
                              choices = c("pink", "black"),
                              selected = "pink"),
                 selectInput("independent",
                                    "What would you like the x-axis to be: ",
                                    choices = c("country_rank",
                                                "accuracy", "play_count", "level",
                                                "hours", "performance_points",
                                                "ranked_score", "ss", "ss", "s",
                                                "a", "watched_by", "total_hits"),
                                    selected = "country_rank")
               ),
               mainPanel(
                 plotOutput("distPlot"),
                 textOutput("plotObservation")
               )
             )
    ),
    tabPanel("Tables",
             sidebarLayout(
               sidebarPanel(
                 radioButtons("tableValues",
                              "What data would you like to see?",
                              choices = c("country", "device"),
                              selected = "country")
               ),
               mainPanel(
                 
               )
             )
      )
  )
)

server <- function(input, output) {

    output$sample <- renderTable({
        osuranking %>%
          sample_n(size = 5, replace = TRUE) %>%
          arrange(rank)
    })
    
    output$distPlot <- renderPlot({
      osuranking %>% 
        ggplot(aes(x = rank, y = get(input$independent), color = input$color)) +
        geom_point() +
        labs(title = paste("osu! rank according to", input$independent), 
             x = paste(input$independent),
             y = "osu! rank",
             color = "color")
    })
    
    output$plotObservation <- renderPrint({
      num <- osuranking %>% 
        select(input$independent) %>%
        nrow()
      cat("There are ", num, " observations contributing to this plot")
    })
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)
