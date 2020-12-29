# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("FBBL 2021"),

  sidebarPanel(
    selectInput("selected_pos", "Position", c("Hitters", "Pitchers", ALL_POSITIONS), selected="Hitters")
    ),
  # Show a plot of the generated distribution
  mainPanel(
    tabsetPanel(
      type = "tabs",
      tabPanel("Player Pool", 
               tableOutput("players"))
      
    )
  )
)

