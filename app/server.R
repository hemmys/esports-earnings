library(shiny)
library(dplyr)

data <- read.csv("../data/GeneralEsportData.csv")

shinyServer(function(input, output) {
    
    ## Analysis
    output$analysis <- renderText({
        "hello"
    })
    ## -------------------------------------
    ## Claudine's Code: Genre Observations
    
    # Choose a genre
    output$chooseGenre <- renderUI({
        # Select a Genre
        selectInput("genre", "Choose a genre:", choices = unique(data$Genre))
    })
    
    genreInput <- eventReactive(input$update,{
        data %>%
            filter(Genre == input$genre)
    })
    
    # Generate a summary of the dataset
    output$summary <- renderPrint({
        dataset <- genreInput()
        summary(dataset)
    })
    
    output$view <- renderTable({
        head(genreInput(), n = isolate(input$obs))
    })
    ## -------------------------------------
    
})