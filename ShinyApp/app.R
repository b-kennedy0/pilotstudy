library(shiny)
library(ggplot2)
library(dplyr)

dataset <- read.csv("app_data.csv")

ui <- fluidPage(

    titlePanel("Pilot Data Explorer"),

    sidebarLayout(
        sidebarPanel(
            selectInput('x', 'Role 1', sort(unique(dataset$Job))),
            selectInput('y', 'Role 2', sort(unique(dataset$Job)))
        ),

        mainPanel(
           plotOutput("plot")
        )
    )
)

# Define server logic required
server <- function(input, output) {

    output$plot <- renderPlot({
        
    dataset <- dataset %>% filter(Job == input$x | Job == input$y)

    p <- ggplot(dataset, aes(x=Characteristic, y=Response, shape=Job, colour=Gender)) + geom_point(size=6) + labs(title=paste(input$x, "\n compared with \n", input$y, sep=" ")) + theme(axis.text = element_text(size = 12), axis.title=element_text(size=14,face="bold"), plot.title = element_text(size = 18, face = "bold"))
    
    print(p)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
