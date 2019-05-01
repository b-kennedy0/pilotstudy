library(shiny)
library(ggplot2)
library(dplyr)

dataset <- read.csv("app_data.csv")

ui <- fluidPage(

    titlePanel("Pilot Data Explorer"),

    sidebarLayout(
        sidebarPanel(
            selectInput('x', 'X', sort(unique(dataset$Job))),
            selectInput('y', 'Y', sort(unique(dataset$Job)))
        ),

        mainPanel(
           plotOutput("plot"),
           tableOutput("jobcodes")
        )
    )
)

# Define server logic required
server <- function(input, output) {

    output$plot <- renderPlot({
        
    dataset <- dataset %>% filter(Job == input$x | Job == input$y)

    p <- ggplot(dataset, aes(x=Characteristic, y=Response, shape=Job, colour=Gender)) + geom_point(size=6) + labs(title=paste(input$x, "compared with", input$y, sep=" ")) + theme(axis.text = element_text(size = 12), axis.title=element_text(size=14,face="bold"), plot.title = element_text(size = 18, face = "bold"))
    
    print(p)
    })
    output$jobcodes <- renderTable({
        tabledata <- read.csv("jobcodes.csv")
        colnames(tabledata)[2] <- "Full Job Name"
        tabledata[-c(3:4)]
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
