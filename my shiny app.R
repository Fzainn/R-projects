#install.packages("shiny")
library(shiny)
library(ggplot2)
library(lattice)
#this line for define ui for app that draw the histogram (frontEnd_part)
# Define UI ----
ui <- fluidPage(
  
)

# Define server logic ----
server <- function(input, output) {
  
}

# Run the app ----
#shinyApp(ui = ui, server = server)
ui<-fluidPage(
  #add title...
  titlePanel("title panel"),
  #sidebar layout takes 2 argument
  sidebarLayout(position = "right",
    sidebarPanel("sidebar panel"),
    mainPanel("mainpanel")
  )
)
shinyApp(ui = ui, server = server)

h1("my title")
ui <- fluidPage(
  titlePanel("My Shiny App"),
  sidebarLayout(
    sidebarPanel(),
    mainPanel(
      h1("First level title"),
      h2("Second level title"),
      h3("Third level title"),
      h4("Fourth level title"),
      h5("Fifth level title"),
      h6("Sixth level title")
    )
  )
)
shinyApp(ui = ui, server = server)
  

    