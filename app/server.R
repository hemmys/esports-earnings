library(shiny)
library(dplyr)
library(ggplot2)
library(grid)
library(gridExtra) 

data <- read.csv("data/GeneralEsportData.csv")

shinyServer(function(input, output) {
    
    ## Analysis
    output$AnalysisTitle <- renderText({
        paste("Data Analysis")
    })
    
    output$Tab1 <- renderText({
        paste("Analysis for first tab: ")
    })
    
    output$Tab2 <- renderText({
        paste("Analysis for second tab: ")
    })
    
    output$Tab3 <- renderText({
        paste("Analysis for third tab: There seems to be a slight correlation 
        between Genre and Total Earnings. The Sports and Racing genres have 
        significantly lower total earnings. Comparatively, the Fighting Game, 
        First and Third-Person Shooters, and Multiplayer Online Battle Arena 
        genres all had top earnings over 2 million dollars. This shows that 
        there is much stonger viewership, and therefore funds, for combat
        games in esports. Collectilbe Card Games and Strategy were two genres 
        that have moderate earnings(between sports and shooters) which is 
        interesting. Overall, First-Person Shooter was the genre that had 
        the most earnings among the top 5 games in said category.")
    })
    
    output$Tab4 <- renderText({
        paste("Analysis for fourth tab: ")
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
        # to remove commas in the axis intervals
        require(scales)
        
        # data manipulation
        plotData <- data %>% 
            select(TotalEarnings, TotalTournaments, Genre, ReleaseDate, Game) %>% 
            filter(ReleaseDate > input$release[1]) %>% 
            filter(ReleaseDate < input$release[2]) %>% 
            filter(Genre == input$genres)
        
        # creating the ggplot
        ggplot(plotData, aes(TotalTournaments, TotalEarnings)) +
            geom_point(aes(col = plotData$Game)) +
            labs(x = "Total Tournaments",
                 y = "Total Earnings (US Dollars)",
                 title = "Total Tournaments and their Total Earnings (US Dollars)") +
            scale_y_continuous(labels = comma) +
            theme(legend.position = "none") 
    })
    
    # creates the legend of the scatter plot as a whole new plot
    legendPlot <- reactive({
        # data manipulation
        plotData <- data %>% 
            select(TotalEarnings, TotalTournaments, Genre, ReleaseDate, Game) %>% 
            filter(ReleaseDate > input$release[1]) %>% 
            filter(ReleaseDate < input$release[2]) %>% 
            filter(Genre == input$genres)
        
        # creating the ggplot
        plot <- ggplot(plotData, aes(TotalTournaments, TotalEarnings)) +
            geom_point(aes(col = Game)) +
            labs(x = "Total Tournaments",
                 y = "Total Earnings (US Dollars)",
                 title = "Total Tournaments and their Total Earnings (US Dollars)") +
            scale_y_continuous(labels = comma) +
            theme(legend.position = "bottom") 
        
        # extracting the legend from the plot only so that the plot can be at a fixed size
        legend <- cowplot::get_legend(plot)
        
        grid.newpage()
        grid.draw(legend)
    })
    
    # renders plot to display
    output$plot <- renderPlot({
        scatterPlot()
    })
    
    # renders legend to display
    output$legend <- renderPlot({
        legendPlot()
    })
    
    ## -------------------------------------
    ## Harrison's Code
    
    output$GenrePlot <- renderPlot({
        
        #data manipulation
        GenreData <- data%>%
            select(Game, ReleaseDate, Genre, TotalEarnings)%>%
            arrange(desc(TotalEarnings))%>%
            group_by(Genre)%>%
            slice(1:5)%>%
            filter(Genre == input$Genre)
        
        #code for bar plot
        ggplot(GenreData, aes(x = reorder(Game, -TotalEarnings), 
                              y = TotalEarnings)) + 
            geom_bar(stat = 'identity', 
                     aes(fill = Game)) + 
            ggtitle("Total Earnings by Top 5 Games per Genre") + 
            theme(plot.title = element_text(size = 20, face = "bold"),
                  axis.title.x = element_text(size = 15),
                  axis.title.y = element_text(size = 15)) + 
            xlab("Top 5 Games in Selected Genre") + 
            ylab("Total Earnings (USD)") 
        
    })
    
    output$Description <- renderText({
        
        paste("This plot displays the Total Earnings per game in a user selected category. 
              I adapted the data set to include only the Game, Release Data, Genre, and Total Earnings, and 
              did this so that the data would be simpler when I plotted it. Using the ggbar function, 
              I plotted the name of the top five games on the x-axis, compared to the total earnings on the y-axis. 
              The data is reactive to user input when they choose the genre they want to observe, and the data
              changes to show only the top five games and total earnings for said genre.")
        
    })
    
    output$Descend <- renderText({
        
        paste( "I also made sure the bars descend, from highest on the left, in order of total earnings. 
              This makes the data easier to compare between games and genres because the auidence need only 
              look at the first, tallest bar to get some idea of the earings in each catergory.")
        
    })
    
    output$Title <- renderText({
        
        paste("Description")
        
})
    ##------------------------------------
    ## Ryan's Code

    years <- reactive({
        data %>% 
            filter(input$yearInput == ReleaseDate) %>% 
            select(Game, TotalEarnings) %>% 
            arrange(desc(TotalEarnings)) %>% 
            head(10)
    })

    output$earningsPlot <- renderPlot({
        ggplot(years(),aes(x = reorder(Game, -TotalEarnings), TotalEarnings, fill = Game))+
            geom_histogram(stat = 'identity')+
            theme(axis.text.x = element_text(angle = 90))+
            ggtitle("Total Earnings per game for a given year")+
            xlab("Game")+
            ylab("Total Earnings")
    })
    
    output$earningsDescription <- renderText({
        paste("This graph shows you the highest total earnings for the top 10 games in a specific year. 
              There is data available between the years of 1993 through 2010. 
              In some of the earlier years, there was not 10 games to show, so instead, it’ll show all available games. 
              Data is sorted so it’ll show it in descending order, meaning the highest earning game is on the far left. 
              The data defaults to 1993, but using the drop down bar, you can change the graph to show different years.")
    })
       

})