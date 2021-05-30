library(shiny)
library(dplyr)
library(ggplot2)

data <- read.csv("data/GeneralEsportData.csv")

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
    
    output$obs <- renderTable({
        head(genreInput(), n = isolate(input$obs))
    })
    
    ## -------------------------------------
    ## Darren's Code: Total Earnings vs Total Tournaments
    
    # display drop down menu for genre
    output$genre <- renderUI({
        selectInput("genres", 
                    label = "Select Genre:",
                    choices = unique(data$Genre)
        )
    })
    
    # display slider input range for release date
    output$time <- renderUI({
        sliderInput("release",
                    label = "Release Date Range:",
                    min = min(data$ReleaseDate),
                    max = max(data$ReleaseDate),
                    value = c(1990, 2010),
                    step = 1,
                    sep = ""
        )
    })
    
    # creates the scatter plot of total earnings vs total tournaments
    scatterPlot <- reactive({
        require(scales)
        plotData <- data %>% 
            filter(Genre == input$genres) %>% 
            filter(ReleaseDate > input$release[1]) %>% 
            filter(ReleaseDate < input$release[2])
        
        ggplot(plotData, aes(TotalTournaments, TotalEarnings)) +
            geom_point(aes(col = plotData$Game)) +
            labs(x = "Total Tournaments",
                 y = "Total Earnings (US Dollars)",
                 title = "Total Earnings (US Dollars) vs Total Tournaments") +
            scale_y_continuous(labels = comma) +
            theme(legend.position = "bottom") +
            theme(aspect.ratio = 1)
    })
    
    output$plot <- renderPlot({
        scatterPlot()
    })
    
    ## -------------------------------------
    
})