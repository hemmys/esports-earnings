library(shiny)

shinyUI(fluidPage(
    # Navigation Bar
    navbarPage("Esports Earnings",
               tabPanel("About",
                        column(4,
                               includeMarkdown("readme.Rmd")
                        )
               ),
               ## -------------------------------------
               ## Analysis
               tabPanel("Conclusion",
                        
                        textOutput("AnalysisTitle"), br(),
                        textOutput("Tab1"), br(),
                        textOutput("Tab2"), br(),
                        textOutput("Tab3"), br(),
                        textOutput("Tab4"), br(),
                        textOutput("implications"), br(),
                        textOutput("dataQuality"), br(),
                        textOutput("advancements"), br(),
               ),
               ## -------------------------------------
               ## Claudine's Code: Genre Observations
               tabPanel(
                   "Genre Observations", sidebarLayout(
                       sidebarPanel(
                           uiOutput("chooseGenre"),
                           # Input: Specify the number of observations to view ----
                           numericInput("obs", "Number of observations to view:", 10),
                           
                           # Input: actionButton() to defer the rendering of output ----
                           # until the user explicitly clicks the button (rather than
                           # doing it immediately when inputs change). This is useful if
                           # the computations required to render output are inordinately
                           # time-consuming.
                           actionButton("update", "Update View")
                       ),
                       
                       # Main panel for displaying outputs ----
                       mainPanel(
                           
                           # Output: Header + summary of distribution ----
                           h4("Summary"),
                           verbatimTextOutput("summary"),
                           
                           # Output: Header + table of distribution ----
                           h4("Observations"),
                           tableOutput("obs"),
                           
                           # Description Area
                           br(),
                           
                           p(strong("Data Table Visualization:"), "Using a data table given a certain amount of observations
                           is appropriate for a selection of a specific genre versus the total online earnings and total tournament earnings
                             because it will also give data of factors such as specific game, release date, total players, and total tournaments."),
                           
                           p(strong("Helpful Usage Tips:"), "As you can see in the summary, each genre has a specific numerical value of 'Length',
                             meaning that that numerical value is the max amount of observations you can observe in that specific genre. Make sure
                             that whenever you change the genre and/or amount of observations, you press 'Update View' to update Observations and Summary.")
                       )
                   )
               ),
               ## -------------------------------------
               ## Darren's Code
               tabPanel(
                  "Total Tournaments vs Total Earnings",
                  sidebarLayout(
                    sidebarPanel(
                     # drop down for genre type
                     uiOutput("genre"),
                     # slider input range for release date
                     uiOutput("time"),
                     h4("Description"),
                     p("The scatter plot displayed shows the relationship between the total earnings and the 
                        total number of tournaments for the chosen genre of games and the selected release year
                        range. Each individual game is unique with its own color. Users are allowed to change the 
                        game genre with the drop down menu and adjust the release year range with the slider."),
                     br()
                     ),
                   
                   # Show a plot of the generated distribution
                   mainPanel(
                     plotOutput("plot"),
                     plotOutput("legend")
                   )
                 )
               ),
               ## -------------------------------------
               ## Harrison's Code
               tabPanel("Genre vs Total Earnings",
                        
                        # Sidebar for users to select Genre
                        sidebarLayout(
                          sidebarPanel("Options",
                                       
                                       selectInput("Genre", "Select Genre", 
                                                   c("Battle Royale", "Collectible Card Game", 
                                                     "Fighting Game", "First-Person Shooter", 
                                                     "Multiplayer Online Battle Arena", 
                                                     "Puzzle Game", "Racing", "Role-Playing Game", 
                                                     "Sports", "Strategy", "Third-Person Shooter"), 
                                                   selected = "Fighting Game")
                                       
                          ),
                          
                          # Show a plot of the generated data
                          mainPanel(
                            
                            plotOutput("GenrePlot"),
                            
                            br(), br(), br(), br(),
                            
                            textOutput("Title"),
                            
                            br(),
                            
                            textOutput("Description"), 
                            
                            br(), 
                            
                            textOutput("Descend")
                          )
                        )
               ),
               
               ## -------------------------------------
               ## Ryan's Code
               tabPanel(
                 "Year vs Total Earnings",
                 sidebarLayout(
                   sidebarPanel(

                     selectInput("yearInput", "Select Year",
                                 choices = 1993:2019),

                   ),
                   

                   mainPanel(

                     plotOutput("earningsPlot"),
                     br(),
                     textOutput("earningsDescription")
                   )
                 )
               )
               ## -------------------------------------
    )
  )
)