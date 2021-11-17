#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


shinyUI(fluidPage(

    # Application title
    # titlePanel("Cyber Threats to Cyber Techniques to Kill Chain"),
    titlePanel(h1("Which tactics in the 'cyber kill chain' does this threat actor exploit?",
                  h3("Threat -> Techniques -> Tactics"),
                     h5("Data Source: https://attack.mitre.org"))),
    
    selectInput(inputId = "targetAPT", 
                label = "Select a Cyber Threat Actor:",
                APT$name),
    sankeyNetworkOutput(outputId = "plot"),
    fluidPage(h3('Objects shown in the graph')),
    dataTableOutput("table"),
))
