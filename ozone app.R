library(shiny)
data("airquality")

ui <- fluidPage(
  
  titlePanel("Ozone level!"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      sliderInput(inputId = "bins",
                  label = "Number of bins:",
                  min = 0,
                  max = 50,
                  #this value is defualt value
                  value = 30,
                  #this "step" parameter change the increamnet value in th botton of no.of bins
                  step = 2)
        
      ),
    mainPanel(
      #distplot displayed in ui via plotoutput
      plotOutput(outputId = "distPlot")
    
    )
  )
)




server <- function(input,output) {
  
  #distplot is th output from the server
  output$distPlot <- renderPlot({
    
    #$ this dolar sign to specify the column from the airquality data
    x <- airquality$Ozone
    #"na" = missing value, there are missing value in airquality dataset to remove these missing value 
    #we use na.omit() function
    #x represent the no.of bins
    x <- na.omit(x)
    bins <- seq(min(x), max(x), length.out = input$bins + 1 )
    #"#75AADB" stands for color which is blue, we can also wriet "blue"
    hist(x, breaks = bins, col = "#75AADB", border = "black",
         xlab = "ozone level", 
         main = "Histogram of ozone level")
    
  })
  
}  

shinyApp(ui = ui, server = server)