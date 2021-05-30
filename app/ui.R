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
               tabPanel("Analysis",
                        textOutput("analysis")
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
                           tableOutput("obs")
                       )
                   )
               ),
               ## -------------------------------------
               ## Darren's Code
               tabPanel(
                  "Total Earnings vs Total Tournaments",
                  sidebarLayout(
                    sidebarPanel(
                     # drop down for genre type
                     uiOutput("genre"),
                     # slider input range for release date
                     uiOutput("time")
                   ),
                   
                   # Show a plot of the generated distribution
                   mainPanel(
                     plotOutput("plot")
                   )
                  )
               ),
               ## -------------------------------------
               ## Harrison's Code
               tabPanel("harrison's panel (change name)"
                        # your code here
               ),
               
               ## -------------------------------------
               ## Ryan's Code
               tabPanel("ryan's panel (change name)"
                        # your code here
               )
               ## -------------------------------------
    )
  )
)