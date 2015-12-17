library(markdown)
library(shiny)
shinyUI(navbarPage("ShinyApp!",
    tabPanel("Run App",
        titlePanel("Test Normality of distribution of sample averages"),
        sidebarLayout(
            
  
             sidebarPanel(
 
                 br(),
                 br(),
                 helpText("Enter the exponential distribution parameters and number of simulations below."),
                 numericInput (inputId="lambdaval",label="Input Lambda",value=0.2,min=0.0001,max=10000),
                 numericInput (inputId="nsampval", label="Sample size",value=40,min=10,max=200),
                 numericInput (inputId="nsimval", label="Number of simulations",value=1000,min=1,max=10000),
                 submitButton("Submit")
            ),
        
            mainPanel(
                 plotOutput("newHist"),
#                 p('Output SampleMean is'),
                 textOutput('sampmean'),
#                 p('Output Population Mean is'),
                 textOutput('popmean'),
#                 p('Output % difference between the means is'),
                 textOutput('dif'),
br(),
br(),
                 textOutput('mesg1')
            )
        )

    ),
    tabPanel("Help",
#             helpText(a("Click here for Documentation", target="_blank",href="shinyapp.html")),
        includeHTML("shinyapp.html")
    )
))