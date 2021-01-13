# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("FBBL 2021"),
  
  sidebarPanel(
    
    #UI panel for player pool
      conditionalPanel(
        condition = "output.playerselect",
        selectInput("selected_pos", "Position", c("Hitters", "Pitchers", ALL_POSITIONS), selected="Hitters"),
        checkboxInput("drafted", "Show Drafted", value = FALSE),
        textInput(inputId = "playersearch",
                  label = "Search for Player",
                  value = "")
      ),
      #UI panel for roster tab
      selectInput("teamselect", "Team", TEAMS, selected="marmaduke")
      

  ),
  # Show a plot of the generated distribution
  mainPanel(
    tabsetPanel(
      id = "top_tabs",
      type = "tabs",
      tabPanel("Player Pool", 
               tableOutput("players")),
      tabPanel("Standings", 
               tableOutput("standings")),
      tabPanel("Rosters", 
               tableOutput("rostertable"))
    )
  )
)

