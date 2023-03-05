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
             p(em("osu!"),  " is a rhythm game in which players hit circles to the beat
               of a song!"),
             p("The data set used showcases the top 100 osu! players, as of ",
                em("October 26th, 2017")," and information regarding their gameplay."),
             p("The data set contains ", nrow(osuranking), " observations and ",
               ncol(osuranking), " variables"),
             p("Here is a small", strong("random"), "sample of data!"),
             tableOutput("sample")),
    tabPanel("Plot", 
             sidebarLayout(
               sidebarPanel(
                 radioButtons("color",
                              "What color would you like to see the data
                               presented in: ",
                              choices = list("RdYlGn", "PRGn"), 
                              selected = "RdYlGn"),
                 selectInput("dependent",
                                    "What would you like the y-axis to be: ",
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
                 selectInput("tableValues",
                              "What country would you like to see data from?",
                              choices = c(unique(osuranking$country)),
                              selected = "South Korea")
               ),
               mainPanel(
                 tableOutput("table"),
                 textOutput("tableInfo")
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
        ggplot(aes(x = rank, y = get(input$dependent), color = input$color)) +
        geom_point() +
        scale_color_brewer(palette = input$color) +
        labs(title = paste("osu! rank according to", input$dependent), 
             x = "osu! rank",
             y = paste(input$dependent),
             color = "color")
    })
    
    output$plotObservation <- renderPrint({
      cat("The average ", input$dependent, "is ",
            mean(osuranking[[input$dependent]]))
    })
    
    output$table <- renderTable({
      osuranking %>%
        filter(country == input$tableValues)
    })
    
    output$tableInfo <- renderPrint({
      num <- osuranking %>%
        filter(country == input$tableValues) %>%
        filter(country %in% input$tableValues) %>%
        nrow()
      
      cat("There are ", num, " players in ", input$tableValues)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
