
# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$players <- renderTable({
    
    #build output table for pitchers
    if (input$selected_pos == "Pitchers") {
      
      output_table <- player_pool %>% 
        filter(position == "pitcher") %>% 
        select(Name, Team, status, IP:K, Points, Dollars)
    
    #build output table for hitters
    } else {
      if (input$selected_pos == "Hitters") {
        filtered_pool <- filter(player_pool, position != "P")
      } else if (input$selected_pos == "MI") {
        filtered_pool <- filter(player_pool, position %in% c("2b", "ss"))
      } else if (input$selected_pos == "CI") {
        filtered_pool <- filter(player_pool, position %in% c("1b", "3b"))
      }  else {
        filtered_pool <- filter(player_pool, str_detect(position, tolower(input$selected_pos)))
      }
      
      output_table <- select(filtered_pool, Name, Team, position, status, PA:AVG, Points, Dollars)
    }
    
    #filter out drafted players
    output_table
  })
}



